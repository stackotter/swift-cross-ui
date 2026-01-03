/// An alert action button. Only backends should interface with this type
/// directly. See ``View/alert(_:isPresented:actions:message:)``.
///
/// This exists to avoid having to expose internal details of ``Button``, since
/// breaking ``Button``'s API would have much more wide-reaching impacts than
/// breaking this single-purpose API.
public struct AlertAction: Sendable {
    public static let ok = AlertAction(label: "OK", action: {})

    public var label: String
    public var action: @MainActor @Sendable () -> Void
}
