extension View {
    /// Adds an action to be performed after this view disappears.
    ///
    /// `onDisappear` actions on outermost views are called first and propagate
    /// down to the leaf views due to essentially relying on the `deinit` of the
    /// modifier view's ``ViewGraphNode``.
    public func onDisappear(perform action: @escaping () -> Void) -> some View {
        OnDisappearModifier(body: self, action: action)
    }
}

struct OnDisappearModifier<Content: View>: TypeSafeView {
    var body: Content
    var action: () -> Void

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: EnvironmentValues
    ) -> OnDisappearModifierChildren {
        OnDisappearModifierChildren(
            wrappedChildren: body.children(
                backend: backend,
                snapshots: snapshots,
                environment: environment
            ),
            action: action
        )
    }

    func layoutableChildren<Backend: AppBackend>(
        backend: Backend,
        children: OnDisappearModifierChildren
    ) -> [LayoutSystem.LayoutableChild] {
        body.layoutableChildren(
            backend: backend,
            children: children.wrappedChildren
        )
    }

    func asWidget<Backend: AppBackend>(
        _ children: OnDisappearModifierChildren,
        backend: Backend
    ) -> Backend.Widget {
        body.asWidget(children.wrappedChildren, backend: backend)
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: OnDisappearModifierChildren,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewSize {
        body.update(
            widget,
            children: children.wrappedChildren,
            proposedSize: proposedSize,
            environment: environment,
            backend: backend,
            dryRun: dryRun
        )
    }
}

class OnDisappearModifierChildren: ViewGraphNodeChildren {
    var wrappedChildren: any ViewGraphNodeChildren
    var action: () -> Void

    var widgets: [AnyWidget] {
        wrappedChildren.widgets
    }

    var erasedNodes: [ErasedViewGraphNode] {
        wrappedChildren.erasedNodes
    }

    init(
        wrappedChildren: any ViewGraphNodeChildren,
        action: @escaping () -> Void
    ) {
        self.wrappedChildren = wrappedChildren
        self.action = action
    }

    deinit {
        action()
    }
}
