extension View {
    /// Overlays another view on top of this view.
    ///
    /// - Parameter content: The view to overlay this view with.
    public func overlay(@ViewBuilder content: () -> some View) -> some View {
        OverlayModifier(content: self, overlay: content())
    }
}

struct OverlayModifier<Content: View, Overlay: View>: TypeSafeView {
    typealias Children = TupleView2<Content, Overlay>.Children

    var body: TupleView2<Content, Overlay>

    init(content: Content, overlay: Overlay) {
        body = TupleView2(content, overlay)
    }

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: EnvironmentValues
    ) -> TupleView2<Content, Overlay>.Children {
        body.children(
            backend: backend,
            snapshots: snapshots,
            environment: environment
        )
    }

    func layoutableChildren<Backend: AppBackend>(
        backend: Backend,
        children: TupleView2<Content, Overlay>.Children
    ) -> [LayoutSystem.LayoutableChild] {
        []
    }

    func asWidget<Backend: AppBackend>(
        _ children: TupleView2<Content, Overlay>.Children, backend: Backend
    ) -> Backend.Widget {
        body.asWidget(children, backend: backend)
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: TupleView2<Content, Overlay>.Children,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        let contentResult = children.child0.update(
            with: body.view0,
            proposedSize: proposedSize,
            environment: environment,
            dryRun: dryRun
        )
        let contentSize = contentResult.size
        let overlayResult = children.child1.update(
            with: body.view1,
            proposedSize: contentSize.size,
            environment: environment,
            dryRun: dryRun
        )
        let overlaySize = overlayResult.size

        let frameSize = SIMD2(
            max(contentSize.size.x, overlaySize.size.x),
            max(contentSize.size.y, overlaySize.size.y)
        )

        if !dryRun {
            let contentPosition = (frameSize &- contentSize.size) / 2
            let overlayPosition = (frameSize &- overlaySize.size) / 2

            backend.setPosition(ofChildAt: 0, in: widget, to: contentPosition)
            backend.setPosition(ofChildAt: 1, in: widget, to: overlayPosition)

            backend.setSize(of: widget, to: frameSize)
        }

        return ViewUpdateResult(
            size: ViewSize(
                size: frameSize,
                idealSize: contentSize.idealSize,
                minimumWidth: max(contentSize.minimumWidth, overlaySize.minimumWidth),
                minimumHeight: max(contentSize.minimumHeight, overlaySize.minimumHeight),
                maximumWidth: min(contentSize.maximumWidth, overlaySize.maximumWidth),
                maximumHeight: min(contentSize.maximumHeight, overlaySize.maximumHeight)
            ),
            childResults: [contentResult, overlayResult]
        )
    }
}
