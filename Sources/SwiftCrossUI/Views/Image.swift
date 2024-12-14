import Foundation
import ImageFormats

/// A view that displays an image.
public struct Image: TypeSafeView, View {
    private var isResizable = false
    private var source: Source

    enum Source: Equatable {
        case url(URL, useFileExtension: Bool)
        case image(ImageFormats.Image<RGBA>)
    }

    public var body = EmptyView()

    /// Displays an image file. `png`, `jpg`, and `webp` are supported.
    /// - Parameters:
    ///   - url: The url of the file to display.
    ///   - useFileExtension: If `true`, the file extension is used to determine the file type,
    ///     otherwise the first few ('magic') bytes of the file are used.
    public init(_ url: URL, useFileExtension: Bool = true) {
        source = .url(url, useFileExtension: useFileExtension)
    }

    /// Displays an image from raw pixel data.
    /// - Parameter image: The image data to display.
    public init(_ image: ImageFormats.Image<RGBA>) {
        source = .image(image)
    }

    /// Makes the image resize to fit the available space.
    public func resizable() -> Self {
        var image = self
        image.isResizable = true
        return image
    }

    init(_ source: Source, resizable: Bool) {
        self.source = source
        self.isResizable = resizable
    }

    func layoutableChildren<Backend: AppBackend>(
        backend: Backend,
        children: _ImageChildren
    ) -> [LayoutSystem.LayoutableChild] {
        []
    }

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: EnvironmentValues
    ) -> _ImageChildren {
        _ImageChildren(backend: backend)
    }

    func asWidget<Backend: AppBackend>(
        _ children: _ImageChildren,
        backend: Backend
    ) -> Backend.Widget {
        children.container.into()
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: _ImageChildren,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewSize {
        let image: ImageFormats.Image<RGBA>?
        if source != children.cachedImageSource {
            switch source {
                case .url(let url, let useFileExtension):
                    if let data = try? Data(contentsOf: url) {
                        let bytes = Array(data)
                        if useFileExtension {
                            image = try? ImageFormats.Image<RGBA>.load(
                                from: bytes,
                                usingFileExtension: url.pathExtension
                            )
                        } else {
                            image = try? ImageFormats.Image<RGBA>.load(from: bytes)
                        }
                    } else {
                        image = nil
                    }
                case .image(let sourceImage):
                    image = sourceImage
            }

            children.cachedImageSource = source
            children.cachedImage = image
            children.imageChanged = true
        } else {
            image = children.cachedImage
        }

        let idealSize = SIMD2(image?.width ?? 0, image?.height ?? 0)
        let size: ViewSize
        if isResizable {
            size = ViewSize(
                size: image == nil ? .zero : proposedSize,
                idealSize: idealSize,
                minimumWidth: 0,
                minimumHeight: 0,
                maximumWidth: image == nil ? 0 : nil,
                maximumHeight: image == nil ? 0 : nil
            )
        } else {
            size = ViewSize(fixedSize: idealSize)
        }

        let hasResized = children.cachedImageDisplaySize != size.size
        if !dryRun && (children.imageChanged || hasResized) {
            if let image {
                backend.updateImageView(
                    children.imageWidget.into(),
                    rgbaData: image.bytes,
                    width: image.width,
                    height: image.height,
                    targetWidth: size.size.x,
                    targetHeight: size.size.y,
                    dataHasChanged: children.imageChanged
                )
                if children.isContainerEmpty {
                    backend.addChild(children.imageWidget.into(), to: children.container.into())
                    backend.setPosition(ofChildAt: 0, in: children.container.into(), to: .zero)
                }
                children.isContainerEmpty = false
            } else {
                backend.removeAllChildren(of: children.container.into())
                children.isContainerEmpty = true
            }
            children.imageChanged = false
        }

        children.cachedImageDisplaySize = size.size

        if !dryRun {
            backend.setSize(of: children.container.into(), to: size.size)
            backend.setSize(of: children.imageWidget.into(), to: size.size)
        }

        return size
    }
}

class _ImageChildren: ViewGraphNodeChildren {
    var cachedImageSource: Image.Source? = nil
    var cachedImage: ImageFormats.Image<RGBA>? = nil
    var cachedImageDisplaySize: SIMD2<Int> = .zero
    var container: AnyWidget
    var imageWidget: AnyWidget
    var imageChanged = false
    var isContainerEmpty = true

    init<Backend: AppBackend>(backend: Backend) {
        container = AnyWidget(backend.createContainer())
        imageWidget = AnyWidget(backend.createImageView())
    }

    var widgets: [AnyWidget] = []
    var erasedNodes: [ErasedViewGraphNode] = []
}
