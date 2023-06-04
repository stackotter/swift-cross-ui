import CGtk

/// Describes how a [class@Gtk.StringSorter] turns strings into sort keys to
/// compare them.
///
/// Note that the result of sorting will in general depend on the current locale
/// unless the mode is @GTK_COLLATION_NONE.
public enum Collation {
    /// Don't do any collation
    case none
    /// Use [func@GLib.utf8_collate_key]
    case unicode
    /// Use [func@GLib.utf8_collate_key_for_filename]
    case filename

    /// Converts the value to its corresponding Gtk representation.
    func toGtkCollation() -> GtkCollation {
        switch self {
            case .none:
                return GTK_COLLATION_NONE
            case .unicode:
                return GTK_COLLATION_UNICODE
            case .filename:
                return GTK_COLLATION_FILENAME
        }
    }
}

extension GtkCollation {
    /// Converts a Gtk value to its corresponding swift representation.
    func toCollation() -> Collation {
        switch self {
            case GTK_COLLATION_NONE:
                return .none
            case GTK_COLLATION_UNICODE:
                return .unicode
            case GTK_COLLATION_FILENAME:
                return .filename
            default:
                fatalError("Unsupported GtkCollation enum value: \(self.rawValue)")
        }
    }
}
