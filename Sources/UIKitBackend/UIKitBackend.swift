//
//  UIKitBackend.swift
//  swift-cross-ui
//
//  Created by William Baker on 1/9/25.
//

import SwiftCrossUI
import UIKit

private var onBecomeActive: (() -> Void)?
private var onLaunchFromUrl: ((URL) -> Void)?

public final class UIKitBackend: AppBackend {
    public typealias Widget = BaseWidget
    public typealias Alert = UIAlertController

    public let scrollBarWidth = 0
    public let defaultPaddingAmount = 15
    public let defaultTableRowContentHeight = -1
    public let defaultTableCellVerticalPadding = -1

    public var appDelegateType: ApplicationDelegate.Type = ApplicationDelegate.self

    internal var onTraitCollectionChange: (() -> Void)?

    public func runMainLoop(
        _ callback: @escaping () -> Void
    ) {
        onBecomeActive = callback
        UIApplicationMain(
            CommandLine.argc,
            CommandLine.unsafeArgv,
            NSStringFromClass(UIApplication.self),
            NSStringFromClass(appDelegateType)
        )
    }

    public func setIncomingURLHandler(to action: @escaping (URL) -> Void) {
        onLaunchFromUrl = action
    }

    public func computeRootEnvironment(defaultEnvironment: EnvironmentValues) -> EnvironmentValues {
        var environment = defaultEnvironment

        environment.font = .system(
            size: Int(
                UIFont.preferredFont(forTextStyle: .body).pointSize.rounded(
                    .toNearestOrAwayFromZero)),
            weight: .regular,
            design: .default
        )

        switch UIScreen.main.traitCollection.userInterfaceStyle {
            case .light:
                environment.colorScheme = .light
            case .dark:
                environment.colorScheme = .dark
            default:
                break
        }

        environment.foregroundColor = Color(UIColor.label)

        return environment
    }

    public func setRootEnvironmentChangeHandler(to action: @escaping () -> Void) {
        onTraitCollectionChange = action
    }

    public func runInMainThread(action: @escaping () -> Void) {
        DispatchQueue.main.async(execute: action)
    }

    public func show(widget: Widget) {
    }

    public typealias Menu = Void
    public func setApplicationMenu(_ submenus: [ResolvedMenu.Submenu]) {
        // TODO
    }
}

extension App {
    public typealias Backend = UIKitBackend

    public var backend: UIKitBackend {
        UIKitBackend()
    }
}

open class ApplicationDelegate: UIResponder, UIApplicationDelegate {
    /// Tells the delegate that the app has become active.
    ///
    /// - Important: If you override this method in a subclass, you must call
    /// `super.applicationDidBecomeActive(application)` as the first step of your implementation.
    open func applicationDidBecomeActive(_ application: UIApplication) {
        onBecomeActive?()
        onBecomeActive = nil
    }

    /// Tells the delegate that the launch process is almost done and the app is almost
    /// ready to run.
    ///
    /// If you override this method in a subclass, you should call
    /// `super.application(application, didFinishLaunchingWithOptions: launchOptions)` at
    /// some point on your implementation. You do not necessarily need to return the same
    /// value as the super call.
    open func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if let onLaunchFromUrl,
            let url = launchOptions?[.url] as? URL
        {
            onLaunchFromUrl(url)
        }

        return true
    }
}
