import CGtk3

extension WrapMode {
    func toPangoWrapMode() -> PangoWrapMode {
        switch self {
            case .none:
                fatalError("PangoWrapMode cannot be none")
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
                fatalError("Invalid value of PangoWrapMode: \(self.rawValue)")
        }
    }
}
