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
        UIView()
    }
    
    public func removeAllChildren(of container: Widget) {
        container.subviews.forEach { $0.removeFromSuperview() }
    }
    
    public func addChild(_ child: Widget, to container: Widget) {
        container.addSubview(child)
        child.translatesAutoresizingMaskIntoConstraints = false
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
        
        let child = container.subviews[index]
        
        UIKitBackend.createOrUpdateConstraint(
            in: child,
            from: child.leftAnchor,
            to: container.leftAnchor,
            constant: CGFloat(position.x)
        )
        UIKitBackend.createOrUpdateConstraint(
            in: child,
            from: child.topAnchor,
            to: container.topAnchor,
            constant: CGFloat(position.y)
        )
    }
    
    public func removeChild(_ child: Widget, from container: Widget) {
        assert(child.isDescendant(of: container))
        child.removeFromSuperview()
    }
    
    public func createColorableRectangle() -> Widget {
        UIView()
    }
    
    public func setColor(ofColorableRectangle widget: Widget, to color: Color) {
        let uiColor = UIColor(
            red: CGFloat(color.red),
            green: CGFloat(color.green),
            blue: CGFloat(color.blue),
            alpha: CGFloat(color.alpha)
        )
        widget.backgroundColor = uiColor
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
        widget.translatesAutoresizingMaskIntoConstraints = false
        UIKitBackend.createOrUpdateConstraint(
            in: widget,
            of: widget.widthAnchor,
            constant: CGFloat(size.x)
        )
        UIKitBackend.createOrUpdateConstraint(
            in: widget,
            of: widget.heightAnchor,
            constant: CGFloat(size.y)
        )
    }
    
    public func createScrollContainer(for child: Widget) -> Widget {
        let scrollView = UIScrollView()
        scrollView.addSubview(child)
        
        child.translatesAutoresizingMaskIntoConstraints = false
        UIKitBackend.createOrUpdateConstraint(
            in: child,
            from: child.leadingAnchor,
            to: scrollView.leadingAnchor,
            constant: 0.0
        )
        UIKitBackend.createOrUpdateConstraint(
            in: child,
            from: child.trailingAnchor,
            to: scrollView.trailingAnchor,
            constant: 0.0
        )
        UIKitBackend.createOrUpdateConstraint(
            in: child,
            from: child.topAnchor,
            to: scrollView.topAnchor,
            constant: 0.0
        )
        UIKitBackend.createOrUpdateConstraint(
            in: child,
            from: child.bottomAnchor,
            to: scrollView.bottomAnchor,
            constant: 0.0
        )
        
        return scrollView
    }
    
    internal static func createOrUpdateConstraint<Anchor: NSObject>(
        in view: UIView,
        from firstAnchor: NSLayoutAnchor<Anchor>,
        to secondAnchor: NSLayoutAnchor<Anchor>,
        constant: CGFloat
    ) {
        if let constraint = view.constraints.first(where: {
            $0.firstAnchor === firstAnchor && $0.secondAnchor === secondAnchor
        }) {
            constraint.constant = constant
        } else {
            firstAnchor.constraint(equalTo: secondAnchor, constant: constant).isActive = true
        }
    }
    
    internal static func createOrUpdateConstraint(
        in view: UIView,
        of anchor: NSLayoutDimension,
        constant: CGFloat
    ) {
        if let constraint = view.constraints.first(where: { $0.firstAnchor === anchor }) {
            constraint.constant = constant
        } else {
            anchor.constraint(equalToConstant: constant).isActive = true
        }
    }
}
