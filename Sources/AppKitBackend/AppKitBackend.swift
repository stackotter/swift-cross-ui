import AppKit
import SwiftCrossUI

public struct AppKitBackend: AppBackend {
    public typealias Window = NSWindow
    public typealias Widget = NSView

    public init(appIdentifier: String) {}

    public func createRootWindow(
        _ properties: WindowProperties,
        _ callback: @escaping (Window) -> Void
    ) {
        let nsApp = NSApplication.shared
        nsApp.setActivationPolicy(.regular)

        var styleMask: NSWindow.StyleMask = [.titled, .closable]
        if properties.resizable {
            styleMask.insert(.resizable)
        }

        let window = NSWindow(
            contentRect: NSRect(
                x: 0,
                y: 0,
                width: CGFloat(properties.defaultSize?.width ?? 0),
                height: CGFloat(properties.defaultSize?.height ?? 0)
            ),
            styleMask: styleMask,
            backing: .buffered,
            defer: true
        )
        window.title = properties.title

        callback(window)
    }

    public func setChild(ofWindow window: NSWindow, to child: NSView) {
        window.contentView = child
    }

    public func show(window: NSWindow) {
        window.makeKeyAndOrderFront(nil)
    }

    public func runMainLoop() {
        NSApplication.shared.activate(ignoringOtherApps: true)
        NSApplication.shared.run()
    }

    public func runInMainThread(action: @escaping () -> Void) {
        DispatchQueue.main.async {
            action()
        }
    }

    public func show(widget: Widget) {}

    public func createTextView(content: String, shouldWrap: Bool) -> Widget {
        if shouldWrap {
            return NSTextField(wrappingLabelWithString: content)
        } else {
            return NSTextField(labelWithString: content)
        }
    }

    public func setContent(ofTextView textView: Widget, to content: String) {
        (textView as! NSTextField).stringValue = content
    }

    public func setWrap(ofTextView textView: Widget, to shouldWrap: Bool) {}

    public func createVStack(spacing: Int) -> Widget {
        let view = NSStackView()
        view.orientation = .vertical
        view.spacing = CGFloat(spacing)
        return view
    }

    public func addChild(_ child: Widget, toVStack container: Widget) {
        let container = container as! NSStackView
        container.addView(child, in: .bottom)
    }

    public func setSpacing(ofVStack widget: Widget, to spacing: Int) {
        (widget as! NSStackView).spacing = CGFloat(spacing)
    }

    public func createHStack(spacing: Int) -> Widget {
        let view = NSStackView()
        view.orientation = .horizontal
        view.spacing = CGFloat(spacing)
        return view
    }

    public func addChild(_ child: Widget, toHStack container: Widget) {
        (container as! NSStackView).addView(child, in: .bottom)
    }

    public func setSpacing(ofHStack widget: Widget, to spacing: Int) {
        (widget as! NSStackView).spacing = CGFloat(spacing)
    }

    public func createButton(label: String, action: @escaping () -> Void) -> Widget {
        let button = NSButton(title: label, target: nil, action: nil)
        button.onAction = { _ in
            action()
        }
        return button
    }

    public func setLabel(ofButton button: Widget, to label: String) {
        (button as! NSButton).title = label
    }

    public func setAction(ofButton button: Widget, to action: @escaping () -> Void) {
        (button as! NSButton).onAction = { _ in
            action()
        }
    }

    public func createPaddingContainer(for child: Widget) -> Widget {
        return NSStackView(views: [child])
    }

    public func getChild(ofPaddingContainer container: Widget) -> Widget {
        return (container as! NSStackView).views[0]
    }

    public func setPadding(
        ofPaddingContainer container: Widget,
        top: Int,
        bottom: Int,
        leading: Int,
        trailing: Int
    ) {
        let view = container as! NSStackView
        view.edgeInsets.top = CGFloat(top)
        view.edgeInsets.bottom = CGFloat(bottom)
        view.edgeInsets.left = CGFloat(leading)
        view.edgeInsets.right = CGFloat(trailing)
    }
}

// Source: https://gist.github.com/sindresorhus/3580ce9426fff8fafb1677341fca4815
enum AssociationPolicy {
    case assign
    case retainNonatomic
    case copyNonatomic
    case retain
    case copy

    var rawValue: objc_AssociationPolicy {
        switch self {
            case .assign:
                return .OBJC_ASSOCIATION_ASSIGN
            case .retainNonatomic:
                return .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            case .copyNonatomic:
                return .OBJC_ASSOCIATION_COPY_NONATOMIC
            case .retain:
                return .OBJC_ASSOCIATION_RETAIN
            case .copy:
                return .OBJC_ASSOCIATION_COPY
        }
    }
}

// Source: https://gist.github.com/sindresorhus/3580ce9426fff8fafb1677341fca4815
final class ObjectAssociation<T: Any> {
    private let policy: AssociationPolicy

    init(policy: AssociationPolicy = .retainNonatomic) {
        self.policy = policy
    }

    subscript(index: AnyObject) -> T? {
        get {
            // Force-cast is fine here as we want it to fail loudly if we don't use the correct type.
            // swiftlint:disable:next force_cast
            objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T?
        }
        set {
            objc_setAssociatedObject(
                index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy.rawValue)
        }
    }
}

// Source: https://gist.github.com/sindresorhus/3580ce9426fff8fafb1677341fca4815
extension NSControl {
    typealias ActionClosure = ((NSControl) -> Void)

    private struct AssociatedKeys {
        static let onActionClosure = ObjectAssociation<ActionClosure>()
    }

    @objc
    private func callClosure(_ sender: NSControl) {
        onAction?(sender)
    }

    /**
    Closure version of `.action`.
    ```
    let button = NSButton(title: "Unicorn", target: nil, action: nil)
    button.onAction = { sender in
        print("Button action: \(sender)")
    }
    ```
    */
    var onAction: ActionClosure? {
        get {
            return AssociatedKeys.onActionClosure[self]
        }
        set {
            AssociatedKeys.onActionClosure[self] = newValue
            action = #selector(callClosure)
            target = self
        }
    }
}
