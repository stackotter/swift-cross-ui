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
        let serialUpdateHandlingQueue = DispatchQueue(
            label: "serial update handling"
        )
        let semaphore = DispatchSemaphore(value: 1)
        return observe {
            // Only allow one update to wait at a time.
            guard semaphore.wait(timeout: .now()) == .success else {
                return
            }

            // Add update to queue. We use our own serial update handling queue since some
            // backends don't have the concept of a main thread, leading to the possibility
            // that two updates can run at once which would be inefficient and lead to
            // incorrect results anyway.
            serialUpdateHandlingQueue.async {
                backend.runInMainThread {
                    // Now that we're about to start, let another update queue up. If we
                    // instead waited until we're finished the update, we'd introduce the
                    // possibility of dropping updates that would've affected views that
                    // we've already processed, leading to stale view contents.
                    semaphore.signal()

                    closure()
                }
            }
        }
    }
}
