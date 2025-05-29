/// A complimentary protocol for ``View`` to simplify implementation of
/// elementary (i.e. atomic) views which have no children. Think of them
/// as the leaves at the end of the view tree.
@MainActor
protocol ElementaryView: View where Content == EmptyView {
    func asWidget<Backend: AppBackend>(
        backend: Backend
    ) -> Backend.Widget

    func computeLayout<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult

    func commit<Backend: AppBackend>(
        _ widget: Backend.Widget,
        layout: ViewLayoutResult,
        environment: EnvironmentValues,
        backend: Backend
    )
}

extension ElementaryView {
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
    public func computeLayout<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        computeLayout(
            widget,
            proposedSize: proposedSize,
            environment: environment,
            backend: backend
        )
    }

    public func commit<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        layout: ViewLayoutResult,
        environment: EnvironmentValues,
        backend: Backend
    ) {
        commit(
            widget,
            layout: layout,
            environment: environment,
            backend: backend
        )
    }
}
