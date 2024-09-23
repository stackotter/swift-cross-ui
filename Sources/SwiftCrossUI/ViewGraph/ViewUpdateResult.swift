/// The result of a view update.
public struct ViewUpdateResult: Equatable {
    /// The view update result for an empty view.
    public static let empty = ViewUpdateResult(
        size: .zero,
        idealSize: .zero,
        minimumWidth: 0,
        minimumHeight: 0
    )

    /// The size that the view now takes up.
    public var size: SIMD2<Int>
    /// The size that the view ideally wants to take up.
    public var idealSize: SIMD2<Int>
    /// The minimum width that the view can take (if its height remains the same).
    public var minimumWidth: Int
    /// The minimum height that the view can take (if its width remains the same).
    public var minimumHeight: Int

    public init(size: SIMD2<Int>, idealSize: SIMD2<Int>, minimumWidth: Int, minimumHeight: Int) {
        self.size = size
        self.idealSize = idealSize
        self.minimumWidth = minimumWidth
        self.minimumHeight = minimumHeight
    }

    public init(fixedSize: SIMD2<Int>) {
        size = fixedSize
        idealSize = fixedSize
        minimumWidth = fixedSize.x
        minimumHeight = fixedSize.y
    }
}
