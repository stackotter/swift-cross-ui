/// A button.
public struct Button: Component {
    /// The button's label.
    public var text: String
    
    public init(_ text: String) {
        self.text = text
    }
}
