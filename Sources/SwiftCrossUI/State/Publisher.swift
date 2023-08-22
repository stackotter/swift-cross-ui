import Foundation

public class Publisher {
    private var observations = LinkedList<() -> Void>()
    private var cancellables: [Cancellable] = []

    public init() {}

    public func send() {
        // Publishers are run on the main Gtk thread so that observers can safely update the UI
        currentBackend.runInMainThread {
            for observation in self.observations {
                observation()
            }
        }
    }

    public func observe(with closure: @escaping () -> Void) -> Cancellable {
        let node = observations.append(closure)

        return Cancellable { [weak self] in
            self?.observations.remove(node)
            for cancellable in self?.cancellables ?? [] {
                cancellable.cancel()
            }
        }
    }

    public func link(toDownstream publisher: Publisher) -> Cancellable {
        let cancellable = publisher.observe(with: {
            self.send()
        })
        cancellables.append(cancellable)
        return cancellable
    }
}
