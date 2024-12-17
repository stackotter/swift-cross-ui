/// A view that is scrollable when it would otherwise overflow available space. Use the
/// ``View/frame`` moVStack to constrain height if necessary.
public struct ScrollView<Content: View>: TypeSafeView, View {
    public var body: VStack<Content>
    public var axes: Axis.Set

    /// Wraps a view in a VStackrcontent: ollable container.
    public init(_ axes: Axis.Set = .vertical, @ViewBuilder _ content: () -> Content) {
        self.axes = axes
        body = VStack(content: content())
    }

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: EnvironmentValues
    ) -> ScrollViewChildren<Content> {
        // TODO: Verify that snapshotting works correctly with this
        return ScrollViewChildren(
            wrapping: TupleViewChildren1(
                body,
                backend: backend,
                snapshots: snapshots,
                environment: environment
            ),
            backend: backend
        )
    }

    func layoutableChildren<Backend: AppBackend>(
        backend: Backend,
        children: TupleViewChildren1<VStack<Content>>
    ) -> [LayoutSystem.LayoutableChild] {
        []
    }

    func asWidget<Backend: AppBackend>(
        _ children: ScrollViewChildren<Content>,
        backend: Backend
    ) -> Backend.Widget {
        return backend.createScrollContainer(for: children.innerContainer.into())
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: ScrollViewChildren<Content>,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        // Probe how big the child would like to be
        let childResult = children.child.update(
            with: body,
            proposedSize: proposedSize,
            environment: environment,
            dryRun: true
        )
        let contentSize = childResult.size

        let scrollBarWidth = backend.scrollBarWidth

        let hasHorizontalScrollBar =
            axes.contains(.horizontal) && contentSize.idealSize.x > proposedSize.x
        let hasVerticalScrollBar =
            axes.contains(.vertical) && contentSize.idealSize.y > proposedSize.y

        let verticalScrollBarWidth = hasVerticalScrollBar ? scrollBarWidth : 0
        let horizontalScrollBarHeight = hasHorizontalScrollBar ? scrollBarWidth : 0

        let scrollViewWidth: Int
        let scrollViewHeight: Int
        let minimumWidth: Int
        let minimumHeight: Int
        if axes.contains(.horizontal) {
            scrollViewWidth = max(proposedSize.x, verticalScrollBarWidth)
            minimumWidth = verticalScrollBarWidth
        } else {
            scrollViewWidth = max(
                contentSize.size.x,
                contentSize.minimumWidth + verticalScrollBarWidth
            )
            minimumWidth = contentSize.minimumWidth + verticalScrollBarWidth
        }
        if axes.contains(.vertical) {
            scrollViewHeight = max(proposedSize.y, horizontalScrollBarHeight)
            minimumHeight = horizontalScrollBarHeight
        } else {
            scrollViewHeight = max(
                contentSize.size.y,
                contentSize.minimumHeight + horizontalScrollBarHeight
            )
            minimumHeight = contentSize.minimumHeight + horizontalScrollBarHeight
        }

        let scrollViewSize = SIMD2(
            scrollViewWidth,
            scrollViewHeight
        )

        let finalResult: ViewUpdateResult
        if !dryRun {
            let proposedContentSize = SIMD2(
                hasHorizontalScrollBar
                    ? contentSize.idealSize.x : (contentSize.size.x - verticalScrollBarWidth),
                hasVerticalScrollBar
                    ? contentSize.idealSize.y : (contentSize.size.y - horizontalScrollBarHeight)
            )

            finalResult = children.child.update(
                with: body,
                proposedSize: proposedContentSize,
                environment: environment,
                dryRun: false
            )
            let finalContentSize = finalResult.size

            let clipViewWidth = scrollViewSize.x - verticalScrollBarWidth
            let clipViewHeight = scrollViewSize.y - horizontalScrollBarHeight
            var childPosition: SIMD2<Int> = .zero
            var innerContainerSize: SIMD2<Int> = finalContentSize.size
            if axes.contains(.vertical) && finalContentSize.size.x < clipViewWidth {
                childPosition.x = (clipViewWidth - finalContentSize.size.x) / 2
                innerContainerSize.x = clipViewWidth
            }
            if axes.contains(.horizontal) && finalContentSize.size.y < clipViewHeight {
                childPosition.y = (clipViewHeight - finalContentSize.size.y) / 2
                innerContainerSize.y = clipViewHeight
            }

            backend.setSize(of: widget, to: scrollViewSize)
            backend.setSize(of: children.innerContainer.into(), to: innerContainerSize)
            backend.setPosition(ofChildAt: 0, in: children.innerContainer.into(), to: childPosition)
            backend.setScrollBarPresence(
                ofScrollContainer: widget,
                hasVerticalScrollBar: hasVerticalScrollBar,
                hasHorizontalScrollBar: hasHorizontalScrollBar
            )
        } else {
            finalResult = childResult
        }

        return ViewUpdateResult(
            size: ViewSize(
                size: scrollViewSize,
                idealSize: contentSize.idealSize,
                minimumWidth: minimumWidth,
                minimumHeight: minimumHeight,
                maximumWidth: nil,
                maximumHeight: nil
            ),
            childResults: [finalResult]
        )
    }
}

class ScrollViewChildren<Content: View>: ViewGraphNodeChildren {
    var children: TupleView1<VStack<Content>>.Children
    var innerContainer: AnyWidget

    var child: AnyViewGraphNode<VStack<Content>> {
        children.child0
    }

    var widgets: [AnyWidget] {
        // The implementation of this property doesn't really matter. It doesn't
        // really have a reason to get used anywhere.
        children.widgets
    }

    var erasedNodes: [ErasedViewGraphNode] {
        children.erasedNodes
    }

    init<Backend: AppBackend>(
        wrapping children: TupleView1<VStack<Content>>.Children,
        backend: Backend
    ) {
        self.children = children
        let innerContainer = backend.createContainer()
        backend.addChild(children.child0.widget.into(), to: innerContainer)
        self.innerContainer = AnyWidget(innerContainer)
    }
}
