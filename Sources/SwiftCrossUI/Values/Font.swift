public enum Font: Sendable {
    case system(size: Int, weight: Weight? = nil, design: Design? = nil)

    public enum Weight: Sendable {
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

    public enum Design: Sendable {
        case `default`
        case monospaced
    }
}
