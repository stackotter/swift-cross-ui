/// An image view.
public struct Image: View {
    /// The path to the image.
    public var path: String

    public var body = EmptyViewContent()

    public init(_ path: String) {
        self.path = path
    }

    public func asWidget(_ children: EmptyViewGraphNodeChildren) -> GtkWidget {
        return GtkImage(path: path)
    }

    public func update(_ widget: GtkWidget, children: EmptyViewGraphNodeChildren) {
        let image = widget as! GtkImage
        image.setPath(path)
    }
}
