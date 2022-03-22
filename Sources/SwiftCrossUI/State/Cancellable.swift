public class Cancellable {
    private var closure: (() -> Void)?
    
    public init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    deinit {
        cancel()
    }
    
    public func cancel() {
        closure?()
        closure = nil
    }
}
