import CGtk

/// Describes where [class@Shortcut]s added to a
/// [class@ShortcutController] get handled.
public enum ShortcutScope: GValueRepresentableEnum {
    public typealias GtkEnum = GtkShortcutScope

    /// Shortcuts are handled inside
    /// the widget the controller belongs to.
    case local
    /// Shortcuts are handled by
    /// the first ancestor that is a [iface@ShortcutManager]
    case managed
    /// Shortcuts are handled by
    /// the root widget.
    case global

    public static var type: GType {
        gtk_shortcut_scope_get_type()
    }

    public init(from gtkEnum: GtkShortcutScope) {
        switch gtkEnum {
            case GTK_SHORTCUT_SCOPE_LOCAL:
                self = .local
            case GTK_SHORTCUT_SCOPE_MANAGED:
                self = .managed
            case GTK_SHORTCUT_SCOPE_GLOBAL:
                self = .global
            default:
                fatalError("Unsupported GtkShortcutScope enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkShortcutScope {
        switch self {
            case .local:
                return GTK_SHORTCUT_SCOPE_LOCAL
            case .managed:
                return GTK_SHORTCUT_SCOPE_MANAGED
            case .global:
                return GTK_SHORTCUT_SCOPE_GLOBAL
        }
    }
}
