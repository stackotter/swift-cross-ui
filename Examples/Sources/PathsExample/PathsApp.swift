import DefaultBackend
import Foundation  // for sin, cos
import SwiftCrossUI

struct ArcShape: StyledShape {
    var startAngle: Double
    var endAngle: Double
    var clockwise: Bool

    var strokeColor: Color? = Color.green
    let fillColor: Color? = nil
    let strokeStyle: StrokeStyle? = StrokeStyle(width: 5.0)

    func path(in bounds: Path.Rect) -> Path {
        let radius = min(bounds.width, bounds.height) / 2.0 - 2.5

        return Path()
            .move(to: bounds.center + radius * SIMD2(x: cos(startAngle), y: sin(startAngle)))
            .addArc(
                center: bounds.center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: clockwise
            )
    }

    func size(fitting proposal: SIMD2<Int>) -> ViewSize {
        let diameter = max(11, min(proposal.x, proposal.y))
        return ViewSize(
            size: SIMD2(x: diameter, y: diameter),
            idealSize: SIMD2(x: 100, y: 100),
            idealWidthForProposedHeight: proposal.y,
            idealHeightForProposedWidth: proposal.x,
            minimumWidth: 11,
            minimumHeight: 11,
            maximumWidth: nil,
            maximumHeight: nil
        )
    }
}

struct PathsApp: App {
    var body: some Scene {
        WindowGroup("PathsApp") {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.gray)

                    HStack {
                        VStack {
                            Text("Clockwise")

                            HStack {
                                ArcShape(
                                    startAngle: .pi * 2.0 / 3.0,
                                    endAngle: .pi * 1.5,
                                    clockwise: true
                                )

                                ArcShape(
                                    startAngle: .pi * 1.5,
                                    endAngle: .pi * 1.0 / 3.0,
                                    clockwise: true
                                )
                            }

                            HStack {
                                ArcShape(
                                    startAngle: .pi * 1.5,
                                    endAngle: .pi * 2.0 / 3.0,
                                    clockwise: true
                                )

                                ArcShape(
                                    startAngle: .pi * 1.0 / 3.0,
                                    endAngle: .pi * 1.5,
                                    clockwise: true
                                )
                            }
                        }

                        VStack {
                            Text("Counter-clockwise")

                            HStack {
                                ArcShape(
                                    startAngle: .pi * 1.5,
                                    endAngle: .pi * 2.0 / 3.0,
                                    clockwise: false
                                )

                                ArcShape(
                                    startAngle: .pi * 1.0 / 3.0,
                                    endAngle: .pi * 1.5,
                                    clockwise: false
                                )
                            }

                            HStack {
                                ArcShape(
                                    startAngle: .pi * 2.0 / 3.0,
                                    endAngle: .pi * 1.5,
                                    clockwise: false
                                )

                                ArcShape(
                                    startAngle: .pi * 1.5,
                                    endAngle: .pi * 1.0 / 3.0,
                                    clockwise: false
                                )
                            }
                        }
                    }.padding()
                }
                .padding()

                Ellipse()
                    .fill(.blue)
                    .padding()
            }
        }
    }
}

// Even though this file isn't called main.swift, `@main` isn't allowed and this is
PathsApp.main()
