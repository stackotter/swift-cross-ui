/// A horizontally oriented container. Similar to a `HStack` in SwiftUI.
public struct HStack: Component {
    /// The container's children.
    public var children: [Component]
    
    public init(@ViewBuilder _ content: () -> [Component]) {
        self.children = content()
    }
}
