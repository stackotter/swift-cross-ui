/// A vertically oriented container. Similar to a `VStack` in SwiftUI.
public struct VStack: View {
    public var body: [View]
    
    /// Creates a new VStack.
    public init(@ViewBuilder _ content: () -> [View]) {
        body = content()
    }
}
