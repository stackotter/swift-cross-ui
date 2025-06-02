/// A divider that expands along the minor axis of the containing stack layout
/// (or horizontally otherwise). In dark mode it's white with 10% opacity, and
/// in light mode it's black with 10% opacity.
public struct Divider: View, Sendable {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.layoutOrientation) var layoutOrientation

    let requestedColor: Color?

    var color: Color {
        if let requestedColor {
            requestedColor
        } else {
            switch colorScheme {
                case .dark:
                    Color(1, 1, 1, 0.1)
                case .light:
                    Color(0, 0, 0, 0.1)
            }
        }
    }

    /// Creates a divider. Uses the provided color, or adapts to the current
    /// color scheme if nil.
    public init(_ color: Color? = nil) {
        self.requestedColor = color
    }

    public var body: some View {
        color.frame(
            width: layoutOrientation == .horizontal ? 1 : nil,
            height: layoutOrientation == .vertical ? 1 : nil
        )
    }
}
