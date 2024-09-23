import Foundation
import ImageFormats

/// A view that displays an image.
public struct Image: View {
    private var image: ImageFormats.Image<RGBA>?
    private var isResizable = false

    public var body: some View {
        if let image {
            _Image(image, resizable: isResizable)
        }
    }

    /// Displays an image file. `png`, `jpg`, and `webp` are supported.
    /// - Parameters:
    ///   - url: The url of the file to display.
    ///   - useFileExtension: If `true`, the file extension is used to determine the file type,
    ///     otherwise the first few ('magic') bytes of the file are used.
    public init(_ url: URL, useFileExtension: Bool = true) {
        guard let data = try? Data(contentsOf: url) else {
            return
        }

        let bytes = Array(data)
        if useFileExtension {
            image = try? ImageFormats.Image<RGBA>.load(
                from: bytes,
                usingFileExtension: url.pathExtension
            )
        } else {
            image = try? ImageFormats.Image<RGBA>.load(from: bytes)
        }
    }

    /// Displays an image from raw pixel data.
    /// - Parameter image: The image data to display.
    public init(_ image: ImageFormats.Image<RGBA>) {
        self.image = image
    }

    /// Makes the image resize to fit the available space.
    public func resizable() -> Self {
        var image = self
        image.isResizable = true
        return image
    }
}

/// An internal implementation detail of ``Image``. Implements displaying of raw pixel data.
struct _Image: ElementaryView, View {
    private var image: ImageFormats.Image<RGBA>
    private var resizable: Bool

    init(_ image: ImageFormats.Image<RGBA>, resizable: Bool) {
        self.image = image
        self.resizable = resizable
    }

    func asWidget<Backend: AppBackend>(
        backend: Backend
    ) -> Backend.Widget {
        return backend.createImageView()
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        if !dryRun {
            backend.updateImageView(
                widget,
                rgbaData: image.data,
                width: image.width,
                height: image.height
            )
        }

        let idealSize = SIMD2(image.width, image.height)
        let size: ViewUpdateResult
        if resizable {
            size = ViewUpdateResult(
                size: proposedSize,
                idealSize: idealSize,
                minimumWidth: 0,
                minimumHeight: 0
            )
        } else {
            size = ViewUpdateResult(
                size: idealSize,
                idealSize: idealSize,
                minimumWidth: image.width,
                minimumHeight: image.height
            )
        }

        if !dryRun {
            backend.setSize(of: widget, to: size.size)
        }

        return size
    }
}
