/// A button view.
public struct Button: View {
    public var body = EmptyViewContent()

    /// The label to show on the button.
    private var label: String
    /// The action to be performed when the button is clicked.
    private var action: () -> Void

    /// Creates a new button.
    public init(_ label: String, action: @escaping () -> Void = {}) {
        self.label = label
        self.action = action
    }

    public func asWidget(_ children: EmptyViewContent.Children) -> GtkButton {
        return GtkButton().debugName(Self.self)
    }

    public func update(_ widget: GtkButton, children: EmptyViewContent.Children) {
        widget.label = label
        widget.clicked = { _ in action() }
    }
}
