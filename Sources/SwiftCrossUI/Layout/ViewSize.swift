/// The size of a view. Includes ideal size, and minimum/maximum width and height
/// along with the size you'd expect.
///
/// The width and height components of the view's minimum and maximum sizes are
/// stored separately to make it extra clear that they don't always form some
/// sort of achievable minimum/maximum size. The provided minimum/maximum bounds
/// may only be achievable along a single axis at a time.
public struct ViewSize: Equatable, Sendable {
    /// The view update result for an empty view.
    public static let empty = ViewSize(
        size: .zero,
        idealSize: .zero,
        minimumWidth: 0,
        minimumHeight: 0,
        maximumWidth: 0,
        maximumHeight: 0
    )

    /// The view update result for a hidden view. Differs from ``ViewSize/empty``
    /// by stopping hidden views from participating in stack layouts (i.e.
    /// getting spacing between the previous child and the hidden child).
    public static let hidden = ViewSize(
        size: .zero,
        idealSize: .zero,
        minimumWidth: 0,
        minimumHeight: 0,
        maximumWidth: 0,
        maximumHeight: 0,
        participateInStackLayoutsWhenEmpty: false
    )

    /// The size that the view now takes up.
    public var size: SIMD2<Int>
    /// The size that the view ideally wants to take up.
    public var idealSize: SIMD2<Int>
    /// The width that the view ideally wants to take up assuming that the
    /// proposed height doesn't change. Only really differs from `idealSize` for
    /// views that have a trade-off between width and height (such as `Text`).
    public var idealWidthForProposedHeight: Int
    /// The height that the view ideally wants to take up assuming that the
    /// proposed width doesn't change. Only really differs from `idealSize` for
    /// views that have a trade-off between width and height (such as `Text`).
    public var idealHeightForProposedWidth: Int
    /// The minimum width that the view can take (if its height remains the same).
    public var minimumWidth: Int
    /// The minimum height that the view can take (if its width remains the same).
    public var minimumHeight: Int
    /// The maximum width that the view can take (if its height remains the same).
    public var maximumWidth: Double
    /// The maximum height that the view can take (if its width remains the same).
    public var maximumHeight: Double
    /// Whether the view should participate in stack layouts when empty.
    ///
    /// If `false`, the view won't get any spacing before or after it in stack
    /// layouts. For example, this is used by ``OptionalView`` when its
    /// underlying view is `nil` to avoid having spacing between views that are
    /// semantically 'not present'.
    ///
    /// Only takes effect when ``ViewSize/size`` is zero, to avoid any ambiguity
    /// when the view has non-zero size as this option is really only intended
    /// to be used for visually hidden views (what would it mean for a non-empty
    /// view to not participate in the layout? would the spacing between the
    /// previous view and the next go before or after the view? would the view
    /// get forced to zero size?).
    public var participateInStackLayoutsWhenEmpty: Bool

    /// The view's ideal aspect ratio, computed from ``ViewSize/idealSize``. If
    /// either of the view's ideal dimensions are 0, then the aspect ratio
    /// defaults to 1.
    public var idealAspectRatio: Double {
        LayoutSystem.aspectRatio(of: SIMD2(idealSize))
    }

    public init(
        size: SIMD2<Int>,
        idealSize: SIMD2<Int>,
        idealWidthForProposedHeight: Int? = nil,
        idealHeightForProposedWidth: Int? = nil,
        minimumWidth: Int,
        minimumHeight: Int,
        maximumWidth: Double?,
        maximumHeight: Double?,
        participateInStackLayoutsWhenEmpty: Bool = true
    ) {
        self.size = size
        self.idealSize = idealSize
        self.idealWidthForProposedHeight = idealWidthForProposedHeight ?? idealSize.x
        self.idealHeightForProposedWidth = idealHeightForProposedWidth ?? idealSize.y
        self.minimumWidth = minimumWidth
        self.minimumHeight = minimumHeight
        // Using `Double(1 << 53)` as the default allows us to differentiate between views
        // with unlimited size and different minimum sizes when calculating view flexibility.
        // If we use `Double.infinity` then all views with unlimited size have infinite
        // flexibility, meaning that there's no difference when sorting, even though the
        // minimum size should still affect view layout. Similarly, if we use
        // `Double.greatestFiniteMagnitude` we don't have enough precision to get different results
        // when subtracting reasonable minimum dimensions. The chosen value for 'unlimited'
        // width/height is in the range where the gap between consecutive Doubles is `1`, which
        // I believe is a good compromise.
        self.maximumWidth = maximumWidth ?? Double(1 << 53)
        self.maximumHeight = maximumHeight ?? Double(1 << 53)
        self.participateInStackLayoutsWhenEmpty =
            participateInStackLayoutsWhenEmpty
    }

    public init(fixedSize: SIMD2<Int>) {
        size = fixedSize
        idealSize = fixedSize
        idealWidthForProposedHeight = fixedSize.x
        idealHeightForProposedWidth = fixedSize.y
        minimumWidth = fixedSize.x
        minimumHeight = fixedSize.y
        maximumWidth = Double(fixedSize.x)
        maximumHeight = Double(fixedSize.y)
        participateInStackLayoutsWhenEmpty = true
    }
}
