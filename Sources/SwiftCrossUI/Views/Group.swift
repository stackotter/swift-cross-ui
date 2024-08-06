/// A view that groups views together without affecting their layout (allowing
/// modifiers to be applied to a whole group of views at once).
public struct Group<Content: View>: View {
    public var body: Content

    public var flexibility: Int {
        300
    }

    /// Creates a horizontal stack with the given spacing.
    public init(@ViewBuilder content: () -> Content) {
        self.init(content: content())
    }

    init(content: Content) {
        body = content
    }

    public func asWidget<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren,
        backend: Backend
    ) -> Backend.Widget {
        let container = backend.createContainer()
        for child in children.widgets(for: backend) {
            backend.addChild(child, to: container)
        }
        return container
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
            environment: environment,
            backend: backend
        )
    }
}
