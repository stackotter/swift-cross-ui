extension View {
    public func background<Background: View>(_ background: Background) -> some View {
        BackgroundModifier(background: background, foreground: self)
    }
}

struct BackgroundModifier<Background: View, Foreground: View>: TypeSafeView {
    typealias Children = TupleView2<Background, Foreground>.Children

    var body: TupleView2<Background, Foreground>

    init(background: Background, foreground: Foreground) {
        body = TupleView2(background, foreground)
    }

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: EnvironmentValues
    ) -> TupleView2<Background, Foreground>.Children {
        body.children(backend: backend, snapshots: snapshots, environment: environment)
    }

    func layoutableChildren<Backend: AppBackend>(
        backend: Backend,
        children: TupleView2<Background, Foreground>.Children
    ) -> [LayoutSystem.LayoutableChild] {
        []
    }

    func asWidget<Backend: AppBackend>(
        _ children: TupleView2<Background, Foreground>.Children, backend: Backend
    ) -> Backend.Widget {
        body.asWidget(children, backend: backend)
    }

    func computeLayout<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: TupleView2<Background, Foreground>.Children,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        let foregroundResult = children.child1.computeLayout(
            with: body.view1,
            proposedSize: proposedSize,
            environment: environment
        )
        let foregroundSize = foregroundResult.size
        let backgroundResult = children.child0.computeLayout(
            with: body.view0,
            proposedSize: foregroundSize.size,
            environment: environment
        )
        let backgroundSize = backgroundResult.size

        let frameSize = SIMD2(
            max(backgroundSize.size.x, foregroundSize.size.x),
            max(backgroundSize.size.y, foregroundSize.size.y)
        )

        return ViewLayoutResult(
            size: ViewSize(
                size: frameSize,
                idealSize: SIMD2(
                    max(foregroundSize.idealSize.x, backgroundSize.minimumWidth),
                    max(foregroundSize.idealSize.y, backgroundSize.minimumHeight)
                ),
                idealWidthForProposedHeight: max(
                    foregroundSize.idealWidthForProposedHeight,
                    backgroundSize.minimumWidth
                ),
                idealHeightForProposedWidth: max(
                    foregroundSize.idealHeightForProposedWidth,
                    backgroundSize.minimumHeight
                ),
                minimumWidth: max(backgroundSize.minimumWidth, foregroundSize.minimumWidth),
                minimumHeight: max(backgroundSize.minimumHeight, foregroundSize.minimumHeight),
                maximumWidth: min(backgroundSize.maximumWidth, foregroundSize.maximumWidth),
                maximumHeight: min(backgroundSize.maximumHeight, foregroundSize.maximumHeight)
            ),
            childResults: [backgroundResult, foregroundResult]
        )
    }

    public func commit<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: TupleView2<Background, Foreground>.Children,
        layout: ViewLayoutResult,
        environment: EnvironmentValues,
        backend: Backend
    ) {
        let frameSize = layout.size.size
        let backgroundSize = children.child0.commit().size
        let foregroundSize = children.child1.commit().size

        let backgroundPosition = (frameSize &- backgroundSize.size) / 2
        let foregroundPosition = (frameSize &- foregroundSize.size) / 2

        backend.setPosition(ofChildAt: 0, in: widget, to: backgroundPosition)
        backend.setPosition(ofChildAt: 1, in: widget, to: foregroundPosition)

        backend.setSize(of: widget, to: frameSize)
    }
}
