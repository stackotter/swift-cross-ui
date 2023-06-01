// TODO: Remove View conformance from ViewContent because it's just a bit of a hack to get
// _EitherView and _OptionalView working.
public protocol ViewContent: View {
    associatedtype Children: ViewGraphNodeChildren where Children.Content == Self
}

extension ViewContent where Content == Self, State == EmptyState {
    public var body: Self {
        return self
    }

    public func asWidget(_ children: Children) -> GtkBox {
        let box = GtkBox(orientation: .vertical, spacing: 0)
        for widget in children.widgets {
            box.add(widget)
        }
        return box
    }
}

public struct EmptyViewContent: ViewContent {
    public typealias Children = EmptyViewGraphNodeChildren

    public init() {}
}

@available(macOS 99.99.0, *)
public struct ViewContentVariadic<each ChildView: View>: ViewContent {
    public typealias Children = ViewGraphNodeChildrenVariadic<repeat each ChildView>

    public var views: (repeat each ChildView)

    public init(_ views: repeat each ChildView) {
        self.views = (repeat each views)
    }
}
