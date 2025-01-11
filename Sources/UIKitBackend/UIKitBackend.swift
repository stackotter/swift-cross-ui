//
//  UIKitBackend.swift
//  swift-cross-ui
//
//  Created by William Baker on 1/9/25.
//

import SwiftCrossUI
import UIKit

// Since the SceneDelegate and ApplicationDelegate are created by UIKit, SwiftCrossUI can't
// connect them to the UIKitBackend instance. Global variables is the only solution I can
// think of :(
private var onBecomeActive: (() -> Void)?
private var onLaunchFromUrl: ((URL) -> Void)?

internal var mainWindow: UIWindow?
internal var hasReturnedAWindow = false

public final class UIKitBackend: AppBackend {
    public typealias Widget = BaseWidget
    public typealias Alert = UIAlertController

    public let scrollBarWidth = 0
    public let defaultPaddingAmount = 15
    public let defaultTableRowContentHeight = -1
    public let defaultTableCellVerticalPadding = -1

    internal var onTraitCollectionChange: (() -> Void)?

    public func runMainLoop(
        _ callback: @escaping () -> Void
    ) {
        onBecomeActive = callback
        UIApplicationMain(
            CommandLine.argc,
            CommandLine.unsafeArgv,
            NSStringFromClass(UIApplication.self),
            NSStringFromClass(ApplicationDelegate.self)
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

internal class ApplicationDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? {
        get {
            mainWindow
        }
        set {
            mainWindow = newValue
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        onBecomeActive?()
        onBecomeActive = nil
    }

    func application(
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

/// The root class for scene delegates of SwiftCrossUI apps.
///
/// SwiftCrossUI apps do not have to be scene-based. If you are writing a scene-based app,
/// derive your scene delegate from this class.
open class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    public var window: UIWindow? {
        willSet {
            mainWindow = newValue
        }
    }

    /// Tells the delegate about the addition of a scene to the app.
    ///
    /// - Important: If you override this method in a subclass, you must call
    /// `super.scene(scene, willConnectTo: session, options: connectionOptions)`
    /// at some point in your implementation.
    open func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window

        onBecomeActive?()
        onBecomeActive = nil
    }
}
