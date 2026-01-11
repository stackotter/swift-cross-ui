/// Alignment of items layed out along the horizontal axis.
public enum HorizontalAlignment: Sendable {
    /// Leading alignment (left in left-to-right locales).
    case leading
    /// Center alignment.
    case center
    /// Trailing alignment (right in left-to-right locales).
    case trailing

    /// Converts this value to a ``StackAlignment``.
    var asStackAlignment: StackAlignment {
        switch self {
            case .leading:
                .leading
            case .center:
                .center
            case .trailing:
                .trailing
        }
    }
}
