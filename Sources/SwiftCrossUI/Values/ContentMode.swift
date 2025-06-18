/// How a view fills the available space.
public enum ContentMode: Sendable {
    /// Resize the content so that it takes up all available space while
    /// maintaining aspect ratio.
    case fill
    /// Resize the content so that it takes up as much of the available space
    /// as possible while staying within its bounds and maintaining aspect ratio.
    case fit

    /// An internal helper used when sizing a frame based of its child instead
    /// of the other way around.
    var opposite: ContentMode {
        switch self {
            case .fill: .fit
            case .fit: .fill
        }
    }
}
