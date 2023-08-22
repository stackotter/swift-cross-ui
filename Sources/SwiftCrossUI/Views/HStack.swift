/// A horizontally oriented container. Similar to a `HStack` in SwiftUI.
public struct HStack<Content: ViewContent>: View {
    public var body: Content

    /// The amount of spacing to apply between children.
    private var spacing: Int

    /// Creates a new HStack.
    public init(spacing: Int = 8, @ViewContentBuilder _ content: () -> Content) {
        body = content()
        self.spacing = spacing
    }

    public func asWidget<Backend: AppBackend>(
        _ children: Content.Children,
        backend: Backend
    ) -> Backend.Widget {
        let hStack = backend.createHStack(spacing: spacing)
        backend.addChildren(children.widgets, toHStack: hStack)
        return hStack
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget, children: Content.Children, backend: Backend
    ) {
        backend.setSpacing(ofHStack: widget, to: spacing)
    }
}
