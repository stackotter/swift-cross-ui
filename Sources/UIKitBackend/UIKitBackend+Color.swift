import SwiftCrossUI
import UIKit

extension UIKitBackend {
    public func resolveAdaptiveColor(
        _ adaptiveColor: Color.SystemAdaptive,
        in environment: EnvironmentValues
    ) -> Color.Resolved {
        let uiColor: UIColor =
            switch adaptiveColor {
                case .blue: .systemBlue
                case .brown: .systemBrown
                case .gray: .systemGray
                case .green: .systemGreen
                case .orange: .systemOrange
                case .purple: .systemPurple
                case .red: .systemRed
                case .yellow: .systemYellow
            }

        let traitCollection = UITraitCollection(
            userInterfaceStyle: environment.colorScheme.userInterfaceStyle
        )
        let resolvedColor = uiColor.resolvedColor(with: traitCollection)
        return Color.Resolved(resolvedColor)
    }
}

extension Color.Resolved {
    var uiColor: UIColor {
        UIColor(
            red: CGFloat(red),
            green: CGFloat(green),
            blue: CGFloat(blue),
            alpha: CGFloat(opacity)
        )
    }

    var cgColor: CGColor {
        CGColor(
            red: CGFloat(red),
            green: CGFloat(green),
            blue: CGFloat(blue),
            alpha: CGFloat(opacity)
        )
    }
}
