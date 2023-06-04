import CGtk

/// The level of granularity for the font selection.
///
/// Depending on this value, the `PangoFontDescription` that
/// is returned by [method@Gtk.FontDialogButton.get_font_desc]
/// will have more or less fields set.
public enum FontLevel {
    /// Select a font family
    case family
    /// Select a font face (i.e. a family and a style)
    case face
    /// Select a font (i.e. a face with a size, and possibly font variations)
    case font
    /// Select a font and font features
    case features

    /// Converts the value to its corresponding Gtk representation.
    func toGtkFontLevel() -> GtkFontLevel {
        switch self {
            case .family:
                return GTK_FONT_LEVEL_FAMILY
            case .face:
                return GTK_FONT_LEVEL_FACE
            case .font:
                return GTK_FONT_LEVEL_FONT
            case .features:
                return GTK_FONT_LEVEL_FEATURES
        }
    }
}

extension GtkFontLevel {
    /// Converts a Gtk value to its corresponding swift representation.
    func toFontLevel() -> FontLevel {
        switch self {
            case GTK_FONT_LEVEL_FAMILY:
                return .family
            case GTK_FONT_LEVEL_FACE:
                return .face
            case GTK_FONT_LEVEL_FONT:
                return .font
            case GTK_FONT_LEVEL_FEATURES:
                return .features
            default:
                fatalError("Unsupported GtkFontLevel enum value: \(self.rawValue)")
        }
    }
}
