public struct Rectangle: Shape {
    public init() {}

    public func path(in bounds: Path.Rect) -> Path {
        Path().addRectangle(bounds)
    }
}
