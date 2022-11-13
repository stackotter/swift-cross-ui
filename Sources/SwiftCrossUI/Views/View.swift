import Foundation

/// A view that can be displayed by SwiftCrossUI.
public protocol View {
    associatedtype Content: ViewContent
    associatedtype State: ViewState
    associatedtype Widget: GtkWidget

    var state: State { get set }

    /// The view's contents.
    @ViewContentBuilder var body: Content { get }

    func asWidget(_ children: Content.Children) -> Widget

    func update(_ widget: Widget, children: Content.Children)
}

public extension View where Widget == GtkBox {
    func asWidget(_ children: Content.Children) -> GtkBox {
        let vStack = GtkBox(orientation: .vertical, spacing: 8)
        for widget in children.widgets {
            vStack.add(widget)
        }
        return vStack
    }
}

public extension View {
    func update(_ widget: Widget, children: Content.Children) {}
}

public extension View where State == EmptyViewState {
    // swiftlint:disable unused_setter_value
    var state: State {
        get {
            EmptyViewState()
        } set {
            return
        }
    }
    // swiftlint:enable unused_setter_value
}
