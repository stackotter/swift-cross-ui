/// Will run a 'cancel' action when the cancellable falls out of scope (gets
/// deinit'd by ARC). Protects against calling the action twice.
public class Cancellable {
    /// The cancel action to call on deinit.
    private var closure: (() -> Void)?
    /// Human-readable tag for debugging purposes.
    var tag: String?

    /// If defused, the cancellable won't cancel the ongoing action on deinit.
    var defused = false

    /// Creates a new cancellable.
    public init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    /// Extends a cancellable's lifetime to match its corresponding ongoing
    /// action. This doesn't actually extend the
    func defuse() {
        defused = true
    }

    /// Runs the cancel action.
    deinit {
        if !defused {
            cancel()
        }
    }

    /// Runs the cancel action and ensures that it can't be called a second time.
    public func cancel() {
        closure?()
        closure = nil
    }

    @discardableResult
    func tag(with tag: @autoclosure () -> String?) -> Self {
        #if DEBUG
            self.tag = tag()
        #endif
        return self
    }
}
