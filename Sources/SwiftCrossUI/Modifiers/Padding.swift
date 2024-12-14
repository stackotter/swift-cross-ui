extension View {
    /// Adds padding to a view. If `amount` is `nil`, then a backend-specific default value
    /// is used. Separate from ``View/padding(_:_:)`` because overload resolution didn't
    /// like the double default parameters.
    public func padding(_ amount: Int? = nil) -> some View {
        return padding(.all, amount)
    }

    /// Adds padding to a view. If `amount` is `nil`, then a backend-specific default value
    /// is used.
    public func padding(_ edges: Edge.Set = .all, _ amount: Int? = nil) -> some View {
        return PaddingModifierView(body: TupleView1(self), edges: edges, padding: amount)
    }
}

/// The implementation for the ``View/padding(_:_:)`` modifier.
struct PaddingModifierView<Child: View>: TypeSafeView {
    var body: TupleView1<Child>

    /// The edges on which to apply padding.
    var edges: Edge.Set
    /// The amount of padding to apply to the child view.
    var padding: Int?

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: EnvironmentValues
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
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewSize {
        let padding = padding ?? backend.defaultPaddingAmount
        let topPadding = edges.contains(.top) ? padding : 0
        let bottomPadding = edges.contains(.bottom) ? padding : 0
        let leadingPadding = edges.contains(.leading) ? padding : 0
        let trailingPadding = edges.contains(.trailing) ? padding : 0

        let childSize = children.child0.update(
            with: body.view0,
            proposedSize: SIMD2(
                max(proposedSize.x - leadingPadding - trailingPadding, 0),
                max(proposedSize.y - topPadding - bottomPadding, 0)
            ),
            environment: environment,
            dryRun: dryRun
        )

        let paddingSize = SIMD2(leadingPadding + trailingPadding, topPadding + bottomPadding)
        let size =
            SIMD2(
                childSize.size.x,
                childSize.size.y
            ) &+ paddingSize
        if !dryRun {
            backend.setSize(of: container, to: size)
            backend.setPosition(ofChildAt: 0, in: container, to: SIMD2(leadingPadding, topPadding))
        }

        return ViewSize(
            size: size,
            idealSize: childSize.idealSize &+ paddingSize,
            idealWidthForProposedHeight: childSize.idealWidthForProposedHeight + paddingSize.x,
            idealHeightForProposedWidth: childSize.idealHeightForProposedWidth + paddingSize.y,
            minimumWidth: childSize.minimumWidth + paddingSize.x,
            minimumHeight: childSize.minimumHeight + paddingSize.y,
            maximumWidth: childSize.maximumWidth + Double(paddingSize.x),
            maximumHeight: childSize.maximumHeight + Double(paddingSize.y)
        )
    }
}
