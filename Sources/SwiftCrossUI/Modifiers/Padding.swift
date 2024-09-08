extension View {
    /// Adds a specific padding amount to each edge of this view.
    public func padding(_ amount: Int) -> some View {
        return PaddingModifierView(body: TupleView1(self), edges: .all, padding: amount)
    }

    /// Adds an equal padding amount to specific edges of this view.
    public func padding(_ edges: Edge.Set, _ amount: Int) -> some View {
        return PaddingModifierView(body: TupleView1(self), edges: edges, padding: amount)
    }
}

/// The implementation for the ``View/padding(_:_:)`` and ``View/padding(_:)`` view modifiers.
struct PaddingModifierView<Child: View>: TypeSafeView {
    var body: TupleView1<Child>

    /// The edges on which to apply padding.
    var edges: Edge.Set
    /// The amount of padding to apply to the child view.
    var padding: Int

    public var flexibility: Int {
        body.flexibility - 10
    }

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: Environment
    ) -> TupleViewChildren1<Child> {
        body.children(backend: backend, snapshots: snapshots, environment: environment)
    }

    func asWidget<Backend: AppBackend>(
        _ children: TupleViewChildren1<Child>,
        backend: Backend
    ) -> Backend.Widget {
        let container = backend.createContainer()
        backend.addChild(children.child0.widget.into(), to: container)
        return container
    }

    func update<Backend: AppBackend>(
        _ container: Backend.Widget,
        children: TupleViewChildren1<Child>,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend
    ) -> ViewUpdateResult {
        let topPadding = edges.contains(.top) ? padding : 0
        let bottomPadding = edges.contains(.bottom) ? padding : 0
        let leadingPadding = edges.contains(.leading) ? padding : 0
        let trailingPadding = edges.contains(.trailing) ? padding : 0

        let childSize = children.child0.update(
            with: body.view0,
            proposedSize: SIMD2(
                proposedSize.x - leadingPadding - trailingPadding,
                proposedSize.y - topPadding - bottomPadding
            ),
            environment: environment
        )

        let size = SIMD2(
            childSize.size.x + leadingPadding + trailingPadding,
            childSize.size.y + topPadding + bottomPadding
        )
        backend.setSize(of: container, to: size)
        backend.setPosition(ofChildAt: 0, in: container, to: SIMD2(topPadding, leadingPadding))

        return ViewUpdateResult(
            size: size,
            minimumWidth: childSize.minimumWidth + leadingPadding + trailingPadding,
            minimumHeight: childSize.minimumHeight + topPadding + bottomPadding
        )
    }
}
