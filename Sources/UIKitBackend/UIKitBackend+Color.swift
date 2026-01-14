import SwiftCrossUI
import UIKit

extension UIKitBackend {
    // NB: We deliberately use the default implementation of `resolveAdaptiveColor(_:in:)`,
    // since that uses the adaptive colors from AppKit/UIKit.
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
