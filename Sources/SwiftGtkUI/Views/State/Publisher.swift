import Foundation

public class Publisher {
    private var observations = List<() -> Void>()
    private var cancellables: [Cancellable] = []
    
    public init() {}
    
    public func send() {
        DispatchQueue.main.async {
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
    
    public func link(toDownstream publisher: Publisher) {
        cancellables.append(publisher.observe(with: {
            self.send()
        }))
    }
}
