import Foundation

public protocol ContainerView: View {
    associatedtype NodeChildren: ViewGraphNodeChildren

    func asChildren<Backend: AppBackend>(backend: Backend) -> NodeChildren

    func updateChildren<Backend: AppBackend>(_ children: NodeChildren, backend: Backend)
}

extension ContainerView {
    public func asContainerView<Backend: AppBackend>(backend: Backend) -> AnyContainerView? {
        return AnyContainerView(self, backend: backend)
    }
}

/// A view that can be displayed by SwiftCrossUI.
public protocol View {
    associatedtype Content: View
    associatedtype State: Observable

    var state: State { get set }

    /// The view's contents.
    @ViewBuilder var body: Content { get }

    func asContainerView<Backend: AppBackend>(backend: Backend) -> AnyContainerView?

    func asWidget<Backend: AppBackend>(
        _ children: [Backend.Widget],
        backend: Backend
    ) -> Backend.Widget

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: [Backend.Widget],
        backend: Backend
    )
}

extension View {
    public func asContainerView<Backend: AppBackend>(backend: Backend) -> AnyContainerView? {
        nil
    }
}

extension View {
    public func asWidget<Backend: AppBackend>(
        _ children: [Backend.Widget],
        backend: Backend
    ) -> Backend.Widget {
        let vStack = backend.createVStack(spacing: 8)
        backend.addChildren(children, toVStack: vStack)
        return vStack
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget, children: [Backend.Widget], backend: Backend
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
