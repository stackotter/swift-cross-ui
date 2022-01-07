/// A view composed of components.
public protocol View: Component {
    /// The view's child components.
    @ViewBuilder var body: [Component] { get }
}
