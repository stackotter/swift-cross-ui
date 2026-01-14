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
        let colors: [Color.Representation.Adaptive: (light: NSColor, dark: NSColor)] = [
            .black: (light: .black, dark: .black),
            .blue: (
                light: NSColor(red: 0/255, green: 136/255, blue: 255/255, alpha: 1),
                dark: NSColor(red: 0/255, green: 145/255, blue: 255/255, alpha: 1)
            ),
            .brown: (
                light: NSColor(red: 172/255, green: 127/255, blue: 94/255, alpha: 1),
                dark: NSColor(red: 183/255, green: 138/255, blue: 102/255, alpha: 1)
            ),
            .cyan: (
                light: NSColor(red: 0/255, green: 192/255, blue: 232/255, alpha: 1),
                dark: NSColor(red: 60/255, green: 211/255, blue: 254/255, alpha: 1)
            ),
            .gray: (
                light: NSColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1),
                dark: NSColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
            ),
            .green: (
                light: NSColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1),
                dark: NSColor(red: 48/255, green: 209/255, blue: 88/255, alpha: 1)
            ),
            .indigo: (
                light: NSColor(red: 97/255, green: 85/255, blue: 245/255, alpha: 1),
                dark: NSColor(red: 109/255, green: 124/255, blue: 255/255, alpha: 1)
            ),
            .mint: (
                light: NSColor(red: 0/255, green: 200/255, blue: 179/255, alpha: 1),
                dark: NSColor(red: 0/255, green: 218/255, blue: 195/255, alpha: 1)
            ),
            .orange: (
                light: NSColor(red: 255/255, green: 141/255, blue: 40/255, alpha: 1),
                dark: NSColor(red: 255/255, green: 146/255, blue: 48/255, alpha: 1)
            ),
            .pink: (
                light: NSColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1),
                dark: NSColor(red: 255/255, green: 55/255, blue: 95/255, alpha: 1)
            ),
            .purple: (
                light: NSColor(red: 203/255, green: 48/255, blue: 224/255, alpha: 1),
                dark: NSColor(red: 219/255, green: 52/255, blue: 242/255, alpha: 1)
            ),
            .red: (
                light: NSColor(red: 255/255, green: 56/255, blue: 60/255, alpha: 1),
                dark: NSColor(red: 255/255, green: 66/255, blue: 69/255, alpha: 1)
            ),
            .teal: (
                light: NSColor(red: 0/255, green: 195/255, blue: 208/255, alpha: 1),
                dark: NSColor(red: 0/255, green: 210/255, blue: 224/255, alpha: 1)
            ),
            .yellow: (
                light: NSColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1),
                dark: NSColor(red: 255/255, green: 214/255, blue: 0/255, alpha: 1)
            ),
            .white: (light: .white, dark: .white),
        ]

        let nsColor = switch environment.colorScheme {
            case .light: colors[color]!.light
            case .dark: colors[color]!.dark
        }
        return Color.Resolved(nsColor)
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
