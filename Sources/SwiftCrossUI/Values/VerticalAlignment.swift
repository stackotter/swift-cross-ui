/// Alignment of items layed out along the vertical axis.
public enum VerticalAlignment {
    case top
    case center
    case bottom

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
