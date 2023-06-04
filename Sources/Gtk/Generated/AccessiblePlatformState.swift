import CGtk

/// The various platform states which can be queried
/// using [method@Gtk.Accessible.get_platform_state].
public enum AccessiblePlatformState {
    /// Whether the accessible can be focused
    case focusable
    /// Whether the accessible has focus
    case focused
    /// Whether the accessible is active
    case active

    /// Converts the value to its corresponding Gtk representation.
    func toGtkAccessiblePlatformState() -> GtkAccessiblePlatformState {
        switch self {
            case .focusable:
                return GTK_ACCESSIBLE_PLATFORM_STATE_FOCUSABLE
            case .focused:
                return GTK_ACCESSIBLE_PLATFORM_STATE_FOCUSED
            case .active:
                return GTK_ACCESSIBLE_PLATFORM_STATE_ACTIVE
        }
    }
}

extension GtkAccessiblePlatformState {
    /// Converts a Gtk value to its corresponding swift representation.
    func toAccessiblePlatformState() -> AccessiblePlatformState {
        switch self {
            case GTK_ACCESSIBLE_PLATFORM_STATE_FOCUSABLE:
                return .focusable
            case GTK_ACCESSIBLE_PLATFORM_STATE_FOCUSED:
                return .focused
            case GTK_ACCESSIBLE_PLATFORM_STATE_ACTIVE:
                return .active
            default:
                fatalError("Unsupported GtkAccessiblePlatformState enum value: \(self.rawValue)")
        }
    }
}
