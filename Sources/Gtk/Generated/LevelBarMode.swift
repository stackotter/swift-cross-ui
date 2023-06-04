import CGtk

/// Describes how [class@LevelBar] contents should be rendered.
///
/// Note that this enumeration could be extended with additional modes
/// in the future.
public enum LevelBarMode {
    /// The bar has a continuous mode
    case continuous
    /// The bar has a discrete mode
    case discrete

    /// Converts the value to its corresponding Gtk representation.
    func toGtkLevelBarMode() -> GtkLevelBarMode {
        switch self {
            case .continuous:
                return GTK_LEVEL_BAR_MODE_CONTINUOUS
            case .discrete:
                return GTK_LEVEL_BAR_MODE_DISCRETE
        }
    }
}

extension GtkLevelBarMode {
    /// Converts a Gtk value to its corresponding swift representation.
    func toLevelBarMode() -> LevelBarMode {
        switch self {
            case GTK_LEVEL_BAR_MODE_CONTINUOUS:
                return .continuous
            case GTK_LEVEL_BAR_MODE_DISCRETE:
                return .discrete
            default:
                fatalError("Unsupported GtkLevelBarMode enum value: \(self.rawValue)")
        }
    }
}
