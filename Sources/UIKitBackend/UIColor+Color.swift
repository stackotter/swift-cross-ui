import SwiftCrossUI
import UIKit

extension UIColor {
    convenience init(color: Color) {
        switch color.representation {
            case .rgb(let red, let green, let blue):
                self.init(
                    red: CGFloat(red),
                    green: CGFloat(green),
                    blue: CGFloat(blue),
                    alpha: CGFloat(color.opacity)
                )
        }
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
        switch representation {
            case .rgb(let red, let green, let blue):
                CGColor(
                    red: CGFloat(red),
                    green: CGFloat(green),
                    blue: CGFloat(blue),
                    alpha: CGFloat(opacity)
                )
        }
    }
}
