/// A horizontally oriented container. Similar to a `HStack` in SwiftUI.
public struct HStack<Content: View>: View {
    public var body: Content

    /// The amount of spacing to apply between children.
    private var spacing: Int

    /// Creates a new HStack.
    public init(spacing: Int = 8, @ViewBuilder _ content: () -> Content) {
        body = content()
        self.spacing = spacing
    }

    public func asWidget<Backend: AppBackend>(
        _ children: [Backend.Widget],
        backend: Backend
    ) -> Backend.Widget {
        let hStack = backend.createHStack(spacing: spacing)
        backend.addChildren(children, toHStack: hStack)
        return hStack
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget, children: [Backend.Widget], backend: Backend
    ) {
        backend.setSpacing(ofHStack: widget, to: spacing)
    }
}
