/// A horizontally oriented container. Similar to a `HStack` in SwiftUI.
public struct HStack: View {
    public var body: [View]
    
    /// Creates a new HStack.
    public init(@ViewBuilder _ content: () -> [View]) {
        body = content()
    }
    
    public func asWidget() -> GtkWidget {
        let container = GtkBox(orientation: .horizontal, spacing: 8)
        for view in body {
            container.add(view.asWidget())
        }
        return container
    }
}
