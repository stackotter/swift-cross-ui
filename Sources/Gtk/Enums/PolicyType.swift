import CGtk

/// Determines how the size should be computed to achieve the one of the visibility mode for the scrollbars.
/// 
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.PolicyType.html)
public enum PolicyType {
    /// The scrollbar is always visible. The view size is independent of the content.
    case always
    /// The scrollbar will appear and disappear as necessary. For example, when all of a `GtkTreeView` can not be seen.
    case automatic
    /// The scrollbar should never appear. In this mode the content determines the size.
    case never
    /// Don’t show a scrollbar, but don’t force the size to follow the content. This can be used e.g. to make multiple scrolled windows share a scrollbar. Since: 3.16.
    case external

    func toGtkPolicyType() -> GtkPolicyType {
        switch self {
        case .always:
            return GTK_POLICY_ALWAYS
        case .automatic:
            return GTK_POLICY_AUTOMATIC
        case .never:
            return GTK_POLICY_NEVER
        case .external:
            return GTK_POLICY_EXTERNAL
        }
    }
}

extension GtkPolicyType {
    func toPolicyType() -> PolicyType {
        switch self {
        case GTK_POLICY_ALWAYS:
            return .always
        case GTK_POLICY_AUTOMATIC:
            return .automatic
        case GTK_POLICY_NEVER:
            return .never
        case GTK_POLICY_EXTERNAL:
            return .external
        default:
            fatalError("Unsupported GtkPolicyType enum value: \(self.rawValue)")
        }
    }
}
