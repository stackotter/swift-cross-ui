public struct Capsule: Shape {
    public init() {}

    public func path(in bounds: Path.Rect) -> Path {
        if bounds.width > bounds.height {
            let radius = bounds.height / 2.0

            return Path()
                .move(to: SIMD2(x: bounds.width + bounds.x - radius, y: bounds.y))
                .addArc(
                    center: SIMD2(x: bounds.width + bounds.x - radius, y: bounds.center.y),
                    radius: radius,
                    startAngle: .pi * 1.5,
                    endAngle: .pi * 0.5,
                    clockwise: true
                )
                .addLine(to: SIMD2(x: radius + bounds.x, y: bounds.height + bounds.y))
                .addArc(
                    center: SIMD2(x: radius + bounds.x, y: bounds.center.y),
                    radius: radius,
                    startAngle: .pi * 0.5,
                    endAngle: .pi * 1.5,
                    clockwise: true
                )
                .addLine(to: SIMD2(x: bounds.width + bounds.x - radius, y: bounds.y))
        } else if bounds.width < bounds.height {
            let radius = bounds.width / 2.0

            return Path()
                .move(to: SIMD2(x: bounds.x, y: bounds.height + bounds.y - radius))
                .addArc(
                    center: SIMD2(x: bounds.center.x, y: bounds.height + bounds.y - radius),
                    radius: radius,
                    startAngle: .pi,
                    endAngle: 0.0,
                    clockwise: false
                )
                .addLine(to: SIMD2(x: bounds.width + bounds.x, y: radius + bounds.y))
                .addArc(
                    center: SIMD2(x: bounds.center.x, y: radius + bounds.y),
                    radius: radius,
                    startAngle: 0.0,
                    endAngle: .pi,
                    clockwise: false
                )
                .addLine(to: SIMD2(x: bounds.x, y: bounds.height + bounds.y - radius))
        } else {
            return Circle().path(in: bounds)
        }
    }
}
