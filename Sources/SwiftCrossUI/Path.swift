import Foundation  // for sinf and cosf

public enum StrokeCap {
    /// The stroke ends square exactly at the last point.
    case butt
    /// The stroke ends with a semicircle.
    case round
    /// The stroke ends square half of the stroke width past the last point.
    case square
}

public enum StrokeJoin {
    /// Corners are sharp, unless they are longer than `limit` times half the stroke width,
    /// in which case they are beveled.
    case miter(limit: Float)
    /// Corners are rounded.
    case round
    /// Corners are beveled.
    case bevel
}

public struct StrokeStyle {
    public var width: Float = 1.0
    public var cap: StrokeCap = .butt
    public var join: StrokeJoin = .miter(limit: 10.0)

    public static let none = StrokeStyle(width: 0.0)
}

/// An enum describing how a path is shaded.
public enum FillRule {
    /// A region is shaded if it is enclosed an odd number of times.
    case evenOdd
    /// A region is shaded if it is enclosed at all.
    ///
    /// This is also known as the "non-zero" rule.
    case winding
}

/// A type representing an affine transformation on a 2-D point.
///
/// Performing an affine transform consists of translating by ``translation`` followed by
/// multiplying by ``linearTransform``.
public struct AffineTransform: Equatable {
    /// The linear transformation. This is a 2x2 matrix stored in row-major order.
    ///
    /// The four properties (`x`, `y`, `z`, `w`) correspond to the 2x2 matrix as follows:
    /// ```
    /// [ x  y ]
    /// [ z  w ]
    /// ```
    public var linearTransform: SIMD4<Float>
    /// The translation applied after the linear transformation.
    public var translation: SIMD2<Float>

    public init(linearTransform: SIMD4<Float>, translation: SIMD2<Float>) {
        self.linearTransform = linearTransform
        self.translation = translation
    }

    public static func translate(x: Float, y: Float) -> AffineTransform {
        AffineTransform(
            linearTransform: SIMD4(x: 1.0, y: 0.0, z: 0.0, w: 1.0),
            translation: SIMD2(x: x, y: y)
        )
    }

    public static func scale(by factor: Float) -> AffineTransform {
        AffineTransform(
            linearTransform: SIMD4(x: factor, y: 0.0, z: 0.0, w: factor),
            translation: .zero
        )
    }

    public static func rotate(
        radians: Float,
        center: SIMD2<Float> = .zero
    ) -> AffineTransform {
        let sine = sinf(radians)
        let cosine = cosf(radians)
        return AffineTransform(
            linearTransform: SIMD4(x: cosine, y: -sine, z: sine, w: cosine),
            translation: SIMD2(
                x: -center.x * cosine - center.y * sine + center.x,
                y: center.x * sine - center.y * cosine + center.y
            )
        )
    }

    public static func rotate(
        degrees: Float,
        center: SIMD2<Float> = .zero
    ) -> AffineTransform {
        rotate(radians: degrees * (.pi / 180.0), center: center)
    }

    public static let identity = AffineTransform(
        linearTransform: SIMD4(x: 1.0, y: 0.0, z: 0.0, w: 1.0),
        translation: .zero
    )
}

public struct Path {
    public struct Rect: Equatable {
        public var origin: SIMD2<Float>
        public var size: SIMD2<Float>

        public init(origin: SIMD2<Float>, size: SIMD2<Float>) {
            self.origin = origin
            self.size = size
        }

        public var x: Float { origin.x }
        public var y: Float { origin.y }
        public var width: Float { size.x }
        public var height: Float { size.y }

        public init(x: Float, y: Float, width: Float, height: Float) {
            origin = SIMD2(x: x, y: y)
            size = SIMD2(x: width, y: height)
        }
    }

    /// The types of actions that can be performed on a path.
    public enum Action: Equatable {
        case moveTo(SIMD2<Float>)
        case lineTo(SIMD2<Float>)
        case quadCurve(control: SIMD2<Float>, end: SIMD2<Float>)
        case cubicCurve(control1: SIMD2<Float>, control2: SIMD2<Float>, end: SIMD2<Float>)
        case rectangle(Rect)
        case circle(center: SIMD2<Float>, radius: Float)
        case arc(
            center: SIMD2<Float>,
            radius: Float,
            startAngle: Float,
            endAngle: Float,
            clockwise: Bool
        )
        case transform(AffineTransform)
        //        case subpath([Action], FillRule)
    }

    /// A list of every action that has been performed on this path.
    ///
    /// This property is meant for backends implementing paths. If the backend has a similar
    /// path type built-in (such as `UIBezierPath` or `GskPathBuilder`), constructing the
    /// path should consist of looping over this array and calling the method that corresponds
    /// to each action.
    public private(set) var actions: [Action] = []
    public private(set) var fillRule: FillRule = .evenOdd
    public private(set) var strokeStyle: StrokeStyle = .none

    public init() {}

    public consuming func move(to point: SIMD2<Float>) -> Path {
        actions.append(.moveTo(point))
        return self
    }

    public consuming func addLine(to point: SIMD2<Float>) -> Path {
        actions.append(.lineTo(point))
        return self
    }

    public consuming func addQuadCurve(
        control: SIMD2<Float>,
        to endPoint: SIMD2<Float>
    ) -> Path {
        actions.append(.quadCurve(control: control, end: endPoint))
        return self
    }

    public consuming func addCubicCurve(
        control1: SIMD2<Float>,
        control2: SIMD2<Float>,
        to endPoint: SIMD2<Float>
    ) -> Path {
        actions.append(.cubicCurve(control1: control1, control2: control2, end: endPoint))
        return self
    }

    public consuming func addRectangle(_ rect: Rect) -> Path {
        actions.append(.rectangle(rect))
        return self
    }

    public consuming func addCircle(center: SIMD2<Float>, radius: Float) -> Path {
        actions.append(.circle(center: center, radius: radius))
        return self
    }

    public consuming func addArc(
        center: SIMD2<Float>,
        radius: Float,
        startAngle: Float,
        endAngle: Float,
        clockwise: Bool
    ) -> Path {
        actions.append(
            .arc(
                center: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: clockwise
            )
        )
        return self
    }

    public consuming func transform(_ transform: AffineTransform) -> Path {
        actions.append(.transform(transform))
        return self
    }

    public consuming func stroke(style: StrokeStyle) -> Path {
        strokeStyle = style
        return self
    }

    public consuming func fillRule(_ rule: FillRule) -> Path {
        fillRule = rule
        return self
    }
}
