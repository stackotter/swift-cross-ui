/// An image view.
public struct Image: View {
    /// The path to the image.
    public var path: String

    public var body = EmptyViewContent()

    public init(_ path: String) {
        self.path = path
    }

    public func asWidget(_ children: EmptyViewGraphNodeChildren) -> GtkImage {
        return GtkImage(path: path)
    }

    public func update(_ widget: GtkImage, children: EmptyViewGraphNodeChildren) {
        widget.setPath(path)
    }
}
