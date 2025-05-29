import Foundation

struct SplitView<Sidebar: View, Detail: View>: TypeSafeView, View {
    typealias Children = SplitViewChildren<EnvironmentModifier<Sidebar>, Detail>

    var body: TupleView2<EnvironmentModifier<Sidebar>, Detail>

    /// Creates a two column split view.
    init(@ViewBuilder sidebar: () -> Sidebar, @ViewBuilder detail: () -> Detail) {
        body = TupleView2(
            EnvironmentModifier(sidebar()) { $0.with(\.listStyle, .sidebar) },
            detail()
        )
    }

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: EnvironmentValues
    ) -> Children {
        SplitViewChildren(
            wrapping: body.children(
                backend: backend,
                snapshots: snapshots,
                environment: environment
            ),
            backend: backend
        )
    }

    func asWidget<Backend: AppBackend>(
        _ children: Children,
        backend: Backend
    ) -> Backend.Widget {
        return backend.createSplitView(
            leadingChild: children.leadingPaneContainer.into(),
            trailingChild: children.trailingPaneContainer.into()
        )
    }

    func computeLayout<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: Children,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        let leadingWidth = backend.sidebarWidth(ofSplitView: widget)

        // Update pane children
        let leadingResult = children.leadingChild.computeLayout(
            with: body.view0,
            proposedSize: SIMD2(
                leadingWidth,
                proposedSize.y
            ),
            environment: environment
        )
        let trailingResult = children.trailingChild.computeLayout(
            with: body.view1,
            proposedSize: SIMD2(
                proposedSize.x - max(leadingWidth, leadingResult.size.minimumWidth),
                proposedSize.y
            ),
            environment: environment
        )

        // Update split view size and sidebar width bounds
        let leadingContentSize = leadingResult.size
        let trailingContentSize = trailingResult.size
        let size = SIMD2(
            max(proposedSize.x, leadingContentSize.size.x + trailingContentSize.size.x),
            max(proposedSize.y, max(leadingContentSize.size.y, trailingContentSize.size.y))
        )

        return ViewLayoutResult(
            size: ViewSize(
                size: size,
                idealSize: leadingContentSize.idealSize &+ trailingContentSize.idealSize,
                minimumWidth: leadingContentSize.minimumWidth + trailingContentSize.minimumWidth,
                minimumHeight: max(
                    leadingContentSize.minimumHeight, trailingContentSize.minimumHeight),
                maximumWidth: nil,
                maximumHeight: nil
            ),
            childResults: [leadingResult, trailingResult]
        )
    }

    func commit<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: Children,
        layout: ViewLayoutResult,
        environment: EnvironmentValues,
        backend: Backend
    ) {
        backend.setResizeHandler(ofSplitView: widget) {
            environment.onResize(.empty)
        }

        let leadingWidth = backend.sidebarWidth(ofSplitView: widget)
        let leadingResult = children.leadingChild.commit()
        let trailingResult = children.trailingChild.commit()

        backend.setSize(of: widget, to: layout.size.size)
        backend.setSidebarWidthBounds(
            ofSplitView: widget,
            minimum: leadingResult.size.minimumWidth,
            maximum: max(
                leadingResult.size.minimumWidth,
                layout.size.size.x - trailingResult.size.minimumWidth
            )
        )

        // Center pane children
        backend.setPosition(
            ofChildAt: 0,
            in: children.leadingPaneContainer.into(),
            to: SIMD2(
                leadingWidth - leadingResult.size.size.x,
                layout.size.size.y - leadingResult.size.size.y
            ) / 2
        )
        backend.setPosition(
            ofChildAt: 0,
            in: children.trailingPaneContainer.into(),
            to: SIMD2(
                layout.size.size.x - leadingWidth - trailingResult.size.size.x,
                layout.size.size.y - trailingResult.size.size.y
            ) / 2
        )
    }
}

class SplitViewChildren<Sidebar: View, Detail: View>: ViewGraphNodeChildren {
    var paneChildren: TupleView2<Sidebar, Detail>.Children
    var leadingPaneContainer: AnyWidget
    var trailingPaneContainer: AnyWidget

    init<Backend: AppBackend>(
        wrapping children: TupleView2<Sidebar, Detail>.Children,
        backend: Backend
    ) {
        self.paneChildren = children

        let leadingPaneContainer = backend.createContainer()
        backend.addChild(paneChildren.child0.widget.into(), to: leadingPaneContainer)
        let trailingPaneContainer = backend.createContainer()
        backend.addChild(paneChildren.child1.widget.into(), to: trailingPaneContainer)

        self.leadingPaneContainer = AnyWidget(leadingPaneContainer)
        self.trailingPaneContainer = AnyWidget(trailingPaneContainer)
    }

    var erasedNodes: [ErasedViewGraphNode] {
        paneChildren.erasedNodes
    }

    var widgets: [AnyWidget] {
        [
            leadingPaneContainer,
            trailingPaneContainer,
        ]
    }

    var leadingChild: AnyViewGraphNode<Sidebar> {
        paneChildren.child0
    }

    var trailingChild: AnyViewGraphNode<Detail> {
        paneChildren.child1
    }
}
