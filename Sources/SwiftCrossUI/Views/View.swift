/// A view that can be rendered by any backend.
@MainActor
public protocol View {
    /// The view's content (composed of other views).
    associatedtype Content: View

    /// The view's contents.
    @ViewBuilder var body: Content { get }

    /// Gets the view's children as a type-erased collection of view graph nodes. Type-erased
    /// to avoid leaking complex requirements to users implementing their own regular views.
    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: EnvironmentValues
    ) -> any ViewGraphNodeChildren

    // TODO: Perhaps this can be split off into a separate protocol for the `TupleViewN`s
    //   if we can set up the generics right for VStack.
    /// Gets the view's children in a format that can be consumed by the ``LayoutSystem``.
    /// This really only needs to be its own method for views such as VStack which treat
    /// their child's children as their own and skip over their direct child. Only needs to
    /// be implemented by the `TupleViewN`s.
    func layoutableChildren<Backend: AppBackend>(
        backend: Backend,
        children: any ViewGraphNodeChildren
    ) -> [LayoutSystem.LayoutableChild]

    /// Creates the view's widget using the supplied backend.
    ///
    /// A view is represented by the same widget instance for the whole time
    /// that it's visible even if its content is changing; keep that in mind
    /// while deciding the structure of the widget. For example, a view
    /// displaying one of two children should use ``AppBackend/createContainer()``
    /// to create a container for the displayed child instead of just directly
    /// returning the widget of the currently displayed child (which would result
    /// in you not being able to ever switch to displaying the other child). This
    /// constraint significantly simplifies view implementations without
    /// requiring widgets to be re-created after every single update.
    func asWidget<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren,
        backend: Backend
    ) -> Backend.Widget

    /// Computes this view's layout after a state change or a change in
    /// available space. `proposedSize` is the size suggested by the parent
    /// container, but child views always get the final call on their own size.
    /// - Returns: The view's layout size.
    func computeLayout<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        proposedSize: ProposedViewSize,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult

    /// Commits the last computed layout to the underlying widget hierarchy.
    /// `layout` is guaranteed to be the last value returned by ``computeLayout``.
    func commit<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        layout: ViewLayoutResult,
        environment: EnvironmentValues,
        backend: Backend
    )
}

extension View {
    public func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: EnvironmentValues
    ) -> any ViewGraphNodeChildren {
        defaultChildren(
            backend: backend,
            snapshots: snapshots,
            environment: environment
        )
    }

    /// The default `View.children` implementation. Haters may see this as a
    /// composition lover re-implementing inheritance; I see it as innovation.
    public func defaultChildren<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: EnvironmentValues
    ) -> any ViewGraphNodeChildren {
        body.children(backend: backend, snapshots: snapshots, environment: environment)
    }

    public func layoutableChildren<Backend: AppBackend>(
        backend: Backend,
        children: any ViewGraphNodeChildren
    ) -> [LayoutSystem.LayoutableChild] {
        defaultLayoutableChildren(backend: backend, children: children)
    }

    /// The default `View.layoutableChildren` implementation. Haters may see
    /// this as a composition lover re-implementing inheritance; I see it as
    /// innovation.
    public func defaultLayoutableChildren<Backend: AppBackend>(
        backend: Backend,
        children: any ViewGraphNodeChildren
    ) -> [LayoutSystem.LayoutableChild] {
        body.layoutableChildren(backend: backend, children: children)
    }

    public func asWidget<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren,
        backend: Backend
    ) -> Backend.Widget {
        defaultAsWidget(children, backend: backend)
    }

    /// The default `View.asWidget` implementation. Haters may see this as a
    /// composition lover re-implementing inheritance; I see it as innovation.
    public func defaultAsWidget<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren,
        backend: Backend
    ) -> Backend.Widget {
        let vStack = VStack(content: body)
        return vStack.asWidget(children, backend: backend)
    }

    public func computeLayout<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        proposedSize: ProposedViewSize,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        defaultComputeLayout(
            widget,
            children: children,
            proposedSize: proposedSize,
            environment: environment,
            backend: backend
        )
    }

    /// The default `View.computeLayout` implementation. Haters may see this as a
    /// composition lover re-implementing inheritance; I see it as innovation.
    public func defaultComputeLayout<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        proposedSize: ProposedViewSize,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        let vStack = VStack(content: body)
        return vStack.computeLayout(
            widget,
            children: children,
            proposedSize: proposedSize,
            environment: environment,
            backend: backend
        )
    }

    public func commit<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        layout: ViewLayoutResult,
        environment: EnvironmentValues,
        backend: Backend
    ) {
        defaultCommit(
            widget,
            children: children,
            layout: layout,
            environment: environment,
            backend: backend
        )
    }

    public func defaultCommit<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        layout: ViewLayoutResult,
        environment: EnvironmentValues,
        backend: Backend
    ) {
        let vStack = VStack(content: body)
        return vStack.commit(
            widget,
            children: children,
            layout: layout,
            environment: environment,
            backend: backend
        )
    }
}
