/// Alignment of items layed out along the horizontal axis.
public enum HorizontalAlignment: Sendable {
    case leading
    case center
    case trailing

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
