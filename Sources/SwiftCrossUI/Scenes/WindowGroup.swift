/// A scene that presents a group of identically structured windows. Currently
/// only supports having a single instance of the window but will eventually
/// support duplicating the window.
public struct WindowGroup<Content: View>: Scene {
    public typealias Node = WindowGroupNode<Content>

    var body: Content

    /// Creates a window group.
    public init(@ViewBuilder _ content: () -> Content) {
        body = content()
    }
}
