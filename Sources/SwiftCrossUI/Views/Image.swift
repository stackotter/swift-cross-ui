/// A view that displays an image.
public struct Image: ElementaryView, View {
    /// The path to the image.
    private var path: String

    /// Creates an image displaying an image file.
    public init(_ path: String) {
        self.path = path
    }

    public func asWidget<Backend: AppBackend>(
        backend: Backend
    ) -> Backend.Widget {
        return backend.createImageView(filePath: path)
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        backend: Backend
    ) {
        backend.updateImageView(widget, filePath: path)
    }
}
