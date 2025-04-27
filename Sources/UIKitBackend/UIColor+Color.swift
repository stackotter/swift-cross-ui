import SwiftCrossUI
import UIKit

extension UIColor {
    convenience init(color: Color) {
        self.init(
            red: CGFloat(color.red),
            green: CGFloat(color.green),
            blue: CGFloat(color.blue),
            alpha: CGFloat(color.alpha)
        )
    }
}

extension Color {
    init(_ uiColor: UIColor) {
        let ciColor = CIColor(color: uiColor)

        self.init(
            Float(ciColor.red),
            Float(ciColor.green),
            Float(ciColor.blue),
            Float(ciColor.alpha)
        )
    }

    var uiColor: UIColor {
        UIColor(color: self)
    }

    var cgColor: CGColor {
        CGColor(
            red: CGFloat(red),
            green: CGFloat(green),
            blue: CGFloat(blue),
            alpha: CGFloat(alpha)
        )
    }
}
