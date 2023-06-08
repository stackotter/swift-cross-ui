import CGtk
import Foundation

public class Publisher {
    private var observations = LinkedList<() -> Void>()
    private var cancellables: [Cancellable] = []

    public init() {}

    public func send() {
        // Publishers are run on the main Gtk thread so that observers can safely update the UI
        g_idle_add_full(
            0,
            { context in
                guard let context = context else {
                    fatalError("Publisher callback called without context")
                }

                let observations = context.assumingMemoryBound(to: LinkedList<() -> Void>.self).pointee
                for observation in observations {
                    observation()
                }

                return 0
            },
            &observations,
            { _ in }
        )
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
