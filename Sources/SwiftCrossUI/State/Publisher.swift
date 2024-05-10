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

    /// Publishes a change to all observers (on the main thread of the currently selected backend).
    ///
    /// Uses ``currentBackend`` as the current backend. Unfortunately this is required to avoid
    /// the selected backend leaking into state observation.
    public func send() {
        // Publishers are run on the main Gtk thread so that observers can safely update the UI
        currentBackend.runInMainThread {
            for observation in self.observations.values {
                observation()
            }
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
}
