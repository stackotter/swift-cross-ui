/// A view that wraps its content without introducing any extra layers of
/// widgets. Defer's to the body's `View` implementation directly by default,
/// allowing `LightweightView`s to just tweak/wrap a few of the view without
/// introducing extra layout system overhead or view graph nodes etc.
protocol LightweightView: View {}

extension LightweightView {
    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: EnvironmentValues
    ) -> any ViewGraphNodeChildren {
        body.children(backend: backend, snapshots: snapshots, environment: environment)
    }

    func layoutableChildren<Backend: AppBackend>(
        backend: Backend,
        children: any ViewGraphNodeChildren
    ) -> [LayoutSystem.LayoutableChild] {
        body.layoutableChildren(backend: backend, children: children)
    }

    func asWidget<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren,
        backend: Backend
    ) -> Backend.Widget {
        body.asWidget(children, backend: backend)
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewSize {
        body.update(
            widget,
            children: children,
            proposedSize: proposedSize,
            environment: environment,
            backend: backend,
            dryRun: dryRun
        )
    }
}
