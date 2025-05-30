/// A proposed view size. Uses `nil` to indicate when the ideal size should
/// be used along a given axis.
public struct SizeProposal: Hashable {
    /// An empty proposal.
    public static let zero = Self(0, 0)

    /// A proposal for the view to take on its ideal size.
    static let ideal = Self(nil, nil)

    /// The proposed width. If `nil`, the view should take on its ideal
    /// width for the proposed height.
    public var width: Int?
    /// The proposed height. If `nil`, the view should take on its ideal
    /// height for the proposed width.
    public var height: Int?

    /// The proposal as a concrete size if both dimensions are non-nil,
    /// otherwise nil.
    var concrete: SIMD2<Int>? {
        guard let width, let height else {
            return nil
        }
        return SIMD2(width, height)
    }

    /// Creates a new size proposal. Use `nil` for dimensions that the view
    /// should take on its ideal size along.
    public init(_ width: Int?, _ height: Int?) {
        self.width = width
        self.height = height
    }

    /// Creates a new size proposal from a concrete size.
    public init(_ size: SIMD2<Int>) {
        self.width = size.x
        self.height = size.y
    }

    /// Evaluates the size proposal with a view's ideal size.
    package func evaluated(withIdealSize idealSize: SIMD2<Int>) -> SIMD2<Int> {
        SIMD2(
            width ?? idealSize.x,
            height ?? idealSize.y
        )
    }
}
