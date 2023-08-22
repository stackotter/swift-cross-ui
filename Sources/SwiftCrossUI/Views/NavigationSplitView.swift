public struct NavigationSplitView<SideBar: View, MiddleBar: View, Detail: View>: View {
    public var body: ViewContent3<SideBar, MiddleBar, Detail>
}

extension NavigationSplitView where MiddleBar == EmptyViewContent {
    public init(
        @ViewContentBuilder sidebar: () -> SideBar,
        @ViewContentBuilder detail: () -> Detail
    ) {
        body = ViewContent3(sidebar(), EmptyViewContent(), detail())
    }
}

extension NavigationSplitView {
    public init(
        @ViewContentBuilder sidebar: () -> SideBar,
        @ViewContentBuilder content: () -> MiddleBar,
        @ViewContentBuilder detail: () -> Detail
    ) {
        body = ViewContent3(sidebar(), content(), detail())
    }

    public func asWidget<Backend: AppBackend>(
        _ children: ViewGraphNodeChildren3<SideBar, MiddleBar, Detail>,
        backend: Backend
    ) -> Backend.Widget {
        let trailingChild: Backend.Widget
        if MiddleBar.self == EmptyViewContent.self {
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
}
