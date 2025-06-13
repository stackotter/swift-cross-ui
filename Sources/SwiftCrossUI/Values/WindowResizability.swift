/// The level of resizability of a window.
public enum WindowResizability: Sendable {
    /// SwiftCrossUI decides whether to use `contentSize` or `contentMinSize` depending
    /// on the type of scene. This currently means it'll just default to `contentMinSize`.
    case automatic
    /// The window is not resizable and its size is tied to the size of its content.
    case contentSize
    /// The window is resizable but must be at least as big as its content.
    case contentMinSize

    /// Whether this level of resizability implies that the window is resizable.
    var isResizable: Bool {
        switch self {
            case .automatic, .contentMinSize:
                return true
            case .contentSize:
                return false
        }
    }
}
