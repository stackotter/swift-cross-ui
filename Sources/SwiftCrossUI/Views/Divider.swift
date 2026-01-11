/// A divider that expands along the minor axis of the containing stack layout.
///
/// If not contained within a stack, this view expands horizontally.
///
/// In dark mode it's white with 10% opacity, and in light mode it's black with
/// 10% opacity.
public struct Divider: View, Sendable {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.layoutOrientation) var layoutOrientation

    var color: Color {
        switch colorScheme {
            case .dark:
                Color(1, 1, 1, 0.1)
            case .light:
                Color(0, 0, 0, 0.1)
        }
    }

    /// Creates a divider.
    public init() {}

    public var body: some View {
        color.frame(
            width: layoutOrientation == .horizontal ? 1 : nil,
            height: layoutOrientation == .vertical ? 1 : nil
        )
    }
}
