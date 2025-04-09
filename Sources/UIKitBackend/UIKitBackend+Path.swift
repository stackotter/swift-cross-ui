import SwiftCrossUI
import UIKit

extension UIKitBackend {
    public typealias Path = UIBezierPath

    public func createPath() -> UIBezierPath {
        UIBezierPath()
    }

    func applyStrokeStyle(_ strokeStyle: StrokeStyle, to path: UIBezierPath) {
        path.lineWidth = CGFloat(strokeStyle.width)

        path.lineCapStyle =
            switch strokeStyle.cap {
                case .butt:
                    .butt
                case .round:
                    .round
                case .square:
                    .square
            }

        switch strokeStyle.join {
            case .miter(let limit):
                path.lineJoinStyle = .miter
                path.miterLimit = CGFloat(limit)
            case .round:
                path.lineJoinStyle = .round
            case .bevel:
                path.lineJoinStyle = .bevel
        }
    }

    public func updatePath(_ path: UIBezierPath, _ source: SwiftCrossUI.Path, pointsChanged: Bool) {
        path.usesEvenOddFillRule = (source.fillRule == .evenOdd)

        applyStrokeStyle(source.strokeStyle, to: path)

        if pointsChanged {
            path.removeAllPoints()

            for action in source.actions {
                switch action {
                    case .moveTo(let point):
                        path.move(to: CGPoint(x: point.x, y: point.y))
                    case .lineTo(let point):
                        path.addLine(to: CGPoint(x: point.x, y: point.y))
                    case .quadCurve(let control, let end):
                        path.addQuadCurve(
                            to: CGPoint(x: end.x, y: end.y),
                            controlPoint: CGPoint(x: control.x, y: control.y)
                        )
                    case .cubicCurve(let control1, let control2, let end):
                        path.addCurve(
                            to: CGPoint(x: end.x, y: end.y),
                            controlPoint1: CGPoint(x: control1.x, y: control1.y),
                            controlPoint2: CGPoint(x: control2.x, y: control2.y)
                        )
                    case .rectangle(let rect):
                        let cgPath: CGMutablePath = path.cgPath.mutableCopy()!
                        cgPath.addRect(
                            CGRect(x: rect.x, y: rect.y, width: rect.width, height: rect.height)
                        )
                        path.cgPath = cgPath
                    case .circle(let center, let radius):
                        let cgPath: CGMutablePath = path.cgPath.mutableCopy()!
                        cgPath.addEllipse(
                            in: CGRect(
                                x: center.x - radius,
                                y: center.y - radius,
                                width: radius * 2.0,
                                height: radius * 2.0
                            )
                        )
                        path.cgPath = cgPath
                    case .arc(let center, let radius, let startAngle, let endAngle, let clockwise):
                        path.addArc(
                            withCenter: CGPoint(x: center.x, y: center.y),
                            radius: CGFloat(radius),
                            startAngle: CGFloat(startAngle),
                            endAngle: CGFloat(endAngle),
                            clockwise: clockwise
                        )
                    case .transform(let transform):
                        path.apply(CGAffineTransform(transform))
                }
            }
        }
    }

    public func renderPath(
        _ path: Path,
        container: Widget,
        strokeColor: Color,
        fillColor: Color,
        overrideStrokeStyle: StrokeStyle?
    ) {
        if let overrideStrokeStyle {
            applyStrokeStyle(overrideStrokeStyle, to: path)
        }

        let shapeLayer = container.view.layer.sublayers?[0] as? CAShapeLayer ?? CAShapeLayer()

        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = path.lineWidth
        shapeLayer.miterLimit = path.miterLimit
        shapeLayer.fillRule = path.usesEvenOddFillRule ? .evenOdd : .nonZero

        shapeLayer.lineJoin =
            switch path.lineJoinStyle {
                case .miter:
                    .miter
                case .round:
                    .round
                case .bevel:
                    .bevel
            }

        shapeLayer.lineCap =
            switch path.lineCapStyle {
                case .butt:
                    .butt
                case .round:
                    .round
                case .square:
                    .square
            }

        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.fillColor = fillColor.cgColor

        if shapeLayer.superlayer !== container.view.layer {
            container.view.layer.addSublayer(shapeLayer)
        }
    }
}

extension CGAffineTransform {
    public init(_ transform: AffineTransform) {
        self.init(
            a: transform.linearTransform.x,
            b: transform.linearTransform.z,
            c: transform.linearTransform.y,
            d: transform.linearTransform.w,
            tx: transform.translation.x,
            ty: transform.translation.y
        )
    }
}

extension AffineTransform {
    public init(cg transform: CGAffineTransform) {
        self.init(
            linearTransform: SIMD4(x: transform.a, y: transform.c, z: transform.b, w: transform.d),
            translation: SIMD2(x: transform.tx, y: transform.ty)
        )
    }
}
