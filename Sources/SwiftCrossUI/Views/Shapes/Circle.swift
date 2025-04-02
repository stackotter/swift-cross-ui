public struct Circle: Shape {
    public init() {}

    public func path(in bounds: Path.Rect) -> Path {
        Path().addCircle(
            center: SIMD2(x: bounds.x + bounds.width / 2.0, y: bounds.y + bounds.height / 2.0),
            radius: min(bounds.width, bounds.height) / 2.0
        )
    }

    public func size(fitting proposal: SIMD2<Int>) -> SIMD2<Int> {
        let minDim = min(proposal.x, proposal.y)
        return SIMD2(x: minDim, y: minDim)
    }
}
