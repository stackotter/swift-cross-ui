import AppKit
import SwiftCrossUI

extension AppKitBackend {
    public func resolveAdaptiveColor(
        _ color: Color.Representation.Adaptive,
        in environment: EnvironmentValues
    ) -> Color.Resolved {
        // NB: From what I can tell, a lookup table is by far the simplest way
        // to go about this.
        // Source: https://developer.apple.com/design/human-interface-guidelines/color#System-colors
        switch environment.colorScheme {
            case .light: switch color {
                case .black: .init(red: 0.0, green: 0.0, blue: 0.0)
                case .blue: .init(red: 0.0, green: 0.533, blue: 1.0)
                case .brown: .init(red: 0.675, green: 0.498, blue: 0.369)
                case .gray: .init(red: 0.557, green: 0.557, blue: 0.576)
                case .green: .init(red: 0.204, green: 0.78, blue: 0.349)
                case .orange: .init(red: 1.0, green: 0.553, blue: 0.157)
                case .purple: .init(red: 0.796, green: 0.188, blue: 0.878)
                case .red: .init(red: 1.0, green: 0.219, blue: 0.235)
                case .yellow: .init(red: 1.0, green: 0.839, blue: 0.0)
                case .white: .init(red: 1.0, green: 1.0, blue: 1.0)
            }
            case .dark: switch color {
                case .black: .init(red: 0.0, green: 0.0, blue: 0.0)
                case .blue: .init(red: 0.0, green: 0.569, blue: 1.0)
                case .brown: .init(red: 0.718, green: 0.541, blue: 0.4)
                case .gray: .init(red: 0.557, green: 0.557, blue: 0.576)
                case .green: .init(red: 0.188, green: 0.819, blue: 0.345)
                case .orange: .init(red: 1.0, green: 0.573, blue: 0.188)
                case .purple: .init(red: 0.859, green: 0.204, blue: 0.949)
                case .red: .init(red: 1.0, green: 0.259, blue: 0.271)
                case .yellow: .init(red: 1.0, green: 0.8, blue: 0.0)
                case .white: .init(red: 1.0, green: 1.0, blue: 1.0)
            }
        }
    }
}

extension Color.Resolved {
    init(_ nsColor: NSColor) {
        guard let resolvedNSColor = nsColor.usingColorSpace(.deviceRGB) else {
            logger.error(
                "failed to convert NSColor to RGB",
                metadata: ["NSColor": "\(nsColor)"]
            )
            self = .init(red: 0, green: 0, blue: 0)
            return
        }
        self.init(
            red: Float(resolvedNSColor.redComponent),
            green: Float(resolvedNSColor.greenComponent),
            blue: Float(resolvedNSColor.blueComponent),
            opacity: Float(resolvedNSColor.alphaComponent)
        )
    }

    var nsColor: NSColor {
        NSColor(
            calibratedRed: CGFloat(red),
            green: CGFloat(green),
            blue: CGFloat(blue),
            alpha: CGFloat(opacity)
        )
    }
}
