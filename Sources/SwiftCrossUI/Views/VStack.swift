/// A vertically oriented container. Similar to a `VStack` in SwiftUI.
public struct VStack<Content: View>: View {
    public var body: Content

    /// The amount of spacing to apply between children.
    private var spacing: Int

    /// Creates a new VStack.
    public init(spacing: Int = 8, @ViewBuilder _ content: () -> Content) {
        body = content()
        self.spacing = spacing
    }

    /// Internal initialiser for creating arbitrary VStack's.
    init(_ content: Content) {
        body = content
        spacing = 8
    }

    public func asWidget<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren,
        backend: Backend
    ) -> Backend.Widget {
        let vStack = backend.createVStack(spacing: spacing)
        backend.addChildren(children.widgets(for: backend), toVStack: vStack)
        return vStack
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget, children: any ViewGraphNodeChildren, backend: Backend
    ) {
        backend.setSpacing(ofVStack: widget, to: spacing)
    }
}
