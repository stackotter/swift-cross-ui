import Foundation

/// A view that can be rendered by any backend.
public protocol View {
    /// The view's content (composed of other views).
    associatedtype Content: View
    /// The view's observed state.
    associatedtype State: Observable

    /// The views observed state. Any observed changes cause ``View/body`` to be recomputed,
    /// and the view itself to be updated.
    var state: State { get set }

    /// The view's contents.
    @ViewBuilder var body: Content { get }

    /// Gets the view's children as a type-erased collection of view graph nodes. Type-erased
    /// to avoid leaking complex requirements to users implementing their own regular views.
    func children<Backend: AppBackend>(backend: Backend) -> any ViewGraphNodeChildren

    /// Updates all of the view's children after an update-causing change has occured.
    /// `children` is type-erased to avoid leaking complex requirements to users
    /// creating regular ``View``s.
    func updateChildren<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren, backend: Backend
    )

    /// Creates the view's widget using the supplied backend.
    ///
    /// A view is represented by the same widget instance for the whole time that it's visible even
    /// if its content is changing; keep that in mind while deciding the structure of the widget.
    /// For example, a view displaying one of two children should use
    /// ``AppBackend/createEitherContainer(initiallyContaining:)`` as a container for the currently
    /// displayed child instead of just returning the widget of the currently displayed child,
    /// which would result in you not being able to ever switch to displaying the other child.
    func asWidget<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren,
        backend: Backend
    ) -> Backend.Widget

    /// Updates the view's widget after a state change occurs (although the change isn't guaranteed
    /// to have affected this particular view).
    ///
    /// Always called once immediately after creating the view's widget with ``View/asWidget(_:backend:)``
    /// -- allowing for code duplication between creation and updating to be reduced.
    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        backend: Backend
    )
}

extension View {
    public func children<Backend: AppBackend>(backend: Backend) -> any ViewGraphNodeChildren {
        body.children(backend: backend)
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
