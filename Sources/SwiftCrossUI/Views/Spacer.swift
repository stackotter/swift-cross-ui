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
        let spacer = backend.createSpacer(expandHorizontally: false, expandVertically: false)
        return backend.createPaddingContainer(for: spacer)
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        backend: Backend
    ) {
        let spacer = backend.getChild(ofPaddingContainer: widget)
        switch backend.getInheritedOrientation(of: widget) {
            case .horizontal:
                backend.setExpandHorizontally(ofSpacer: spacer, to: true)
                backend.setExpandVertically(ofSpacer: spacer, to: false)
                backend.setPadding(
                    ofPaddingContainer: widget,
                    top: 0,
                    bottom: 0,
                    leading: minLength ?? 0,
                    trailing: 0
                )
            case .vertical:
                backend.setExpandHorizontally(ofSpacer: spacer, to: false)
                backend.setExpandVertically(ofSpacer: spacer, to: true)
                backend.setPadding(
                    ofPaddingContainer: widget,
                    top: minLength ?? 0,
                    bottom: 0,
                    leading: 0,
                    trailing: 0
                )
            case nil:
                backend.setExpandHorizontally(ofSpacer: spacer, to: true)
                backend.setExpandVertically(ofSpacer: spacer, to: true)
                backend.setPadding(
                    ofPaddingContainer: widget,
                    top: minLength ?? 0,
                    bottom: 0,
                    leading: minLength ?? 0,
                    trailing: 0
                )
        }
    }
}
