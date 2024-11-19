import CGtk3

/// See also gtk_print_settings_set_orientation().
public enum PageOrientation: GValueRepresentableEnum {
    public typealias GtkEnum = GtkPageOrientation

    /// Portrait mode.
    case portrait
    /// Landscape mode.
    case landscape
    /// Reverse portrait mode.
    case reversePortrait
    /// Reverse landscape mode.
    case reverseLandscape

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkPageOrientation) {
        switch gtkEnum {
            case GTK_PAGE_ORIENTATION_PORTRAIT:
                self = .portrait
            case GTK_PAGE_ORIENTATION_LANDSCAPE:
                self = .landscape
            case GTK_PAGE_ORIENTATION_REVERSE_PORTRAIT:
                self = .reversePortrait
            case GTK_PAGE_ORIENTATION_REVERSE_LANDSCAPE:
                self = .reverseLandscape
            default:
                fatalError("Unsupported GtkPageOrientation enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkPageOrientation {
        switch self {
            case .portrait:
                return GTK_PAGE_ORIENTATION_PORTRAIT
            case .landscape:
                return GTK_PAGE_ORIENTATION_LANDSCAPE
            case .reversePortrait:
                return GTK_PAGE_ORIENTATION_REVERSE_PORTRAIT
            case .reverseLandscape:
                return GTK_PAGE_ORIENTATION_REVERSE_LANDSCAPE
        }
    }
}
