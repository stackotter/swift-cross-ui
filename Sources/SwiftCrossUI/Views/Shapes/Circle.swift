/// A circle.
///
/// Circles have equal widths and heights; the `Circle` shape will take on the
/// minimum of its proposed width and height.
public struct Circle: Shape {
    /// Creates a ``Circle`` instance.
    public nonisolated init() {}

    public nonisolated func path(in bounds: Path.Rect) -> Path {
        Path()
            .addCircle(center: bounds.center, radius: min(bounds.width, bounds.height) / 2.0)
    }

    public nonisolated func size(fitting proposal: SIMD2<Int>) -> ViewSize {
        let diameter = min(proposal.x, proposal.y)

        return ViewSize(
            size: SIMD2(x: diameter, y: diameter),
            idealSize: SIMD2(x: 10, y: 10),
            idealWidthForProposedHeight: proposal.y,
            idealHeightForProposedWidth: proposal.x,
            minimumWidth: 0,
            minimumHeight: 0,
            maximumWidth: nil,
            maximumHeight: nil
        )
    }
}
