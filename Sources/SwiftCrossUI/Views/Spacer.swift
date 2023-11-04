/// A flexible space that expands along the major axis of its containing
/// stack layout, or on both axes if not contained in a stack.
public struct Spacer: ElementaryView, View {
    /// The minimum length this spacer can be shrunk to, along the axis
    /// or axes of expansion.
    private var minLength: Int?

    /// Creates a spacer with a given minimum length along its axis or axes
    /// of expansion.
    public init(minLength: Int? = nil) {
        self.minLength = minLength
    }

    public func asWidget<Backend: AppBackend>(
        backend: Backend
    ) -> Backend.Widget {
        return backend.createSpacer()
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        backend: Backend
    ) {
        let orientation = backend.getInheritedOrientation(of: widget)
        backend.updateSpacer(
            widget,
            expandHorizontally: orientation == .vertical || orientation == nil,
            expandVertically: orientation == .vertical || orientation == nil,
            minSize: minLength ?? 0
        )
    }
}
