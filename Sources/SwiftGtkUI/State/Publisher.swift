import Foundation
import CGtk

public class Publisher {
    private var observations = List<() -> Void>()
    private var cancellables: [Cancellable] = []
    
    #if os(macOS)
    private var queue = DispatchQueue.main
    #else
    private var queue = DispatchQueue(label: "Publisher")
    #endif

    public init() {}

    private func notifyObservers() {
        for observation in self.observations {
            observation()
        }
    }

    private func notifyObserversCallbackC(_ ptr: UnsafeMutableRawPointer?) -> Int32 {
        self.notifyObservers()
        return 0
    }
    
    public func send() {
        g_idle_add_full(0, { context in
            guard let context = context else {
                print("warning: Publisher callback called without context")
                return 0
            }

            let observations = context.assumingMemoryBound(to: List<() -> Void>.self).pointee
            for observation in observations {
                observation()
            }

            return 0
        }, &observations, { _ in })
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
    
    public func link(toDownstream publisher: Publisher) {
        cancellables.append(publisher.observe(with: {
            self.send()
        }))
    }
}
