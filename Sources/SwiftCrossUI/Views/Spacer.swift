/// A flexible space that expands along the major axis of its containing
/// stack layout, or on both axes if not contained in a stack.
public struct Spacer: ElementaryView, View {
    /// The minimum length this spacer can be shrunk to, along the axis
    /// or axes of expansion.
    private var minLength: Int?

    public var flexibility: Int {
        1000
    }

    /// Creates a spacer with a given minimum length along its axis or axes
    /// of expansion.
    public init(minLength: Int? = nil) {
        self.minLength = minLength
    }

    public func asWidget<Backend: AppBackend>(
        backend: Backend
    ) -> Backend.Widget {
        return backend.createContainer()
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend
    ) -> SIMD2<Int> {
        let minLength = minLength ?? 0

        let size: SIMD2<Int>
        switch environment.layoutOrientation {
            case .horizontal:
                size = SIMD2(max(minLength, proposedSize.x), 0)
            case .vertical:
                size = SIMD2(0, max(minLength, proposedSize.y))
        }

        backend.setSize(of: widget, to: size)
        return size
    }
}
