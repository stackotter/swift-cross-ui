import CGtk

/// Options for selecting a different wrap mode for natural size
/// requests.
///
/// See for example the [property@Gtk.Label:natural-wrap-mode] property.
public enum NaturalWrapMode {
    /// Inherit the minimum size request.
    /// In particular, this should be used with %PANGO_WRAP_CHAR.
    case inherit
    /// Try not to wrap the text. This mode is the
    /// closest to GTK3's behavior but can lead to a wide label leaving
    /// lots of empty space below the text.
    case none
    /// Attempt to wrap at word boundaries. This
    /// is useful in particular when using %PANGO_WRAP_WORD_CHAR as the
    /// wrap mode.
    case word

    /// Converts the value to its corresponding Gtk representation.
    func toGtkNaturalWrapMode() -> GtkNaturalWrapMode {
        switch self {
            case .inherit:
                return GTK_NATURAL_WRAP_INHERIT
            case .none:
                return GTK_NATURAL_WRAP_NONE
            case .word:
                return GTK_NATURAL_WRAP_WORD
        }
    }
}

extension GtkNaturalWrapMode {
    /// Converts a Gtk value to its corresponding swift representation.
    func toNaturalWrapMode() -> NaturalWrapMode {
        switch self {
            case GTK_NATURAL_WRAP_INHERIT:
                return .inherit
            case GTK_NATURAL_WRAP_NONE:
                return .none
            case GTK_NATURAL_WRAP_WORD:
                return .word
            default:
                fatalError("Unsupported GtkNaturalWrapMode enum value: \(self.rawValue)")
        }
    }
}
