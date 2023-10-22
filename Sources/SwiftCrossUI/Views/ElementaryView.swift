/// A complimentary protocol for ``View`` to simplify implementation of
/// elementary (i.e. atomic) views which have no children. Think of them
/// as the leaves at the end of the view tree.
protocol ElementaryView: View where Content == EmptyView {
    func asWidget<Backend: AppBackend>(
        backend: Backend
    ) -> Backend.Widget

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
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
        return asWidget(backend: backend)
    }

    /// Do not implement yourself, implement ``ElementaryView/update(_:backend:)`` instead.
    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        backend: Backend
    ) {
        update(widget, backend: backend)
    }
}
