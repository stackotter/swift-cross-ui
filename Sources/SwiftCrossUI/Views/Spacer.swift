/// A flexible space that expands along the major axis of its containing stack layout, or on both axes if not contained in a stack.
public struct Spacer: View {
    public var body = EmptyViewContent()

    /// The minimum length this spacer can be shrunk to, along the axis or axes of expansion.
    var minLength: Int?

    public init(minLength: Int? = nil) {
        self.minLength = minLength
    }

    public func asWidget(_ children: EmptyViewGraphNodeChildren) -> GtkModifierBox {
        return GtkModifierBox().debugName(Self.self)
    }

    public func update(_ widget: GtkModifierBox, children: EmptyViewGraphNodeChildren) {
        let parent = widget.firstNonModifierParent() as? GtkBox

        switch parent?.orientation {
            case .horizontal:
                widget.leadingMargin = minLength ?? 0
                widget.expandHorizontally = true
                widget.expandVertically = false
            case .vertical:
                widget.topMargin = minLength ?? 0
                widget.expandHorizontally = false
                widget.expandVertically = true
            case nil:
                widget.leadingMargin = minLength ?? 0
                widget.topMargin = minLength ?? 0
                widget.expandHorizontally = true
                widget.expandVertically = true
        }
    }
}
