/// A navigation primitive that appends a value to the current navigation path on click.
///
/// Unlike Apples SwiftUI API a `NavigationLink` can be outside of a `NavigationStack` as long as they share the same `NavigationPath`
@available(macOS 99.99.0, *)
public struct NavigationLink: View {
    public var body: ViewContentVariadic<Button> {
        Button(label) {
            path.wrappedValue.append(value)
        }
    }

    /// The label to display on the button.
    private let label: String
    /// The value to append to the navigation path when clicked.
    private let value: any Codable
    /// The navigation path to append to when clicked.
    private let path: Binding<NavigationPath>

    /// Creates a navigation link that presents the view corresponding to a value in the NavigationStack that uses the same path.
    public init<C: Codable>(_ label: String, value: C, path: Binding<NavigationPath>) {
        self.label = label
        self.value = value
        self.path = path
    }
}
