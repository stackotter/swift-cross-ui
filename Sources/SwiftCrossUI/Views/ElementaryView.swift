/// A complimentary protocol for ``View`` to simplify implementation of
/// elementary (i.e. atomic) views which have no children. Think of them
/// as the leaves at the end of the view tree.
protocol ElementaryView: View where Content == EmptyView {
    func asWidget<Backend: AppBackend>(
        backend: Backend
    ) -> Backend.Widget

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend
    ) -> SIMD2<Int>
}

extension ElementaryView {
    /// This default prevents ``EmptyView/body`` from getting called.
    public var flexibility: Int {
        0
    }

    public var body: EmptyView {
        return EmptyView()
    }

    /// Do not implement yourself, implement ``ElementaryView/asWidget(backend:)`` instead.
    public func asWidget<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren,
        backend: Backend
    ) -> Backend.Widget {
        asWidget(backend: backend)
    }

    /// Do not implement yourself, implement ``ElementaryView/update(_:proposedSize:environment:backend:)`` instead.
    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend
    ) -> SIMD2<Int> {
        update(
            widget,
            proposedSize: proposedSize,
            environment: environment,
            backend: backend
        )
    }
}
