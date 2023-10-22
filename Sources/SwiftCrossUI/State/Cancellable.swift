/// Will run a 'cancel' action when the cancellable falls out of scope (gets
/// deinit'd by ARC). Protects against calling the action twice.
public class Cancellable {
    /// The cancel action to call on deinit.
    private var closure: (() -> Void)?

    /// Creates a new cancellable.
    public init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    /// Runs the cancel action.
    deinit {
        cancel()
    }

    /// Runs the cancel action and ensures that it can be called a second time.
    public func cancel() {
        closure?()
        closure = nil
    }
}
