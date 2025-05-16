public enum Font {
    case system(size: Int, weight: Weight? = nil, design: Design? = nil)

    public enum Weight {
        case black
        case bold
        case heavy
        case light
        case medium
        case regular
        case semibold
        case thin
        case ultraLight
    }

    public enum Design {
        case `default`
        case monospaced
    }
}
