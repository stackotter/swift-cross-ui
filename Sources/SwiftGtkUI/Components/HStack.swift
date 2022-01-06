/// A horizontally oriented container. Similar to a `HStack` in SwiftUI.
public struct HStack {
    /// The
    public var children: [Component]
    
    public init(_ children: [Component]) {
        self.children = children
    }
}
