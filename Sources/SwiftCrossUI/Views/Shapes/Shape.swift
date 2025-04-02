public protocol Shape: View
where Content == EmptyView {
    /// Draw the path for this shape.
    func path(in bounds: Path.Rect) -> Path
    /// Determine the ideal size of this shape given the proposed bounds.
    ///
    /// The default implementation returns the proposal unmodified.
    func size(fitting proposal: SIMD2<Int>) -> SIMD2<Int>
}

extension Shape {
    public var body: EmptyView { return EmptyView() }

    public func size(fitting proposal: SIMD2<Int>) -> SIMD2<Int> {
        return proposal
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

        let path = path(in: Path.Rect(x: 0.0, y: 0.0, width: Float(size.x), height: Float(size.y)))
        let pointsChanged = storage.oldPath?.actions != path.actions
        storage.oldPath = path

        let backendPath = storage.backendPath as! Backend.Path
        backend.updatePath(backendPath, path, pointsChanged: pointsChanged)

        if !dryRun {
            backend.setSize(of: widget, to: size)
            backend.renderPath(backendPath, container: widget, environment: environment)
        }

        return ViewUpdateResult.leafView(
            size: ViewSize(
                size: size,
                idealSize: SIMD2(x: 10, y: 10),
                minimumWidth: 0,
                minimumHeight: 0,
                maximumWidth: nil,
                maximumHeight: nil
            )
        )
    }
}

final class ShapeStorage: ViewGraphNodeChildren {
    let widgets: [AnyWidget] = []
    let erasedNodes: [ErasedViewGraphNode] = []
    var backendPath: Any!
    var oldPath: Path?
}
