/// A view that controls a navigation presentation.
///
/// Unlike Apples SwiftUI API a `NavigationLink` can be outside of a `NavigationStack` as long as they share the same `NavigationPath`
public struct NavigationLink: View {
    public var body: ViewContent1<Button> {
        Button(label, action: {
            path.wrappedValue.append(value)
        })
    }

    private let label: String
    private let value: AnyHashable
    private let path: Binding<NavigationPath>

    /// Creates a navigation link that presents the view corresponding to a value in the NavigationStack that uses the same path.
    public init(_ label: String, value: AnyHashable, path: Binding<NavigationPath>) {
        self.label = label
        self.value = value
        self.path = path
    }

    public func asWidget(_ children: ViewContent1<Button>.Children) -> Button.Widget {
        return children.child0.widget
    }
}