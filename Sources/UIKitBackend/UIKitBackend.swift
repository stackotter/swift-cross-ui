//
//  UIKitBackend.swift
//  swift-cross-ui
//
//  Created by William Baker on 1/9/25.
//

import SwiftCrossUI
import UIKit

private var onBecomeActive: (() -> Void)!
private var onLaunchFromUrl: ((URL) -> Void)?

public final class UIKitBackend: AppBackend {
    public typealias Widget = UIView
    public typealias Alert = UIAlertController
    
    public let scrollBarWidth = 0
    public let defaultPaddingAmount = 15
    public let defaultTableRowContentHeight = 0
    public let defaultTableCellVerticalPadding = 0
    
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
            size: Int(UIFont.preferredFont(forTextStyle: .body).pointSize.rounded(.toNearestOrAwayFromZero)),
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
        
        if #available(iOS 13, tvOS 13, *) {
            let foregroundCIColor = CIColor(color: .label)
            
            environment.foregroundColor = Color(
                Float(foregroundCIColor.red),
                Float(foregroundCIColor.green),
                Float(foregroundCIColor.blue),
                Float(foregroundCIColor.alpha)
            )
        }
        
        return environment
    }
    
    public func setRootEnvironmentChangeHandler(to action: @escaping () -> Void) {
        onTraitCollectionChange = action
    }
    
    public func runInMainThread(action: @escaping () -> Void) {
        DispatchQueue.main.async(execute: action)
    }
    
    public func show(widget: UIView) {
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
    open func applicationDidBecomeActive(_: UIApplication) {
        onBecomeActive()
    }
    
    open func application(
        _: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?
    ) -> Bool {
        if let onLaunchFromUrl,
           let url = launchOptions?[.url] as? URL {
            onLaunchFromUrl(url)
        }
        
        return true
    }
}
