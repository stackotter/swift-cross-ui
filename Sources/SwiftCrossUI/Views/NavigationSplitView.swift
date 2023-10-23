/// A view that presents views in two or three columns.
public struct NavigationSplitView<
    SideBar: View, MiddleBar: View, Detail: View
>: TypeSafeView, View {
    typealias Children = Content.Children

    public var body: VariadicView3<SideBar, MiddleBar, Detail>

    /// Creates a three column split view.
    public init(
        @ViewBuilder sidebar: () -> SideBar,
        @ViewBuilder content: () -> MiddleBar,
        @ViewBuilder detail: () -> Detail
    ) {
        body = VariadicView3(sidebar(), content(), detail())
    }

    public func asWidget<Backend: AppBackend>(
        _ children: ViewGraphNodeChildren3<SideBar, MiddleBar, Detail>,
        backend: Backend
    ) -> Backend.Widget {
        let trailingChild: Backend.Widget
        if MiddleBar.self == EmptyView.self {
            trailingChild = children.child2.widget.into()
        } else {
            trailingChild = backend.createSplitView(
                leadingChild: children.child1.widget.into(),
                trailingChild: children.child2.widget.into()
            )
        }

        return backend.createSplitView(
            leadingChild: children.child0.widget.into(), trailingChild: trailingChild
        )
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: ViewGraphNodeChildren3<SideBar, MiddleBar, Detail>,
        backend: Backend
    ) {}
}

extension NavigationSplitView where MiddleBar == EmptyView {
    /// Creates a two column split view.
    public init(
        @ViewBuilder sidebar: () -> SideBar,
        @ViewBuilder detail: () -> Detail
    ) {
        body = VariadicView3(sidebar(), EmptyView(), detail())
    }
}
