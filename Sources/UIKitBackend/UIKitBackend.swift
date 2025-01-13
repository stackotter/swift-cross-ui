import SwiftCrossUI
import UIKit

public final class UIKitBackend: AppBackend {
    static var onBecomeActive: (() -> Void)?
    static var onReceiveURL: ((URL) -> Void)?
    static var queuedURLs: [URL] = []

    /// The first window to get created.
    static var mainWindow: UIWindow?
    static var hasReturnedAWindow = false

    public let scrollBarWidth = 0
    public let defaultPaddingAmount = 15
    public let requiresToggleSwitchSpacer = true
    public let defaultToggleStyle = ToggleStyle.switch

    // TODO: When tables are supported, update these
    public let defaultTableRowContentHeight = -1
    public let defaultTableCellVerticalPadding = -1

    var onTraitCollectionChange: (() -> Void)?
    public func runMainLoop(
        _ callback: @escaping () -> Void
    ) {
        Self.onReceiveURL = { url in
            Self.queuedURLs.append(url)
        }
        Self.onBecomeActive = callback
        UIApplicationMain(
            CommandLine.argc,
            CommandLine.unsafeArgv,
            NSStringFromClass(UIApplication.self),
            NSStringFromClass(ApplicationDelegate.self)
        )
    }

    public func setIncomingURLHandler(to action: @escaping (URL) -> Void) {
        // If the app wasn't already open, URLs can arrive before the view graph
        // gets a chance to register a handler. To fix this we store any early
        // URLs and replay them when the register gets added.
        runInMainThread {
            for url in Self.queuedURLs {
                action(url)
            }
            Self.queuedURLs = []
        }

        Self.onReceiveURL = action
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

    // TODO: Menus
    public typealias Menu = Never
    public func setApplicationMenu(_ submenus: [ResolvedMenu.Submenu]) {
    }
}

extension App {
    public typealias Backend = UIKitBackend

    public var backend: UIKitBackend {
        UIKitBackend()
    }
}

class ApplicationDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? {
        get {
            UIKitBackend.mainWindow
        }
        set {
            UIKitBackend.mainWindow = newValue
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIKitBackend.onBecomeActive?()

        // We only want to notify the first time. Otherwise the app's view
        // graph gets regenerated every time the app gets foregrounded,
        // causing very strange results.
        UIKitBackend.onBecomeActive = nil
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if let onReceiveURL = UIKitBackend.onReceiveURL,
            let url = launchOptions?[.url] as? URL
        {
            onReceiveURL(url)
        }

        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        if let onReceiveURL = UIKitBackend.onReceiveURL {
            onReceiveURL(url)
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
            UIKitBackend.mainWindow = newValue
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

        UIKitBackend.onBecomeActive?()

        // We only want to notify the first time. Otherwise the app's view
        // graph gets regenerated every time the app gets foregrounded,
        // causing very strange results.
        UIKitBackend.onBecomeActive = nil

        if let onReceiveURL = UIKitBackend.onReceiveURL,
            let url = connectionOptions.userActivities.first?.webpageURL
        {
            onReceiveURL(url)
        }
    }

    open func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let onReceiveURL = UIKitBackend.onReceiveURL,
            let url = userActivity.webpageURL
        {
            onReceiveURL(url)
        }
    }
}
