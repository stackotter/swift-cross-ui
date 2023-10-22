/// An image view.
public struct Image: ElementaryView {
    /// The path to the image.
    private var path: String

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
        backend.setFilePath(ofImageView: widget, to: path)
    }
}
