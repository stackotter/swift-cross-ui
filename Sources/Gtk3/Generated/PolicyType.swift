import CGtk3

/// Determines how the size should be computed to achieve the one of the
/// visibility mode for the scrollbars.
public enum PolicyType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkPolicyType

    /// The scrollbar is always visible. The view size is
    /// independent of the content.
    case always
    /// The scrollbar will appear and disappear as necessary.
    /// For example, when all of a #GtkTreeView can not be seen.
    case automatic
    /// The scrollbar should never appear. In this mode the
    /// content determines the size.
    case never

    public static var type: GType {
        gtk_policy_type_get_type()
    }

    public init(from gtkEnum: GtkPolicyType) {
        switch gtkEnum {
            case GTK_POLICY_ALWAYS:
                self = .always
            case GTK_POLICY_AUTOMATIC:
                self = .automatic
            case GTK_POLICY_NEVER:
                self = .never
            default:
                fatalError("Unsupported GtkPolicyType enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkPolicyType {
        switch self {
            case .always:
                return GTK_POLICY_ALWAYS
            case .automatic:
                return GTK_POLICY_AUTOMATIC
            case .never:
                return GTK_POLICY_NEVER
        }
    }
}
