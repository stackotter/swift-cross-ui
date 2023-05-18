import Foundation

/// A view that can be displayed by SwiftCrossUI.
public protocol View {
    associatedtype Content: ViewContent
    associatedtype State: Observable
    associatedtype Widget: GtkWidget

    var state: State { get set }

    /// The view's contents.
    @ViewContentBuilder var body: Content { get }

    func asWidget(_ children: Content.Children) -> Widget

    func update(_ widget: Widget, children: Content.Children)
}

extension View where Widget == GtkBox {
    public func asWidget(_ children: Content.Children) -> GtkBox {
        let vStack = GtkBox(orientation: .vertical, spacing: 8)
        for widget in children.widgets {
            vStack.add(widget)
        }
        return vStack
    }
}

extension View {
    public func update(_ widget: Widget, children: Content.Children) {}
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
