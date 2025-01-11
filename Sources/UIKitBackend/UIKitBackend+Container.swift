//
//  UIKitBackend+Container.swift
//  swift-cross-ui
//
//  Created by William Baker on 1/9/25.
//

import SwiftCrossUI
import UIKit

internal final class ScrollWidget: WrapperWidget<UIScrollView> {
    private var childWidthConstraint: NSLayoutConstraint?
    private var childHeightConstraint: NSLayoutConstraint?

    private let innerChild: BaseWidget

    init(child innerChild: BaseWidget) {
        self.innerChild = innerChild
        super.init(child: UIScrollView())

        child.addSubview(innerChild)

        NSLayoutConstraint.activate([
            innerChild.topAnchor.constraint(equalTo: child.contentLayoutGuide.topAnchor),
            innerChild.bottomAnchor.constraint(equalTo: child.contentLayoutGuide.bottomAnchor),
            innerChild.leftAnchor.constraint(equalTo: child.contentLayoutGuide.leftAnchor),
            innerChild.rightAnchor.constraint(equalTo: child.contentLayoutGuide.rightAnchor),
        ])
    }

    func setScrollBars(
        hasVerticalScrollBar: Bool,
        hasHorizontalScrollBar: Bool
    ) {
        switch (hasVerticalScrollBar, childHeightConstraint?.isActive) {
            case (true, true):
                childHeightConstraint!.isActive = false
            case (false, nil):
                childHeightConstraint = innerChild.heightAnchor.constraint(
                    equalTo: child.heightAnchor)
                fallthrough
            case (false, false):
                childHeightConstraint!.isActive = true
            default:
                break
        }

        switch (hasHorizontalScrollBar, childWidthConstraint?.isActive) {
            case (true, true):
                childWidthConstraint!.isActive = false
            case (false, nil):
                childWidthConstraint = innerChild.widthAnchor.constraint(equalTo: child.widthAnchor)
                fallthrough
            case (false, false):
                childWidthConstraint!.isActive = true
            default:
                break
        }

        child.showsVerticalScrollIndicator = hasVerticalScrollBar
        child.showsHorizontalScrollIndicator = hasHorizontalScrollBar
    }
}

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

    public func createScrollContainer(for child: Widget) -> Widget {
        ScrollWidget(child: child)
    }

    public func setScrollBarPresence(
        ofScrollContainer scrollView: Widget,
        hasVerticalScrollBar: Bool,
        hasHorizontalScrollBar: Bool
    ) {
        let scrollWidget = scrollView as! ScrollWidget
        scrollWidget.setScrollBars(
            hasVerticalScrollBar: hasVerticalScrollBar,
            hasHorizontalScrollBar: hasHorizontalScrollBar)
    }
}
