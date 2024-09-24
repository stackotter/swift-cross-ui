struct EnvironmentModifier<Child: View>: TypeSafeView {
    typealias Children = TupleView1<Child>.Children

    var body: TupleView1<Child>
    var modification: (Environment) -> Environment

    init(_ child: Child, modification: @escaping (Environment) -> Environment) {
        self.body = TupleView1(child)
        self.modification = modification
    }

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: Environment
    ) -> Children {
        body.children(
            backend: backend,
            snapshots: snapshots,
            environment: modification(environment)
        )
    }

    func layoutableChildren<Backend: AppBackend>(
        backend: Backend,
        children: Children
    ) -> [LayoutSystem.LayoutableChild] {
        []
    }

    func asWidget<Backend: AppBackend>(
        _ children: Children,
        backend: Backend
    ) -> Backend.Widget {
        return body.asWidget(children, backend: backend)
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: Children,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend,
        dryRun: Bool
    ) -> ViewSize {
        return body.update(
            widget,
            children: children,
            proposedSize: proposedSize,
            environment: modification(environment),
            backend: backend,
            dryRun: dryRun
        )
    }
}