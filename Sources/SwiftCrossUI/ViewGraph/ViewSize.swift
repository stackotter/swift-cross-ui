/// The size of a view. Includes ideal size, and minimum/maximum width and height
/// along with the size you'd expect.
///
/// The width and height components of the view's minimum and maximum sizes are
/// stored separately to make it extra clear that they don't always form some
/// sort of achievable minimum/maximum size. The provided minimum/maximum bounds
/// may only be achievable along a single axis at a time.
public struct ViewSize: Equatable {
    /// The view update result for an empty view.
    public static let empty = ViewSize(
        size: .zero,
        idealSize: .zero,
        minimumWidth: 0,
        minimumHeight: 0,
        maximumWidth: 0,
        maximumHeight: 0
    )

    /// The size that the view now takes up.
    public var size: SIMD2<Int>
    /// The size that the view ideally wants to take up.
    public var idealSize: SIMD2<Int>
    /// The minimum width that the view can take (if its height remains the same).
    public var minimumWidth: Int
    /// The minimum height that the view can take (if its width remains the same).
    public var minimumHeight: Int
    /// The maximum width that the view can take (if its height remains the same).
    public var maximumWidth: Double
    /// The maximum height that the view can take (if its width remains the same).
    public var maximumHeight: Double

    public init(
        size: SIMD2<Int>,
        idealSize: SIMD2<Int>,
        minimumWidth: Int,
        minimumHeight: Int,
        maximumWidth: Double?,
        maximumHeight: Double?
    ) {
        self.size = size
        self.idealSize = idealSize
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
    }

    public init(fixedSize: SIMD2<Int>) {
        size = fixedSize
        idealSize = fixedSize
        minimumWidth = fixedSize.x
        minimumHeight = fixedSize.y
        maximumWidth = Double(fixedSize.x)
        maximumHeight = Double(fixedSize.y)
    }
}
