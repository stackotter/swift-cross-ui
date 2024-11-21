import Dispatch

/// A type that produces valueless observations.
public class Publisher {
    /// The id for the next observation (ids are used to cancel observations).
    private var nextObservationId = 0
    /// All current observations keyed by their id (ids are used to cancel observations).
    private var observations: [Int: () -> Void] = [:]
    /// Cancellable observations of downstream observers.
    private var cancellables: [Cancellable] = []
    /// Human-readable tag for debugging purposes.
    private var tag: String?

    /// Creates a new independent publisher.
    public init() {}

    /// Publishes a change to all observers serially on the current thread.
    public func send() {
        for observation in self.observations.values {
            observation()
        }
    }

    /// Registers a handler to observe future events.
    public func observe(with closure: @escaping () -> Void) -> Cancellable {
        let id = nextObservationId
        observations[id] = closure
        nextObservationId += 1

        return Cancellable { [weak self] in
            guard let self = self else { return }
            self.observations[id] = nil
            if self.observations.isEmpty {
                for cancellable in self.cancellables {
                    cancellable.cancel()
                }
            }
        }
        .tag(with: tag)
    }

    /// Links the publisher to an upstream, meaning that observations from the upstream
    /// effectively get forwarded to all observers of this publisher as well.
    public func link(toUpstream publisher: Publisher) -> Cancellable {
        let cancellable = publisher.observe(with: {
            self.send()
        })
        cancellable.tag(with: "\(tag ?? "no tag") <-> \(cancellable.tag ?? "no tag")")
        cancellables.append(cancellable)
        return cancellable
    }

    @discardableResult
    func tag(with tag: @autoclosure () -> String?) -> Self {
        #if DEBUG
            self.tag = tag()
        #endif
        return self
    }

    // TODO: English this explanation more better.
    /// Observes a publisher for changes and runs an action on the main thread whenever
    /// a change occurs. This pattern generally leads to starvation if events are produced
    /// faster than the serial handler can handle them, so this method deals with that by
    /// ensuring that only one update is allowed to be waiting at any given time. The
    /// implementation guarantees that at least one update will occur after each update,
    /// but if for example 4 updates arrive while a previous update is getting serviced,
    /// then all 4 updates will get serviced by a single run of `closure`.
    ///
    /// Note that some backends don't have a concept of a main thread, so you the updates
    /// won't always end up on a 'main thread', but they are guaranteed to run serially.
    func observeOnMainThreadAvoidingStarvation<Backend: AppBackend>(
        backend: Backend,
        action closure: @escaping () -> Void
    ) -> Cancellable {
        // All of the concurrency related code is there to detect when updates can be merged
        // together (a.k.a. when one of the updates is unnecessary).
        let protectingQueue = DispatchQueue(label: "state update merging")
        let concurrentUpdateHandlingQueue = DispatchQueue(
            label: "concurrent update handling queue",
            attributes: .concurrent
        )
        let synchronizationSemaphore = DispatchSemaphore(value: 1)

        // State shared betwen all calls to the closure defined below.
        var updateIsQueued = false
        var updateIsRunning = false
        var aCurrentJobDidntHaveToWait = false

        return observe {
            // I'm sorry if you have to make sense of this... Take my comments as a peace offering.

            // Hop to a dispatch queue to avoid blocking any threads in the Swift Structured
            // Concurrency thread pool in the case that the state update originated from a task.
            concurrentUpdateHandlingQueue.async {
                // If no one is running, then we run without waiting, and if someone's running
                // but no one's waiting, then we wait and prevent anyone else from waiting.
                // This ensures that at least one update will always happen after every update
                // received so far, without letting unnecessary updates queue up. The reason
                // that we can merge updates like this is that all state updates are built equal;
                // they don't carry any information other than that they happened.
                var shouldWait = false
                protectingQueue.sync {
                    if !updateIsQueued {
                        shouldWait = true
                    }

                    if updateIsRunning {
                        updateIsQueued = true
                    } else {
                        updateIsRunning = true
                        aCurrentJobDidntHaveToWait = true
                    }
                }

                guard shouldWait else {
                    return
                }

                // Waiting just involves attempting to jump to the main thread.
                backend.runInMainThread {
                    // This semaphore is used because some backends don't put us on the main
                    // thread since they don't have the concept of a single UI thread like
                    // macOS does.
                    //
                    // If `backend.runInMainThread` is truly putting us on the main thread,
                    // then this never have to block significantly, otherwise we're just
                    // blocking some random thread, so either way we're fine since we've
                    // explicitly hopped to a dispatch queue to escape any cooperative
                    // Swift Structured Concurrency thread pool the state update may have
                    // originated from.
                    synchronizationSemaphore.wait()

                    protectingQueue.sync {
                        // If a current job didn't have to wait, then that's us. Due to
                        // concurrency that doesn't mean we were the first update triggered.
                        // That is, we could've been the job that set `updateIsQueued` to
                        // true while still being the job that reached this line first (before
                        // the one that set `updateIsRunning` to true). And that's why I've
                        // implemented the check in this way with a protected 'global' and not
                        // a local variable (being first isn't a property we can know ahead
                        // of time). I use 'global' in the sense of shared between all calls
                        // to the state update handling closure for a given ViewGraphNode.
                        //
                        // The reason that `aCurrentJobDidntHaveToWait` is needed at all is
                        // so that we can know whether `updateIsQueued`'s value is due to us
                        // or someone else/no one.
                        if aCurrentJobDidntHaveToWait {
                            aCurrentJobDidntHaveToWait = false
                        } else {
                            updateIsQueued = false
                        }
                    }

                    closure()

                    // If someone is waiting then we leave `updateIsRunning` equal to true
                    // because they'll immediately begin running as soon as we exit and we
                    // don't want an extra person queueing until they've actually started.
                    protectingQueue.sync {
                        if !updateIsQueued {
                            updateIsRunning = false
                        }
                    }

                    synchronizationSemaphore.signal()
                }
            }
        }
    }
}
