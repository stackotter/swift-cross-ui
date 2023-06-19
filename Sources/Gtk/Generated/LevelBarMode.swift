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

    /// Converts a Gtk value to its corresponding swift representation.
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

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkLevelBarMode {
        switch self {
            case .continuous:
                return GTK_LEVEL_BAR_MODE_CONTINUOUS
            case .discrete:
                return GTK_LEVEL_BAR_MODE_DISCRETE
        }
    }
}
