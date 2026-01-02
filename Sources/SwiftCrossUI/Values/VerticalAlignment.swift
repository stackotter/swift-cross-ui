/// Alignment of items layed out along the vertical axis.
public enum VerticalAlignment: Sendable {
    /// Top alignment.
    case top
    /// Center alignment.
    case center
    /// Bottom alignment.
    case bottom

    /// Converts this value to a ``StackAlignment``.
    var asStackAlignment: StackAlignment {
        switch self {
            case .top:
                .leading
            case .center:
                .center
            case .bottom:
                .trailing
        }
    }
}
