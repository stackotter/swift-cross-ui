import CGtk3

/// Describes a type of line wrapping.
public enum WrapMode: GValueRepresentableEnum {
    public typealias GtkEnum = GtkWrapMode

    /// Do not wrap lines; just make the text area wider
    case none
    /// Wrap text, breaking lines anywhere the cursor can
    /// appear (between characters, usually - if you want to be technical,
    /// between graphemes, see pango_get_log_attrs())
    case character
    /// Wrap text, breaking lines in between words
    case word
    /// Wrap text, breaking lines in between words, or if
    /// that is not enough, also between graphemes
    case wordCharacter

    public static var type: GType {
        gtk_wrap_mode_get_type()
    }

    public init(from gtkEnum: GtkWrapMode) {
        switch gtkEnum {
            case GTK_WRAP_NONE:
                self = .none
            case GTK_WRAP_CHAR:
                self = .character
            case GTK_WRAP_WORD:
                self = .word
            case GTK_WRAP_WORD_CHAR:
                self = .wordCharacter
            default:
                fatalError("Unsupported GtkWrapMode enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkWrapMode {
        switch self {
            case .none:
                return GTK_WRAP_NONE
            case .character:
                return GTK_WRAP_CHAR
            case .word:
                return GTK_WRAP_WORD
            case .wordCharacter:
                return GTK_WRAP_WORD_CHAR
        }
    }
}
