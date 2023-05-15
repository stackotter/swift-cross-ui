import CGtk

/// Describes how GtkLevelBar contents should be rendered. Note that this enumeration could be extended with additional modes in the future.
/// 
/// Available since:	3.6
///
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.LevelBarMode.html)
public enum LevelBarMode {
    /// The bar has a continuous mode.
    case continuous
    /// The bar has a discrete mode.
    case discrete

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
