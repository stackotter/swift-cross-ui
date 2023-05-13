/// A view that is scrollable when it would otherwise overflow available space. Use the
/// ``View/frame`` modifier to constrain height if necessary.
public struct ScrollView<Content: ViewContent>: View {
    public var body: Content

    /// Creates a new ScrollView.
    public init(@ViewContentBuilder _ content: () -> Content) {
        body = content()
    }

    /// Internal initialiser for creating arbitrary VStack's.
    init(_ content: Content) {
        body = content
    }

    public func asWidget(_ children: Content.Children) -> GtkScrolledWindow {
        let vStack = VStack(body).asWidget(children)

        let scrolledWindow = GtkScrolledWindow()
        scrolledWindow.setChild(vStack)
        scrolledWindow.propagateNaturalHeight = true
        return scrolledWindow
    }
}
