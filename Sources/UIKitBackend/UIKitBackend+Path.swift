import SwiftCrossUI
import UIKit

extension UIKitBackend {
    public typealias Path = UIBezierPath

    public func createPath() -> UIBezierPath {
        UIBezierPath()
    }

    public func updatePath(_ path: UIBezierPath, _ source: SwiftCrossUI.Path, pointsChanged: Bool) {
        path.usesEvenOddFillRule = (source.fillRule == .evenOdd)
        path.lineWidth = CGFloat(source.strokeStyle.width)

        path.lineCapStyle =
            switch source.strokeStyle.cap {
                case .butt:
                    .butt
                case .round:
                    .round
                case .square:
                    .square
            }

        switch source.strokeStyle.join {
            case .miter(let limit):
                path.lineJoinStyle = .miter
                path.miterLimit = CGFloat(limit)
            case .round:
                path.lineJoinStyle = .round
            case .bevel:
                path.lineJoinStyle = .bevel
        }

        if pointsChanged {
            path.removeAllPoints()

            for action in source.actions {
                switch action {
                    case .moveTo(let point):
                        path.move(to: CGPoint(x: Double(point.x), y: Double(point.y)))
                    case .lineTo(let point):
                        path.addLine(to: CGPoint(x: Double(point.x), y: Double(point.y)))
                    case .quadCurve(let control, let end):
                        path.addQuadCurve(
                            to: CGPoint(x: Double(end.x), y: Double(end.y)),
                            controlPoint: CGPoint(x: Double(control.x), y: Double(control.y)))
                    case .cubicCurve(let control1, let control2, let end):
                        path.addCurve(
                            to: CGPoint(x: Double(end.x), y: Double(end.y)),
                            controlPoint1: CGPoint(x: Double(control1.x), y: Double(control1.y)),
                            controlPoint2: CGPoint(x: Double(control2.x), y: Double(control2.y)))
                    case .rectangle(let rect):
                        let cgPath: CGMutablePath = path.cgPath.mutableCopy()!
                        cgPath.addRect(
                            CGRect(
                                x: CGFloat(rect.x),
                                y: CGFloat(rect.y),
                                width: CGFloat(rect.width),
                                height: CGFloat(rect.height)
                            )
                        )
                        path.cgPath = cgPath
                    case .circle(let center, let radius):
                        let cgPath: CGMutablePath = path.cgPath.mutableCopy()!
                        cgPath.addEllipse(
                            in: CGRect(
                                x: CGFloat(center.x - radius),
                                y: CGFloat(center.y - radius),
                                width: CGFloat(radius * 2.0),
                                height: CGFloat(radius * 2.0)
                            )
                        )
                        path.cgPath = cgPath
                    case .arc(let center, let radius, let startAngle, let endAngle, let clockwise):
                        path.addArc(
                            withCenter: CGPoint(x: Double(center.x), y: Double(center.y)),
                            radius: CGFloat(radius),
                            startAngle: CGFloat(startAngle),
                            endAngle: CGFloat(endAngle),
                            clockwise: clockwise
                        )
                    case .transform(let transform):
                        let cgAT = CGAffineTransform(
                            a: Double(transform.linearTransform.x),
                            b: Double(transform.linearTransform.y),
                            c: Double(transform.linearTransform.z),
                            d: Double(transform.linearTransform.w),
                            tx: Double(transform.translation.x),
                            ty: Double(transform.translation.y)
                        )
                        path.apply(cgAT)
                }
            }
        }
    }

    public func renderPath(_ path: UIBezierPath, container: Widget, environment: EnvironmentValues)
    {
        let maskLayer = container.view.layer.mask as? CAShapeLayer ?? CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.fillRule = path.usesEvenOddFillRule ? .evenOdd : .nonZero
        container.view.layer.mask = maskLayer
        container.view.backgroundColor = .red  // TODO
    }
}
