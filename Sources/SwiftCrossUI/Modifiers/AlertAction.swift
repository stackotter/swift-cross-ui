/// An alert action button. Only backends should interface with this type
/// directly. See ``View/alert(_:isPresented:actions:message:)``.
///
/// This exists to avoid having to expose internal details of ``Button``, since
/// breaking ``Button``'s API would have much more wide-reaching impacts than
/// breaking this single-purpose API.
public struct AlertAction {
    public static let ok = AlertAction(label: "Ok", action: {})

    public var label: String
    public var action: () -> Void

    public init(
        label: String, 
        action: @escaping () -> Void) {
        self.label = label
        self.action = action
    }
}
