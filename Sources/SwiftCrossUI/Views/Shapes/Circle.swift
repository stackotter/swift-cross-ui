/// A circle.
///
/// Circles have equal widths and heights; the `Circle` shape will take on the
/// minimum of its proposed width and height.
public struct Circle: Shape {
    /// The ideal diameter of a `Circle`.
    static let idealDiameter = 10.0

    /// Creates a ``Circle`` instance.
    public nonisolated init() {}

    public nonisolated func path(in bounds: Path.Rect) -> Path {
        Path()
            .addCircle(center: bounds.center, radius: min(bounds.width, bounds.height) / 2.0)
    }

    public nonisolated func size(fitting proposal: ProposedViewSize) -> ViewSize {
        let diameter: Double
        if let proposal = proposal.concrete {
            diameter = min(proposal.width, proposal.height)
        } else {
            diameter = proposal.width ?? proposal.height ?? 10
        }

        return ViewSize(diameter, diameter)
    }
}
