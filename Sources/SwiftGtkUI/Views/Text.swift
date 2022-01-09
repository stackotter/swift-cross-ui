/// A text view.
public struct Text: View {
    /// The text view's content.
    public var string: String
    
    public var body: [View] = []
    
    /// Creates a new text view with the given content.
    public init(_ string: String) {
        self.string = string
    }
    
    public func asWidget() -> GtkWidget {
        return GtkLabel(text: string)
    }
}
