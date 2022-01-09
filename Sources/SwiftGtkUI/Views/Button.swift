/// A button view.
public struct Button: View {
    /// The button's label.
    public var label: String
    public var action: () -> Void
    
    public var body: [View] = []
    
    /// Creates a new button.
    public init(_ label: String, action: @escaping () -> Void = { }) {
        self.label = label
        self.action = action
    }
    
    public func asWidget() -> GtkWidget {
        let button = GtkButton()
        button.label = label
        button.clicked = { _ in action() }
        return button
    }
}
