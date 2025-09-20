extension View {
    /// Adds an action to perform when the user's pointer enters/leaves this view.
    public func onHover(perform action: @escaping (_ hovering: Bool) -> Void)
        -> some View
    {
        OnHoverModifier(body: TupleView1(self), action: action)
    }
}

struct OnHoverModifier<Content: View>: TypeSafeView {
    typealias Children = TupleView1<Content>.Children

    var body: TupleView1<Content>
    var action: (Bool) -> Void

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
        backend.createHoverTarget(wrapping: children.child0.widget.into())
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
            backend.updateHoverTarget(
                widget,
                environment: environment,
                action: action
            )
        }
        return childResult
    }
}
