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

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: Children,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        let leadingWidth = backend.sidebarWidth(ofSplitView: widget)
        if !dryRun {
            backend.setResizeHandler(ofSplitView: widget) {
                environment.onResize(.empty)
            }
        }

        // Update pane children
        let leadingResult = children.leadingChild.update(
            with: body.view0,
            proposedSize: SIMD2(
                leadingWidth,
                proposedSize.y
            ),
            environment: environment,
            dryRun: dryRun
        )
        let trailingResult = children.trailingChild.update(
            with: body.view1,
            proposedSize: SIMD2(
                proposedSize.x - max(leadingWidth, leadingResult.size.minimumWidth),
                proposedSize.y
            ),
            environment: environment,
            dryRun: dryRun
        )

        // Update split view size and sidebar width bounds
        let leadingContentSize = leadingResult.size
        let trailingContentSize = trailingResult.size
        let size = SIMD2(
            max(proposedSize.x, leadingContentSize.size.x + trailingContentSize.size.x),
            max(proposedSize.y, max(leadingContentSize.size.y, trailingContentSize.size.y))
        )
        if !dryRun {
            backend.setSize(of: widget, to: size)
            backend.setSidebarWidthBounds(
                ofSplitView: widget,
                minimum: leadingContentSize.minimumWidth,
                maximum: max(
                    leadingContentSize.minimumWidth,
                    proposedSize.x - trailingContentSize.minimumWidth
                )
            )

            // Center pane children
            backend.setPosition(
                ofChildAt: 0,
                in: children.leadingPaneContainer.into(),
                to: SIMD2(
                    leadingWidth - leadingContentSize.size.x,
                    proposedSize.y - leadingContentSize.size.y
                ) / 2
            )
            backend.setPosition(
                ofChildAt: 0,
                in: children.trailingPaneContainer.into(),
                to: SIMD2(
                    proposedSize.x - leadingWidth - trailingContentSize.size.x,
                    proposedSize.y - trailingContentSize.size.y
                ) / 2
            )
        }

        return ViewUpdateResult(
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
