/// A text view.
public struct Text: View {
    /// The text view's content.
    public var string: String
    
    public var body = EmptyViewContent()
    
    /// Creates a new text view with the given content.
    public init(_ string: String) {
        self.string = string
    }
    
    public func asWidget(_ children: EmptyViewContent.Children) -> GtkWidget {
        let widget = GtkLabel(text: string)
        return widget
    }
    
    public func update(_ widget: GtkWidget) {
        let widget = widget as! GtkLabel
        widget.text = string
    }
}
