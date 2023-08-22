import Foundation

/// A view that can be displayed by SwiftCrossUI.
public protocol View {
    associatedtype Content: ViewContent
    associatedtype State: Observable

    var state: State { get set }

    /// The view's contents.
    @ViewContentBuilder var body: Content { get }

    func asWidget<Backend: AppBackend>(
        _ children: Content.Children,
        backend: Backend
    ) -> Backend.Widget

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: Content.Children,
        backend: Backend
    )
}

extension View {
    public func asWidget<Backend: AppBackend>(
        _ children: Content.Children,
        backend: Backend
    ) -> Backend.Widget {
        let vStack = backend.createVStack(spacing: 8)
        backend.addChildren(children.widgets, toVStack: vStack)
        return vStack
    }
}

extension View {
    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget, children: Content.Children, backend: Backend
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
