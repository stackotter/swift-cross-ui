/// A view composed of components.
public protocol View {
    /// The view's child components.
    var body: [Component] { get }
}
