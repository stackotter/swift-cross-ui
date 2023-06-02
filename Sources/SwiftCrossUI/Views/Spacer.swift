/// A flexible space that expands along the major axis of its containing stack layout, or on both axes if not contained in a stack.
public struct Spacer: View {
    public var body = EmptyViewContent()

    /// The minimum length this spacer can be shrunk to, along the axis or axes of expansion.
    var minLength: Int?

    public init(minLength: Int? = nil) {
        self.minLength = minLength
    }

    public func asWidget(_ children: EmptyViewGraphNodeChildren) -> GtkBox {
        return GtkBox()
    }

    public func update(_ widget: GtkBox, children: EmptyViewGraphNodeChildren) {
        let orientableParent = widget.parentWidget as? GtkOrientable

        switch orientableParent?.orientation {
        case .horizontal:
            widget.leftMargin = minLength ?? 0
            widget.expandHorizontally = true
        case .vertical:
            widget.topMargin = minLength ?? 0
            widget.expandVertically = true
        case nil:
            widget.leftMargin = minLength ?? 0
            widget.topMargin = minLength ?? 0
            widget.expandHorizontally = true
            widget.expandVertically = true
        }
    }
}
