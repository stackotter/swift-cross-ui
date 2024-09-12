import Foundation

struct SplitView<Sidebar: View, Detail: View>: TypeSafeView, View {
    typealias Children = Content.Children

    var body: TupleView2<Sidebar, Detail>

    var flexibility: Int {
        body.view1.flexibility
    }

    /// Creates a two column split view.
    init(@ViewBuilder sidebar: () -> Sidebar, @ViewBuilder detail: () -> Detail) {
        body = TupleView2(sidebar(), detail())
    }

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: Environment
    ) -> TupleView2<Sidebar, Detail>.Children {
        body.children(backend: backend, snapshots: snapshots, environment: environment)
    }

    func asWidget<Backend: AppBackend>(
        _ children: TupleViewChildren2<Sidebar, Detail>,
        backend: Backend
    ) -> Backend.Widget {
        return backend.createSplitView(
            leadingChild: children.child0.widget.into(),
            trailingChild: children.child1.widget.into()
        )
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: TupleViewChildren2<Sidebar, Detail>,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend
    ) -> ViewUpdateResult {
        let leadingWidth = backend.sidebarWidth(ofSplitView: widget)
        backend.setResizeHandler(ofSplitView: widget) { _, _ in
            environment.onResize(.empty)
        }
        let leadingContentSize = children.child0.update(
            with: body.view0,
            proposedSize: SIMD2(
                leadingWidth,
                proposedSize.y
            ),
            environment: environment
        )
        let trailingContentSize = children.child1.update(
            with: body.view1,
            proposedSize: SIMD2(
                proposedSize.x - leadingWidth,
                proposedSize.y
            ),
            environment: environment
        )
        let size = SIMD2(
            max(proposedSize.x, leadingContentSize.size.x + trailingContentSize.size.x),
            max(proposedSize.y, max(leadingContentSize.size.y, trailingContentSize.size.y))
        )
        backend.setSize(of: widget, to: size)
        backend.setSidebarWidthBounds(
            ofSplitView: widget,
            minimum: leadingContentSize.minimumWidth,
            maximum: max(
                leadingContentSize.minimumWidth,
                proposedSize.x - trailingContentSize.minimumWidth
            )
        )
        backend.updateSplitViewChildPositions(
            of: widget,
            splitViewSize: size,
            leadingChildSize: leadingContentSize.size,
            trailingChildSize: trailingContentSize.size
        )
        return ViewUpdateResult(
            size: size,
            minimumWidth: leadingContentSize.minimumWidth + trailingContentSize.minimumWidth,
            minimumHeight: max(leadingContentSize.minimumHeight, trailingContentSize.minimumHeight)
        )
    }
}
