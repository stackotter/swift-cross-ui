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

    public func asWidget(
        _ children: ViewGraphNodeChildren3<SideBar, MiddleBar, Detail>
    ) -> GtkPaned {
        let widget = GtkPaned(orientation: .horizontal)
        widget.startChild = children.child0.widget

        if MiddleBar.self == EmptyViewContent.self {
            widget.endChild = children.child2.widget
        } else {
            let next = GtkPaned(orientation: .horizontal)
            next.startChild = children.child1.widget
            next.endChild = children.child2.widget
            next.shrinkStartChild = false
            next.shrinkEndChild = false
            next.position = 0
            next.expandVertically = true

            widget.endChild = next
        }

        widget.shrinkStartChild = false
        widget.shrinkEndChild = false
        // Set the position to the farthest left possible.
        // TODO: Allow setting the default offset (SwiftUI api: `navigationSplitViewColumnWidth(min:ideal:max:)`).
        //   This needs frame modifier to be fledged out first
        widget.position = 0
        widget.expandVertically = true

        return widget
    }
}
