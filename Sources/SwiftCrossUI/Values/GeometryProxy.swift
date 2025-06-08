/// A proxy for querying a view's geometry. See ``GeometryReader``.
public struct GeometryProxy {
    /// The size proposed to the view by its parent. In the context of
    /// ``GeometryReader``, this is the size that the ``GeometryReader``
    /// will take on (to prevent feedback loops).
    public var size: SIMD2<Int>
}
