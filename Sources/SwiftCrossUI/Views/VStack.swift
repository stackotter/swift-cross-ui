/// A view that arranges its subviews vertically.
public struct VStack<Content: View>: View {
    static var defaultSpacing: Int { 10 }

    public var body: Content

    /// The amount of spacing to apply between children.
    private var spacing: Int
    /// The alignment of the stack's children in the horizontal direction.
    private var alignment: HorizontalAlignment

    /// Creates a vertical stack with the given spacing and alignment.
    ///
    /// - Parameters:
    ///   - alignment: The alignment of the stack's children in the horizontal
    ///     direction.
    ///   - spacing: The amount of spacing to apply between children.
    ///   - content: The content of this stack.
    public init(
        alignment: HorizontalAlignment = .center,
        spacing: Int? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.init(alignment: alignment, spacing: spacing, content: content())
    }

    /// Creates a vertical stack with the given spacing and alignment.
    ///
    /// - Parameters:
    ///   - alignment: The alignment of the stack's children in the horizontal
    ///     direction.
    ///   - spacing: The amount of spacing to apply between children.
    ///   - content: The content of this stack.
    init(
        alignment: HorizontalAlignment = .center,
        spacing: Int? = nil,
        content: Content
    ) {
        body = content
        self.spacing = spacing ?? Self.defaultSpacing
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
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        return LayoutSystem.updateStackLayout(
            container: widget,
            children: layoutableChildren(backend: backend, children: children),
            proposedSize: proposedSize,
            environment:
                environment
                .with(\.layoutOrientation, .vertical)
                .with(\.layoutAlignment, alignment.asStackAlignment)
                .with(\.layoutSpacing, spacing),
            backend: backend,
            dryRun: dryRun
        )
    }
}
