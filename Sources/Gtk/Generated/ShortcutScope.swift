import CGtk

/// Describes where [class@Shortcut]s added to a
/// [class@ShortcutController] get handled.
public enum ShortcutScope {
    /// Shortcuts are handled inside
    /// the widget the controller belongs to.
    case local
    /// Shortcuts are handled by
    /// the first ancestor that is a [iface@ShortcutManager]
    case managed
    /// Shortcuts are handled by
    /// the root widget.
    case global

    /// Converts the value to its corresponding Gtk representation.
    func toGtkShortcutScope() -> GtkShortcutScope {
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

extension GtkShortcutScope {
    /// Converts a Gtk value to its corresponding swift representation.
    func toShortcutScope() -> ShortcutScope {
        switch self {
            case GTK_SHORTCUT_SCOPE_LOCAL:
                return .local
            case GTK_SHORTCUT_SCOPE_MANAGED:
                return .managed
            case GTK_SHORTCUT_SCOPE_GLOBAL:
                return .global
            default:
                fatalError("Unsupported GtkShortcutScope enum value: \(self.rawValue)")
        }
    }
}
