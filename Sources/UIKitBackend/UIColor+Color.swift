//
//  UIColor+Color.swift
//  swift-cross-ui
//
//  Created by William Baker on 1/10/25.
//

import SwiftCrossUI
import UIKit

extension UIColor {
    internal convenience init(color: Color) {
        self.init(
            red: CGFloat(color.red),
            green: CGFloat(color.green),
            blue: CGFloat(color.blue),
            alpha: CGFloat(color.alpha)
        )
    }

    internal var swiftCrossUIColor: Color {
        let ciColor = CIColor(color: self)

        return Color(
            Float(ciColor.red),
            Float(ciColor.green),
            Float(ciColor.blue),
            Float(ciColor.alpha)
        )
    }
}

extension Color {
    internal init(_ uiColor: UIColor) {
        self = uiColor.swiftCrossUIColor
    }

    internal var uiColor: UIColor {
        UIColor(color: self)
    }
}
