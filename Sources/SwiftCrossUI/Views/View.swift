import Foundation

/// A view that can be displayed by SwiftCrossUI.
public protocol View {
    associatedtype Content: View
    associatedtype State: Observable

    var state: State { get set }

    /// The view's contents.
    @ViewBuilder var body: Content { get }

    func asChildren<Backend: AppBackend>(backend: Backend) -> any ViewGraphNodeChildren

    func updateChildren<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren, backend: Backend
    )

    func asWidget<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren,
        backend: Backend
    ) -> Backend.Widget

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        backend: Backend
    )
}

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

    public func asWidget<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren,
        backend: Backend
    ) -> Backend.Widget {
        return asWidget(backend: backend)
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        backend: Backend
    ) {
        update(widget, backend: backend)
    }
}

/// A complimentary protocol for ``View`` to make implementing views more
/// type-safe without leaking the `Children` associated type to users
/// (otherwise they would need to provide a `Children` associated type for
/// every view they made).
protocol TypeSafeView: View {
    associatedtype Children: ViewGraphNodeChildren

    func asChildren<Backend: AppBackend>(backend: Backend) -> Children

    func updateChildren<Backend: AppBackend>(
        _ children: Children, backend: Backend
    )

    func asWidget<Backend: AppBackend>(
        _ children: Children,
        backend: Backend
    ) -> Backend.Widget

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: Children,
        backend: Backend
    )
}

extension TypeSafeView {
    public func asChildren<Backend: AppBackend>(backend: Backend) -> any ViewGraphNodeChildren {
        let children: Children = asChildren(backend: backend)
        return children
    }

    public func updateChildren<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren, backend: Backend
    ) {
        updateChildren(children as! Children, backend: backend)
    }

    public func asWidget<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren,
        backend: Backend
    ) -> Backend.Widget {
        return asWidget(children as! Children, backend: backend)
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        backend: Backend
    ) {
        update(widget, children: children as! Children, backend: backend)
    }
}

extension TypeSafeView where Content: TypeSafeView, Children == Content.Children {
    func asChildren<Backend: AppBackend>(backend: Backend) -> Children {
        return body.asChildren(backend: backend)
    }

    func updateChildren<Backend: AppBackend>(_ children: Children, backend: Backend) {
        body.updateChildren(children, backend: backend)
    }
}

extension View {
    public func asChildren<Backend: AppBackend>(backend: Backend) -> any ViewGraphNodeChildren {
        body.asChildren(backend: backend)
    }

    public func updateChildren<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren, backend: Backend
    ) {
        body.updateChildren(children, backend: backend)
    }

    public func asWidget<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren,
        backend: Backend
    ) -> Backend.Widget {
        let vStack = backend.createVStack(spacing: 8)
        backend.addChildren(children.widgets(for: backend), toVStack: vStack)
        return vStack
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget, children: any ViewGraphNodeChildren, backend: Backend
    ) {}
}

extension View where State == EmptyState {
    // swiftlint:disable unused_setter_value
    public var state: State {
        get {
            EmptyState()
        }
        set {
            return
        }
    }
    // swiftlint:enable unused_setter_value
}
