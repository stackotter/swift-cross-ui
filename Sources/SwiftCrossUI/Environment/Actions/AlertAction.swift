/// An alert action button.
///
/// Only backends should interface with this type directly. This exists to avoid
/// having to expose internal details of ``Button``, since breaking `Button`'s
/// API would have much more wide-reaching impacts than breaking this
/// single-purpose API.
///
/// # See Also
/// - ``View/alert(_:isPresented:actions:)``
public struct AlertAction: Sendable {
    public static let `default` = AlertAction(label: "OK", action: {})

    /// The button's label.
    public var label: String
    /// The button's action.
    public var action: @MainActor @Sendable () -> Void
}
