//
//  UIKitBackend+Window.swift
//  swift-cross-ui
//
//  Created by William Baker on 1/9/25.
//

import UIKit

internal final class RootViewController: UIViewController {
    unowned var backend: UIKitBackend
    var resizeHandler: ((CGSize) -> Void)?

    init(backend: UIKitBackend) {
        self.backend = backend
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }

    override func loadView() {
        super.loadView()
        if traitCollection.userInterfaceStyle != .dark {
            view.backgroundColor = .white
        }
    }

    override func viewWillTransition(
        to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        resizeHandler?(size)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        backend.onTraitCollectionChange?()
    }

    func setChild(to child: UIView) {
        view.subviews.forEach { $0.removeFromSuperview() }
        view.addSubview(child)

        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.topAnchor.constraint(equalTo: view.topAnchor),
            child.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            child.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            child.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension UIKitBackend {
    public typealias Window = UIWindow

    public func createWindow(withDefaultSize _: SIMD2<Int>?) -> Window {
        let window = UIWindow()
        window.rootViewController = RootViewController(backend: self)
        return window
    }

    public func setTitle(ofWindow window: Window, to title: String) {
        window.rootViewController!.title = title
    }

    public func setChild(ofWindow window: Window, to child: Widget) {
        let viewController = window.rootViewController as! RootViewController
        viewController.setChild(to: child)
    }

    public func size(ofWindow window: Window) -> SIMD2<Int> {
        var size = window.bounds.size
        return SIMD2(Int(size.width), Int(size.height))
    }

    public func setResizeHandler(
        ofWindow window: Window,
        to action: @escaping (_ newSize: SIMD2<Int>) -> Void
    ) {
        let viewController = window.rootViewController as! RootViewController
        viewController.resizeHandler = { size in
            action(SIMD2(Int(size.width), Int(size.height)))
        }
    }

    public func show(window: Window) {
        window.makeKeyAndVisible()
    }

    public func activate(window: Window) {
        window.makeKeyAndVisible()
    }

    // MARK: No-ops
    public func setResizability(ofWindow _: Window, to _: Bool) {}
    public func setSize(ofWindow _: Window, to _: SIMD2<Int>) {}
    public func setMinimumSize(ofWindow _: Window, to _: SIMD2<Int>) {}
}
