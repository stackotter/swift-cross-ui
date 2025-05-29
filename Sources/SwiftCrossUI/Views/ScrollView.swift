import Foundation

/// A view that is scrollable when it would otherwise overflow available space. Use the
/// ``View/frame`` modifier to constrain height if necessary.
public struct ScrollView<Content: View>: TypeSafeView, View {
    public var body: VStack<Content>
    public var axes: Axis.Set

    /// Wraps a view in a scrollable container.
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

    func computeLayout<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: ScrollViewChildren<Content>,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        // Probe how big the child would like to be
        let childResult = children.child.computeLayout(
            with: body,
            proposedSize: proposedSize,
            environment: environment
        )
        let contentSize = childResult.size

        let scrollBarWidth = backend.scrollBarWidth

        let hasHorizontalScrollBar =
            axes.contains(.horizontal) && contentSize.idealWidthForProposedHeight > proposedSize.x
        let hasVerticalScrollBar =
            axes.contains(.vertical) && contentSize.idealHeightForProposedWidth > proposedSize.y
        children.hasHorizontalScrollBar = hasHorizontalScrollBar
        children.hasVerticalScrollBar = hasVerticalScrollBar

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
            scrollViewWidth = min(
                contentSize.size.x + verticalScrollBarWidth,
                max(proposedSize.x, contentSize.minimumWidth + verticalScrollBarWidth)
            )
            minimumWidth = contentSize.minimumWidth + verticalScrollBarWidth
        }
        if axes.contains(.vertical) {
            scrollViewHeight = max(proposedSize.y, horizontalScrollBarHeight)
            minimumHeight = horizontalScrollBarHeight
        } else {
            scrollViewHeight = min(
                contentSize.size.y + horizontalScrollBarHeight,
                max(proposedSize.y, contentSize.minimumHeight + horizontalScrollBarHeight)
            )
            minimumHeight = contentSize.minimumHeight + horizontalScrollBarHeight
        }

        let scrollViewSize = SIMD2(
            scrollViewWidth,
            scrollViewHeight
        )

        // TODO: scroll bar presence shouldn't affect whether we use current
        //   or ideal size. Only the presence of the given axis in the user's
        //   list of scroll axes should affect that.
        let proposedContentSize = SIMD2(
            hasHorizontalScrollBar
                ? (hasVerticalScrollBar
                    ? contentSize.idealSize.x : contentSize.idealWidthForProposedHeight)
                : min(contentSize.size.x, proposedSize.x - verticalScrollBarWidth),
            hasVerticalScrollBar
                ? (hasHorizontalScrollBar
                    ? contentSize.idealSize.y : contentSize.idealHeightForProposedWidth)
                : min(contentSize.size.y, proposedSize.y - horizontalScrollBarHeight)
        )

        let finalChildResult = children.child.computeLayout(
            with: body,
            proposedSize: proposedContentSize,
            environment: environment
        )

        return ViewLayoutResult(
            size: ViewSize(
                size: scrollViewSize,
                idealSize: contentSize.idealSize,
                minimumWidth: minimumWidth,
                minimumHeight: minimumHeight,
                maximumWidth: nil,
                maximumHeight: nil
            ),
            childResults: [finalChildResult]
        )
    }

    func commit<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: ScrollViewChildren<Content>,
        layout: ViewLayoutResult,
        environment: EnvironmentValues,
        backend: Backend
    ) {
        let scrollViewSize = layout.size.size
        let finalContentSize = children.child.commit().size

        let verticalScrollBarWidth =
            children.hasVerticalScrollBar
            ? backend.scrollBarWidth : 0
        let horizontalScrollBarHeight =
            children.hasHorizontalScrollBar
            ? backend.scrollBarWidth : 0
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
            hasVerticalScrollBar: children.hasVerticalScrollBar,
            hasHorizontalScrollBar: children.hasHorizontalScrollBar
        )
        backend.updateScrollContainer(widget, environment: environment)
    }
}

class ScrollViewChildren<Content: View>: ViewGraphNodeChildren {
    var children: TupleView1<VStack<Content>>.Children
    var innerContainer: AnyWidget

    var hasVerticalScrollBar = false
    var hasHorizontalScrollBar = false

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
