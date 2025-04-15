import Foundation  // for sin and cos

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
    case miter(limit: Double)
    /// Corners are rounded.
    case round
    /// Corners are beveled.
    case bevel
}

public struct StrokeStyle {
    public var width: Double
    public var cap: StrokeCap
    public var join: StrokeJoin

    public init(width: Double, cap: StrokeCap = .butt, join: StrokeJoin = .miter(limit: 10.0)) {
        self.width = width
        self.cap = cap
        self.join = join
    }
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
/// Performing an affine transform consists of multiplying the matrix ``linearTransform``
/// by the point as a column vector, then adding ``translation``.
public struct AffineTransform: Equatable, CustomDebugStringConvertible {
    /// The linear transformation. This is a 2x2 matrix stored in row-major order.
    ///
    /// The four properties (`x`, `y`, `z`, `w`) correspond to the 2x2 matrix as follows:
    /// ```
    /// [ x  y ]
    /// [ z  w ]
    /// ```
    /// - Remark: The matrices in some graphics frameworks, such as WinUI's `Matrix` and
    /// CoreGraphics' `CGAffineTransform`, take the transpose of this matrix. The reason for
    /// this difference is left- vs right-multiplication; the values are identical.
    public var linearTransform: SIMD4<Double>
    /// The translation applied after the linear transformation.
    public var translation: SIMD2<Double>

    public init(linearTransform: SIMD4<Double>, translation: SIMD2<Double>) {
        self.linearTransform = linearTransform
        self.translation = translation
    }

    public static func translation(x: Double, y: Double) -> AffineTransform {
        AffineTransform(
            linearTransform: SIMD4(x: 1.0, y: 0.0, z: 0.0, w: 1.0),
            translation: SIMD2(x: x, y: y)
        )
    }

    public static func scaling(by factor: Double) -> AffineTransform {
        AffineTransform(
            linearTransform: SIMD4(x: factor, y: 0.0, z: 0.0, w: factor),
            translation: .zero
        )
    }

    public static func rotation(radians: Double, center: SIMD2<Double>) -> AffineTransform {
        let sine = sin(radians)
        let cosine = cos(radians)
        return AffineTransform(
            linearTransform: SIMD4(x: cosine, y: -sine, z: sine, w: cosine),
            translation: SIMD2(
                x: -center.x * cosine + center.y * sine + center.x,
                y: -center.x * sine - center.y * cosine + center.y
            )
        )
    }

    public static func rotation(degrees: Double, center: SIMD2<Double>) -> AffineTransform {
        rotation(radians: degrees * (.pi / 180.0), center: center)
    }

    public static let identity = AffineTransform(
        linearTransform: SIMD4(x: 1.0, y: 0.0, z: 0.0, w: 1.0),
        translation: .zero
    )

    public func inverted() -> AffineTransform? {
        let determinant =
            linearTransform.x * linearTransform.w - linearTransform.y * linearTransform.z
        if determinant == 0.0 {
            return nil
        }

        return AffineTransform(
            linearTransform: SIMD4(
                x: linearTransform.w,
                y: -linearTransform.y,
                z: -linearTransform.z,
                w: linearTransform.x
            ) / determinant,
            translation: SIMD2(
                x: (linearTransform.y * translation.y - linearTransform.w * translation.x),
                y: (linearTransform.z * translation.x - linearTransform.x * translation.y)
            ) / determinant
        )
    }

    public func followedBy(_ other: AffineTransform) -> AffineTransform {
        // Composing two transformations is equivalent to forming the 3x3 matrix shown by
        // `debugDescription`, then multiplying `other * self` (the left matrix is applied
        // after the right matrix).
        return AffineTransform(
            linearTransform: SIMD4(
                x: other.linearTransform.x * linearTransform.x + other.linearTransform.y
                    * linearTransform.z,
                y: other.linearTransform.x * linearTransform.y + other.linearTransform.y
                    * linearTransform.w,
                z: other.linearTransform.z * linearTransform.x + other.linearTransform.w
                    * linearTransform.z,
                w: other.linearTransform.z * linearTransform.y + other.linearTransform.w
                    * linearTransform.w
            ),
            translation: SIMD2(
                x: other.linearTransform.x * translation.x + other.linearTransform.y * translation.y
                    + other.translation.x,
                y: other.linearTransform.z * translation.x + other.linearTransform.w * translation.y
                    + other.translation.y
            )
        )
    }

    public var debugDescription: String {
        let numberFormat = "%.5g"
        let a = String(format: numberFormat, linearTransform.x)
        let b = String(format: numberFormat, linearTransform.y)
        let c = String(format: numberFormat, linearTransform.z)
        let d = String(format: numberFormat, linearTransform.w)
        let tx = String(format: numberFormat, translation.x)
        let ty = String(format: numberFormat, translation.y)
        let zero = String(format: numberFormat, 0.0)
        let one = String(format: numberFormat, 1.0)

        let maxLength = [a, b, c, d, tx, ty, zero, one].map(\.count).max()!

        func pad(_ s: String) -> String {
            String(repeating: " ", count: maxLength - s.count) + s
        }

        return """
            [ \(pad(a)) \(pad(b)) \(pad(tx)) ]
            [ \(pad(c)) \(pad(d)) \(pad(ty)) ]
            [ \(pad(zero)) \(pad(zero)) \(pad(one)) ]
            """
    }
}

public struct Path {
    /// A rectangle in 2-D space.
    ///
    /// This type is inspired by `CGRect`.
    public struct Rect: Equatable {
        public var origin: SIMD2<Double>
        public var size: SIMD2<Double>

        public init(origin: SIMD2<Double>, size: SIMD2<Double>) {
            self.origin = origin
            self.size = size
        }

        public var x: Double { origin.x }
        public var y: Double { origin.y }
        public var width: Double { size.x }
        public var height: Double { size.y }

        public var center: SIMD2<Double> { size * 0.5 + origin }
        public var maxX: Double { size.x + origin.x }
        public var maxY: Double { size.y + origin.y }

        public init(x: Double, y: Double, width: Double, height: Double) {
            origin = SIMD2(x: x, y: y)
            size = SIMD2(x: width, y: height)
        }
    }

    /// The types of actions that can be performed on a path.
    public enum Action: Equatable {
        case moveTo(SIMD2<Double>)
        case lineTo(SIMD2<Double>)
        case quadCurve(control: SIMD2<Double>, end: SIMD2<Double>)
        case cubicCurve(control1: SIMD2<Double>, control2: SIMD2<Double>, end: SIMD2<Double>)
        case rectangle(Rect)
        case circle(center: SIMD2<Double>, radius: Double)
        case arc(
            center: SIMD2<Double>,
            radius: Double,
            startAngle: Double,
            endAngle: Double,
            clockwise: Bool
        )
        case transform(AffineTransform)
        case subpath([Action])
    }

    /// A list of every action that has been performed on this path.
    ///
    /// This property is meant for backends implementing paths. If the backend has a similar
    /// path type built-in (such as `UIBezierPath` or `GskPathBuilder`), constructing the
    /// path should consist of looping over this array and calling the method that corresponds
    /// to each action.
    public private(set) var actions: [Action] = []
    public private(set) var fillRule: FillRule = .evenOdd
    public private(set) var strokeStyle = StrokeStyle(width: 1.0)

    public init() {}

    public consuming func move(to point: SIMD2<Double>) -> Path {
        actions.append(.moveTo(point))
        return self
    }

    public consuming func addLine(to point: SIMD2<Double>) -> Path {
        actions.append(.lineTo(point))
        return self
    }

    public consuming func addQuadCurve(
        control: SIMD2<Double>,
        to endPoint: SIMD2<Double>
    ) -> Path {
        actions.append(.quadCurve(control: control, end: endPoint))
        return self
    }

    public consuming func addCubicCurve(
        control1: SIMD2<Double>,
        control2: SIMD2<Double>,
        to endPoint: SIMD2<Double>
    ) -> Path {
        actions.append(.cubicCurve(control1: control1, control2: control2, end: endPoint))
        return self
    }

    public consuming func addRectangle(_ rect: Rect) -> Path {
        actions.append(.rectangle(rect))
        return self
    }

    public consuming func addCircle(center: SIMD2<Double>, radius: Double) -> Path {
        actions.append(.circle(center: center, radius: radius))
        return self
    }

    /// Add an arc segment to the path.
    /// 
    /// The behavior is not defined if the starting point is not what is implied by `center`,
    /// `radius`, and `startAngle`. Some backends (such as UIKit) will add a line segment
    /// to connect the arc to the starting point, while others (such as WinUI) will move the
    /// arc in unintuitive ways. If this arc is the first segment of the current path, or
    /// the previous segment was a rectangle or circle, be sure to call ``move(to:)`` before
    /// this.
    /// - Parameters:
    ///   - center: The location of the center of the circle.
    ///   - radius: The radius of the circle.
    ///   - startAngle: The angle of the start of the arc, measured in radians clockwise from
    //      right. Must be between 0 and 2pi (inclusive).
    ///   - endAngle: The angle of the end of the arc, measured in radians clockwise from right.
    ///     Must be between 0 and 2pi (inclusive).
    ///   - clockwise: `true` if the arc is to be drawn clockwise, `false` if the arc is to
    ///     be drawn counter-clockwise. Used to determine whether to draw the larger arc or
    ///     the smaller arc identified by the given start and end angles.
    public consuming func addArc(
        center: SIMD2<Double>,
        radius: Double,
        startAngle: Double,
        endAngle: Double,
        clockwise: Bool
    ) -> Path {
        assert((0.0 ... (2.0 * .pi)).contains(startAngle) && (0.0 ... (2.0 * .pi)).contains(endAngle))
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

    public consuming func applyTransform(_ transform: AffineTransform) -> Path {
        actions.append(.transform(transform))
        return self
    }

    public consuming func addSubpath(_ subpath: Path) -> Path {
        actions.append(.subpath(subpath.actions))
        return self
    }

    /// Set the default stroke style for the path.
    ///
    /// This is not necessarily respected; it can be overridden by ``Shape/stroke(_:style:)``,
    /// and is lost when the path is passed to ``addSubpath(_:)``.
    public consuming func stroke(style: StrokeStyle) -> Path {
        strokeStyle = style
        return self
    }

    public consuming func fillRule(_ rule: FillRule) -> Path {
        fillRule = rule
        return self
    }
}

extension Path {
    @inlinable
    public consuming func `if`(
        _ condition: Bool,
        then ifTrue: (consuming Path) -> Path,
        else ifFalse: (consuming Path) -> Path = { $0 }
    ) -> Path {
        if condition {
            ifTrue(self)
        } else {
            ifFalse(self)
        }
    }
}
