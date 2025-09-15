import CGtk

/// Describes how [class@LevelBar] contents should be rendered.
///
/// Note that this enumeration could be extended with additional modes
/// in the future.
public enum LevelBarMode: GValueRepresentableEnum {
    public typealias GtkEnum = GtkLevelBarMode

    /// The bar has a continuous mode
    case continuous
    /// The bar has a discrete mode
    case discrete

    public static var type: GType {
        gtk_level_bar_mode_get_type()
    }

    public init(from gtkEnum: GtkLevelBarMode) {
        switch gtkEnum {
            case GTK_LEVEL_BAR_MODE_CONTINUOUS:
                self = .continuous
            case GTK_LEVEL_BAR_MODE_DISCRETE:
                self = .discrete
            default:
                fatalError("Unsupported GtkLevelBarMode enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkLevelBarMode {
        switch self {
            case .continuous:
                return GTK_LEVEL_BAR_MODE_CONTINUOUS
            case .discrete:
                return GTK_LEVEL_BAR_MODE_DISCRETE
        }
    }
}
