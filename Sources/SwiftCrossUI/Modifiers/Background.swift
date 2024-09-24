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

    func children<Backend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: Environment
    ) -> TupleView2<Background, Foreground>.Children where Backend: AppBackend {
        body.children(backend: backend, snapshots: snapshots, environment: environment)
    }

    func layoutableChildren<Backend>(
        backend: Backend,
        children: TupleView2<Background, Foreground>.Children
    ) -> [LayoutSystem.LayoutableChild] where Backend: AppBackend {
        []
    }

    func asWidget<Backend>(
        _ children: TupleView2<Background, Foreground>.Children, backend: Backend
    ) -> Backend.Widget where Backend: AppBackend {
        body.asWidget(children, backend: backend)
    }

    func update<Backend>(
        _ widget: Backend.Widget,
        children: TupleView2<Background, Foreground>.Children,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend,
        dryRun: Bool
    ) -> ViewSize where Backend: AppBackend {
        let foregroundSize = children.child1.update(
            with: body.view1,
            proposedSize: proposedSize,
            environment: environment,
            dryRun: dryRun
        )
        let backgroundSize = children.child0.update(
            with: body.view0,
            proposedSize: foregroundSize.size,
            environment: environment,
            dryRun: dryRun
        )

        let frameSize = SIMD2(
            max(backgroundSize.size.x, foregroundSize.size.x),
            max(backgroundSize.size.y, foregroundSize.size.y)
        )

        if !dryRun {
            let backgroundPosition = (frameSize &- backgroundSize.size) / 2
            let foregroundPosition = (frameSize &- foregroundSize.size) / 2

            backend.setPosition(ofChildAt: 0, in: widget, to: backgroundPosition)
            backend.setPosition(ofChildAt: 1, in: widget, to: foregroundPosition)

            backend.setSize(of: widget, to: frameSize)
        }

        return ViewSize(
            size: frameSize,
            idealSize: foregroundSize.idealSize,
            minimumWidth: max(backgroundSize.minimumWidth, foregroundSize.minimumWidth),
            minimumHeight: max(backgroundSize.minimumHeight, foregroundSize.minimumHeight),
            maximumWidth: max(backgroundSize.maximumWidth, foregroundSize.maximumWidth),
            maximumHeight: max(backgroundSize.maximumHeight, foregroundSize.maximumHeight)
        )
    }
}
