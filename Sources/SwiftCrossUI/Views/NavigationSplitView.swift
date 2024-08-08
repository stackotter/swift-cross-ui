/// A view that presents views in two or three columns.
public struct NavigationSplitView<Sidebar: View, MiddleBar: View, Detail: View>: View {
    public var body: some View {
        SplitView(
            sidebar: {
                return sidebar
            },
            detail: {
                if MiddleBar.self == EmptyView.self {
                    detail
                } else {
                    SplitView(
                        sidebar: {
                            return content
                        },
                        detail: {
                            return detail
                        }
                    )
                }
            }
        )
    }

    public var sidebar: Sidebar
    public var content: MiddleBar
    public var detail: Detail

    /// Creates a three column split view.
    public init(
        @ViewBuilder sidebar: () -> Sidebar,
        @ViewBuilder content: () -> MiddleBar,
        @ViewBuilder detail: () -> Detail
    ) {
        self.sidebar = sidebar()
        self.content = content()
        self.detail = detail()
    }
}

extension NavigationSplitView where MiddleBar == EmptyView {
    /// Creates a two column split view.
    public init(
        @ViewBuilder sidebar: () -> Sidebar,
        @ViewBuilder detail: () -> Detail
    ) {
        self.sidebar = sidebar()
        content = EmptyView()
        self.detail = detail()
    }
}
