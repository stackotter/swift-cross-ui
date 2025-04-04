public struct Circle: Shape {
    public init() {}

    public func path(in bounds: Path.Rect) -> Path {
        Path()
            .addCircle(center: bounds.center, radius: min(bounds.width, bounds.height) / 2.0)
    }

    public func size(fitting proposal: SIMD2<Int>) -> ViewSize {
        let diameter = min(proposal.x, proposal.y)

        return ViewSize(
            size: SIMD2(x: diameter, y: diameter),
            idealSize: SIMD2(x: 10, y: 10),
            idealWidthForProposedHeight: proposal.y,
            idealHeightForProposedWidth: proposal.x,
            minimumWidth: 1,
            minimumHeight: 1,
            maximumWidth: nil,
            maximumHeight: nil
        )
    }
}
