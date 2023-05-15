import CGtk

/// See also gtk_print_settings_set_orientation().
/// 
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.PageOrientation.html)
public enum PageOrientation {
    /// Portrait mode.
    case portrait
    /// Landscape mode.
    case landscape
    /// Reverse portrait mode.
    case reversePortrait
    /// Reverse landscape mode.
    case reverseLandscape

    func toGtkPageOrientation() -> GtkPageOrientation {
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

extension GtkPageOrientation {
    func toPageOrientation() -> PageOrientation {
        switch self {
        case GTK_PAGE_ORIENTATION_PORTRAIT:
            return .portrait
        case GTK_PAGE_ORIENTATION_LANDSCAPE:
            return .landscape
        case GTK_PAGE_ORIENTATION_REVERSE_PORTRAIT:
            return .reversePortrait
        case GTK_PAGE_ORIENTATION_REVERSE_LANDSCAPE:
            return .reverseLandscape
        default:
            fatalError("Unsupported GtkPageOrientation enum value: \(self.rawValue)")
        }
    }
}
