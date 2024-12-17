struct EnvironmentModifier<Child: View>: View {
    var body: TupleView1<Child>
    var modification: (EnvironmentValues) -> EnvironmentValues

    init(_ child: Child, modification: @escaping (EnvironmentValues) -> EnvironmentValues) {
        self.body = TupleView1(child)
        self.modification = modification
    }

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: EnvironmentValues
    ) -> any ViewGraphNodeChildren {
        body.children(
            backend: backend,
            snapshots: snapshots,
            environment: modification(environment)
        )
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        body.update(
            widget,
            children: children,
            proposedSize: proposedSize,
            environment: modification(environment),
            backend: backend,
            dryRun: dryRun
        )
    }
}
