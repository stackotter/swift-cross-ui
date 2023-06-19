/// An image view.
public struct Image: View {
    public var body = EmptyViewContent()

    /// The path to the image.
    private var path: String

    public init(_ path: String) {
        self.path = path
    }

    public func asWidget(_ children: EmptyViewGraphNodeChildren) -> GtkImage {
        return GtkImage(filename: path).debugName(Self.self)
    }

    public func update(_ widget: GtkImage, children: EmptyViewGraphNodeChildren) {
        widget.setPath(path)
    }
}
