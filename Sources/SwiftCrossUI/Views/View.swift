import Foundation

/// A view that can be displayed by SwiftCrossUI.
public protocol View {
    associatedtype Content: ViewContent
    associatedtype State: ViewState

    var state: State { get set }

    /// The view's contents.
    @ViewContentBuilder var body: Content { get }

    func asWidget(_ children: Content.Children) -> GtkWidget

    func update(_ widget: GtkWidget, children: Content.Children)
}

public extension View {
    func asWidget(_ children: Content.Children) -> GtkWidget {
        let vStack = GtkBox(orientation: .vertical, spacing: 8)
        for widget in children.widgets {
            vStack.add(widget)
        }
        return vStack
    }

    func update(_ widget: GtkWidget, children: Content.Children) {}
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
