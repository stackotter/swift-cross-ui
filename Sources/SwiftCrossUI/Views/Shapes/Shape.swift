public protocol Shape: View
where Content == EmptyView {
    /// Draw the path for this shape.
    func path(in bounds: Path.Rect) -> Path
    /// Determine the ideal size of this shape given the proposed bounds.
    ///
    /// The default implementation accepts the proposal and imposes no practical limit on
    /// the shape's size.
    /// - Returns: Information about the shape's size. The ``ViewSize/size`` property is what
    ///   frame the shape will actually be rendered with if the current layout pass is not
    ///   a dry run, while the other properties are used to inform the layout engine how big
    ///   or small the shape can be. The ``ViewSize/idealSize`` property should not vary with
    ///   the `proposal`, and should only depend on the view's contents. Pass `nil` for the
    ///   maximum width/height if the shape has no maximum size (and therefore may occupy
    ///   the entire screen).
    func size(fitting proposal: SIMD2<Int>) -> ViewSize
}

extension Shape {
    public var body: EmptyView { return EmptyView() }

    public func size(fitting proposal: SIMD2<Int>) -> ViewSize {
        return ViewSize(
            size: proposal,
            idealSize: SIMD2(x: 10, y: 10),
            minimumWidth: 1,
            minimumHeight: 1,
            maximumWidth: nil,
            maximumHeight: nil
        )
    }

    public func children<Backend: AppBackend>(
        backend _: Backend,
        snapshots _: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment _: EnvironmentValues
    ) -> any ViewGraphNodeChildren {
        ShapeStorage()
    }

    public func asWidget<Backend: AppBackend>(
        _ children: any ViewGraphNodeChildren, backend: Backend
    ) -> Backend.Widget {
        let container = backend.createContainer()
        let storage = children as! ShapeStorage
        storage.backendPath = backend.createPath()
        storage.oldPath = nil
        return container
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget, children: any ViewGraphNodeChildren, proposedSize: SIMD2<Int>,
        environment: EnvironmentValues, backend: Backend, dryRun: Bool
    ) -> ViewUpdateResult {
        let storage = children as! ShapeStorage
        let size = size(fitting: proposedSize)

        let path = path(
            in: Path.Rect(x: 0.0, y: 0.0, width: Double(size.size.x), height: Double(size.size.y))
        )

        let pointsChanged = storage.oldPath?.actions != path.actions
        storage.oldPath = path

        let backendPath = storage.backendPath as! Backend.Path
        backend.updatePath(backendPath, path, pointsChanged: pointsChanged)

        if !dryRun {
            backend.setSize(of: widget, to: size.size)
            backend.renderPath(
                backendPath,
                container: widget,
                strokeColor: .clear,
                fillColor: environment.suggestedForegroundColor,
                overrideStrokeStyle: nil
            )
        }

        return ViewUpdateResult.leafView(size: size)
    }
}

final class ShapeStorage: ViewGraphNodeChildren {
    let widgets: [AnyWidget] = []
    let erasedNodes: [ErasedViewGraphNode] = []
    var backendPath: Any!
    var oldPath: Path?
}
