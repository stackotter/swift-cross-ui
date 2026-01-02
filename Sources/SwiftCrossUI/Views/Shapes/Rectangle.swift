/// A rectangle.
public struct Rectangle: Shape {
    /// Creates a ``Rectangle`` instance.
    public nonisolated init() {}

    public nonisolated func path(in bounds: Path.Rect) -> Path {
        Path().addRectangle(bounds)
    }
}
