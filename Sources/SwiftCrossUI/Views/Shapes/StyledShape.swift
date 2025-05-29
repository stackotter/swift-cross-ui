/// A shape that has style information attached to it, including color and stroke style.
public protocol StyledShape: Shape {
    var strokeColor: Color? { get }
    var fillColor: Color? { get }
    var strokeStyle: StrokeStyle? { get }
}

struct StyledShapeImpl<Base: Shape>: Sendable {
    var base: Base
    var strokeColor: Color?
    var fillColor: Color?
    var strokeStyle: StrokeStyle?

    init(
        base: Base,
        strokeColor: Color? = nil,
        fillColor: Color? = nil,
        strokeStyle: StrokeStyle? = nil
    ) {
        self.base = base

        if let styledBase = base as? any StyledShape {
            self.strokeColor = strokeColor ?? styledBase.strokeColor
            self.fillColor = fillColor ?? styledBase.fillColor
            self.strokeStyle = strokeStyle ?? styledBase.strokeStyle
        } else {
            self.strokeColor = strokeColor
            self.fillColor = fillColor
            self.strokeStyle = strokeStyle
        }
    }
}

extension StyledShapeImpl: StyledShape {
    func path(in bounds: Path.Rect) -> Path {
        return base.path(in: bounds)
    }

    func size(fitting proposal: SIMD2<Int>) -> ViewSize {
        return base.size(fitting: proposal)
    }
}

extension Shape {
    public func fill(_ color: Color) -> some StyledShape {
        StyledShapeImpl(base: self, fillColor: color)
    }

    public func stroke(_ color: Color, style: StrokeStyle? = nil) -> some StyledShape {
        StyledShapeImpl(base: self, strokeColor: color, strokeStyle: style)
    }
}

extension StyledShape {
    @MainActor
    public func computeLayout<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend
    ) -> ViewLayoutResult {
        let size = size(fitting: proposedSize)
        return ViewLayoutResult.leafView(size: size)
    }

    @MainActor
    public func commit<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        layout: ViewLayoutResult,
        environment: EnvironmentValues,
        backend: Backend
    ) {
        let bounds = Path.Rect(
            x: 0.0,
            y: 0.0,
            width: Double(layout.size.size.x),
            height: Double(layout.size.size.y)
        )
        let path = path(in: bounds)

        let storage = children as! ShapeStorage
        let pointsChanged = storage.oldPath?.actions != path.actions
        storage.oldPath = path

        let backendPath = storage.backendPath as! Backend.Path
        backend.updatePath(
            backendPath,
            path,
            bounds: bounds,
            pointsChanged: pointsChanged,
            environment: environment
        )

        backend.setSize(of: widget, to: layout.size.size)
        backend.renderPath(
            backendPath,
            container: widget,
            strokeColor: strokeColor ?? .clear,
            fillColor: fillColor ?? .clear,
            overrideStrokeStyle: strokeStyle
        )
    }
}
