/// A view that arranges its subviews vertically.
public struct VStack<Content: View>: View {
    public var body: Content

    /// The amount of spacing to apply between children.
    private var spacing: Int

    public var flexibility: Int {
        300
    }

    /// Creates a horizontal stack with the given spacing.
    public init(spacing: Int = 10, @ViewBuilder _ content: () -> Content) {
        body = content()
        self.spacing = spacing
    }

    init(spacing: Int = 10, _ content: Content) {
        body = content
        self.spacing = spacing
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
        parentOrientation: Orientation,
        backend: Backend
    ) -> SIMD2<Int> {
        return LayoutSystem.updateStackLayout(
            container: widget,
            children: layoutableChildren(backend: backend, children: children),
            proposedSize: proposedSize,
            orientation: .vertical,
            spacing: spacing,
            backend: backend
        )
    }
}
