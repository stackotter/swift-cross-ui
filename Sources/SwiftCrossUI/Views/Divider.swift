/// A divider that expands along the minor axis of the containing stack layout
/// (or horizontally otherwise). In dark mode it's white with 10% opacity, and
/// in light mode it's black with 10% opacity.
public struct Divider: View {
    @Environment(\.colorScheme) var colorScheme

    var color: Color {
        switch colorScheme {
            case .dark:
                Color(1, 1, 1, 0.1)
            case .light:
                Color(0, 0, 0, 0.1)
        }
    }

    public init() {}

    public var body: some View {
        color.frame(height: 1)
    }
}
