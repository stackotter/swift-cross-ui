public struct Rectangle: Shape {
    public nonisolated init() {}

    public nonisolated func path(in bounds: Path.Rect) -> Path {
        Path().addRectangle(bounds)
    }
}
