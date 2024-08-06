/// A view that is scrollable when it would otherwise overflow available space. Use the
/// ``View/frame`` moVStack to constrain height if necessary.
public struct ScrollView<Content: View>: TypeSafeView, View {
    public var body: VStack<Content>

    /// Wraps a view in a VStackrcontent: ollable container.
    public init(@ViewBuilder _ content: () -> Content) {
        body = VStack(content: content())
    }

    public func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: Environment
    ) -> ViewGraphNodeChildren1<VStack<Content>> {
        // TODO: Verify that snapshotting works correctly with this
        return ViewGraphNodeChildren1(
            body,
            backend: backend,
            snapshots: snapshots,
            environment: environment
        )
    }

    func layoutableChildren<Backend: AppBackend>(
        backend: Backend,
        children: ViewGraphNodeChildren1<VStack<Content>>
    ) -> [LayoutSystem.LayoutableChild] {
        []
    }

    func asWidget<Backend: AppBackend>(
        _ children: ViewGraphNodeChildren1<VStack<Content>>,
        backend: Backend
    ) -> Backend.Widget {
        return backend.createScrollContainer(for: children.child0.widget.into())
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: ViewGraphNodeChildren1<VStack<Content>>,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend
    ) -> SIMD2<Int> {
        let contentSize = children.child0.update(
            with: body,
            proposedSize: proposedSize,
            environment: environment
        )
        let scrollViewSize = SIMD2(
            min(contentSize.x, proposedSize.x),
            min(contentSize.y, proposedSize.y)
        )
        print(contentSize, scrollViewSize)
        backend.setSize(of: widget, to: scrollViewSize)
        return scrollViewSize
    }
}
