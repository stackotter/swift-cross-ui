//
//  UIKitBackend+Container.swift
//  swift-cross-ui
//
//  Created by William Baker on 1/9/25.
//

import SwiftCrossUI
import UIKit

extension UIKitBackend {
    public func createContainer() -> Widget {
        BaseWidget()
    }

    public func removeAllChildren(of container: Widget) {
        container.subviews.forEach { $0.removeFromSuperview() }
    }

    public func addChild(_ child: Widget, to container: Widget) {
        container.addSubview(child)
    }

    public func setPosition(
        ofChildAt index: Int,
        in container: Widget,
        to position: SIMD2<Int>
    ) {
        guard index < container.subviews.count else {
            assertionFailure("Attempting to set position of nonexistent subview")
            return
        }

        let child = container.subviews[index] as! BaseWidget
        child.x = position.x
        child.y = position.y
    }

    public func removeChild(_ child: Widget, from container: Widget) {
        assert(child.isDescendant(of: container))
        child.removeFromSuperview()
    }

    public func createColorableRectangle() -> Widget {
        BaseWidget()
    }

    public func setColor(ofColorableRectangle widget: Widget, to color: Color) {
        widget.backgroundColor = color.uiColor
    }

    public func setCornerRadius(of widget: Widget, to radius: Int) {
        widget.layer.cornerRadius = CGFloat(radius)
        widget.layer.masksToBounds = true
        widget.setNeedsLayout()
    }

    public func naturalSize(of widget: Widget) -> SIMD2<Int> {
        let size = widget.intrinsicContentSize
        return SIMD2(
            Int(size.width),
            Int(size.height)
        )
    }

    public func setSize(of widget: Widget, to size: SIMD2<Int>) {
        widget.width = size.x
        widget.height = size.y
    }

    // TODO: Scroll containers
}
