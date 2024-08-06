/// A view that arranges its subviews horizontally.
public struct HStack<Content: View>: View {
    public var body: Content

    /// The amount of spacing to apply between children.
    private var spacing: Int
    /// The alignment of the stack's children in the vertical direction.
    private var alignment: VerticalAlignment

    public var flexibility: Int {
        300
    }

    /// Creates a horizontal stack with the given spacing.
    public init(
        alignment: VerticalAlignment = .center,
        spacing: Int? = nil,
        @ViewBuilder _ content: () -> Content
    ) {
        body = content()
        self.spacing = spacing ?? VStack<EmptyView>.defaultSpacing
        self.alignment = alignment
    }

    public func asWidget<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren,
        backend: Backend
    ) -> Backend.Widget {
        let vStack = backend.createContainer()
        for child in children.widgets(for: backend) {
            backend.addChild(child, to: vStack)
        }
        return vStack
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend
    ) -> SIMD2<Int> {
        return LayoutSystem.updateStackLayout(
            container: widget,
            children: layoutableChildren(backend: backend, children: children),
            proposedSize: proposedSize,
            environment:
                environment
                .with(\.layoutOrientation, .horizontal)
                .with(\.layoutAlignment, alignment.asStackAlignment)
                .with(\.layoutSpacing, spacing),
            backend: backend
        )
    }
}
