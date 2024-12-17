extension View {
    /// Adds an action to run when this view is clicked. Any clickable elements
    /// within the view will no longer be clickable.
    public func onClick(perform action: @escaping () -> Void) -> some View {
        OnClickModifier(body: TupleView1(self), action: action)
    }
}

struct OnClickModifier<Content: View>: TypeSafeView {
    typealias Children = TupleView1<Content>.Children

    var body: TupleView1<Content>
    var action: () -> Void

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: EnvironmentValues
    ) -> Children {
        body.children(
            backend: backend,
            snapshots: snapshots,
            environment: environment
        )
    }

    func asWidget<Backend: AppBackend>(
        _ children: Children,
        backend: Backend
    ) -> Backend.Widget {
        backend.createClickTarget(wrapping: children.child0.widget.into())
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: Children,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        let childResult = children.child0.update(
            with: body.view0,
            proposedSize: proposedSize,
            environment: environment,
            dryRun: dryRun
        )
        if !dryRun {
            backend.setSize(of: widget, to: childResult.size.size)
            backend.updateClickTarget(widget, clickHandler: action)
        }
        return childResult
    }
}
