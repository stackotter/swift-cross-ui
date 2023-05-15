import CGtk

/// Describes a type of line wrapping.
public enum WrapMode {
    /// Wrap text, breaking lines anywhere the cursor can appear (between characters, usually - if you want to be technical, between graphemes, see pango_get_log_attrs())
    case character
    /// Wrap text, breaking lines in between words.
    case word
    /// Wrap text, breaking lines in between words, or if that is not enough, also between graphemes.
    case wordCharacter

    func toPangoWrapMode() -> PangoWrapMode {
        switch self {
            case .character:
                return PANGO_WRAP_CHAR
            case .word:
                return PANGO_WRAP_WORD
            case .wordCharacter:
                return PANGO_WRAP_WORD_CHAR
        }
    }
}

extension PangoWrapMode {
    func toWrapMode() -> WrapMode {
        switch self {
            case PANGO_WRAP_CHAR:
                return .character
            case PANGO_WRAP_WORD:
                return .word
            case PANGO_WRAP_WORD_CHAR:
                return .wordCharacter
            default:
                fatalError("Unsupported PangoWrapMode enum value: \(self.rawValue)")
        }
    }
}
