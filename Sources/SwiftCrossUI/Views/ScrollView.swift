/// A view that is scrollable when it would otherwise overflow available space. Use the
/// ``View/frame`` modifier to constrain height if necessary.
public struct ScrollView<Content: View>: View {
    public var body: Content

    /// Wraps a view in a scrollable container.
    public init(@ViewBuilder _ content: () -> Content) {
        body = content()
    }

    public func asWidget<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren,
        backend: Backend
    ) -> Backend.Widget {
        let vStack = backend.createVStack()
        backend.setChildren(children.widgets(for: backend), ofVStack: vStack)

        return backend.createScrollContainer(for: vStack)
    }
}
