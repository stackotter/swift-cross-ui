/// A button view.
public struct Button: View {
    /// The label to show on the button.
    public var label: String
    /// The action to be performed when the button is clicked.
    public var action: () -> Void

    public var body = EmptyViewContent()

    /// Creates a new button.
    public init(_ label: String, action: @escaping () -> Void = {}) {
        self.label = label
        self.action = action
    }

    public func asWidget(_ children: EmptyViewContent.Children) -> GtkButton {
        let widget = GtkButton()
        return widget
    }

    public func update(_ widget: GtkButton, children: EmptyViewContent.Children) {
        widget.label = label
        widget.clicked = { _ in action() }
    }
}
