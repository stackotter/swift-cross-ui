import AppKit
import SwiftCrossUI

extension App {
    public typealias Backend = AppKitBackend
}

public struct AppKitBackend: AppBackend {
    public typealias Window = NSWindow
    public typealias Widget = NSView

    public init(appIdentifier: String) {}

    public func runMainLoop(_ callback: @escaping () -> Void) {
        callback()
        NSApplication.shared.activate(ignoringOtherApps: true)
        NSApplication.shared.run()
    }

    public func createWindow(withDefaultSize defaultSize: Size?) -> Window {
        let nsApp = NSApplication.shared
        nsApp.setActivationPolicy(.regular)

        return NSWindow(
            contentRect: NSRect(
                x: 0,
                y: 0,
                width: CGFloat(defaultSize?.width ?? 0),
                height: CGFloat(defaultSize?.height ?? 0)
            ),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: true
        )
    }

    public func setTitle(ofWindow window: Window, to title: String) {
        window.title = title
    }

    public func setResizability(ofWindow window: Window, to resizable: Bool) {
        if resizable {
            window.styleMask.insert(.resizable)
        } else {
            window.styleMask.remove(.resizable)
        }
    }

    public func setChild(ofWindow window: NSWindow, to child: NSView) {
        let container = NSStackView()
        container.addView(child, in: .bottom)
        child.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        child.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        window.contentView = container
    }

    public func show(window: NSWindow) {
        window.makeKeyAndOrderFront(nil)
    }

    public func runInMainThread(action: @escaping () -> Void) {
        DispatchQueue.main.async {
            action()
        }
    }

    public func show(widget: Widget) {}

    public func createTextView() -> Widget {
        return NSTextField(wrappingLabelWithString: "")
    }

    public func updateTextView(_ textView: Widget, content: String, shouldWrap: Bool) {
        // TODO: Implement text wrap handling
        (textView as! NSTextField).stringValue = content
    }

    public func createVStack() -> Widget {
        let view = NSStackView()
        view.orientation = .vertical
        return view
    }

    public func addChild(_ child: Widget, toVStack container: Widget) {
        let container = container as! NSStackView
        container.addView(child, in: .bottom)
    }

    public func setSpacing(ofVStack widget: Widget, to spacing: Int) {
        (widget as! NSStackView).spacing = CGFloat(spacing)
    }

    public func createHStack() -> Widget {
        let view = NSStackView()
        view.orientation = .horizontal
        return view
    }

    public func addChild(_ child: Widget, toHStack container: Widget) {
        (container as! NSStackView).addView(child, in: .bottom)
    }

    public func setSpacing(ofHStack widget: Widget, to spacing: Int) {
        (widget as! NSStackView).spacing = CGFloat(spacing)
    }

    public func createButton() -> Widget {
        return NSButton(title: "", target: nil, action: nil)
    }

    public func updateButton(_ button: Widget, label: String, action: @escaping () -> Void) {
        (button as! NSButton).title = label
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

    public func createSpacer() -> NSView {
        return NSView()
    }

    public func updateSpacer(
        _ spacer: NSView, expandHorizontally: Bool, expandVertically: Bool, minSize: Int
    ) {
        // TODO: Update spacer
    }

    public func createSwitch() -> NSView {
        return NSSwitch()
    }

    public func updateSwitch(_ toggleSwitch: NSView, onChange: @escaping (Bool) -> Void) {
        let toggleSwitch = toggleSwitch as! NSSwitch
        toggleSwitch.onAction = { toggleSwitch in
            let toggleSwitch = toggleSwitch as! NSSwitch
            onChange(toggleSwitch.state == .on)
        }
    }

    public func setState(ofSwitch toggleSwitch: NSView, to state: Bool) {
        let toggleSwitch = toggleSwitch as! NSSwitch
        toggleSwitch.state = state ? .on : .off
    }

    public func createToggle() -> NSView {
        let toggle = NSButton()
        toggle.setButtonType(.pushOnPushOff)
        return toggle
    }

    public func updateToggle(_ toggle: NSView, label: String, onChange: @escaping (Bool) -> Void) {
        let toggle = toggle as! NSButton
        toggle.title = label
        toggle.onAction = { toggle in
            let toggle = toggle as! NSButton
            onChange(toggle.state == .on)
        }
    }

    public func setState(ofToggle toggle: NSView, to state: Bool) {
        let toggle = toggle as! NSButton
        toggle.state = state ? .on : .off
    }

    public func getInheritedOrientation(of widget: NSView) -> InheritedOrientation? {
        guard let superview = widget.superview else {
            return nil
        }

        if let stack = superview as? NSStackView {
            switch stack.orientation {
                case .horizontal:
                    return .horizontal
                case .vertical:
                    return .vertical
                default:
                    break
            }
        }

        return getInheritedOrientation(of: superview)
    }

    public func createSingleChildContainer() -> NSView {
        let container = NSStackView()
        container.alignment = .centerY
        return container
    }

    public func setChild(ofSingleChildContainer container: NSView, to widget: NSView?) {
        let container = container as! NSStackView
        for child in container.arrangedSubviews {
            container.removeView(child)
        }
        if let widget = widget {
            container.addView(widget, in: .center)
        }
    }

    public func createSlider() -> NSView {
        return NSSlider()
    }

    public func updateSlider(
        _ slider: NSView,
        minimum: Double,
        maximum: Double,
        decimalPlaces: Int,
        onChange: @escaping (Double) -> Void
    ) {
        // TODO: Implement decimalPlaces
        let slider = slider as! NSSlider
        slider.minValue = minimum
        slider.maxValue = maximum
        slider.onAction = { slider in
            let slider = slider as! NSSlider
            onChange(slider.doubleValue)
        }
    }

    public func setValue(ofSlider slider: NSView, to value: Double) {
        let slider = slider as! NSSlider
        slider.doubleValue = value
    }

    public func createPicker() -> NSView {
        return NSPopUpButton()
    }

    public func updatePicker(
        _ picker: NSView, options: [String], onChange: @escaping (Int?) -> Void
    ) {
        let picker = picker as! NSPopUpButton
        picker.addItems(withTitles: options)
        picker.onAction = { picker in
            let picker = picker as! NSPopUpButton
            onChange(picker.indexOfSelectedItem)
        }
    }

    public func setSelectedOption(ofPicker picker: NSView, to selectedOption: Int?) {
        let picker = picker as! NSPopUpButton
        if let index = selectedOption {
            picker.selectItem(at: index)
        } else {
            picker.select(nil)
        }
    }

    public func createStyleContainer(for child: NSView) -> NSView {
        return child
    }

    public func setForegroundColor(ofStyleContainer container: NSView, to color: Color) {
        // TODO: Implement foreground color
    }

    public func createTextField() -> NSView {
        return NSObservableTextField()
    }

    public func updateTextField(
        _ textField: NSView, placeholder: String, onChange: @escaping (String) -> Void
    ) {
        let textField = textField as! NSObservableTextField
        textField.placeholderString = placeholder
        textField.onEdit = { textField in
            onChange(textField.stringValue)
        }
    }

    public func getContent(ofTextField textField: NSView) -> String {
        let textField = textField as! NSTextField
        return textField.stringValue
    }

    public func setContent(ofTextField textField: NSView, to content: String) {
        let textField = textField as! NSTextField
        textField.stringValue = content
    }

    public func createScrollContainer(for child: NSView) -> NSView {
        let scrollView = NSScrollView()
        scrollView.addSubview(child)
        return scrollView
    }

    public func createLayoutTransparentStack() -> NSView {
        return NSStackView()
    }

    public func updateLayoutTransparentStack(_ container: NSView) {
        let stack = container as! NSStackView
        // Inherit orientation of nearest oriented parent (defaulting to vertical)
        stack.orientation =
            getInheritedOrientation(of: stack) == .horizontal ? .horizontal : .vertical
    }

    public func addChild(_ child: NSView, toLayoutTransparentStack container: NSView) {
        let stack = container as! NSStackView
        stack.addView(child, in: .bottom)
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

class NSObservableTextField: NSTextField {
    override func textDidChange(_ notification: Notification) {
        onEdit?(self)
    }

    var onEdit: ((NSTextField) -> Void)?
}

// Source: https://gist.github.com/sindresorhus/3580ce9426fff8fafb1677341fca4815
extension NSControl {
    typealias ActionClosure = ((NSControl) -> Void)
    typealias EditClosure = ((NSTextField) -> Void)

    struct AssociatedKeys {
        static let onActionClosure = ObjectAssociation<ActionClosure>()
        static let onEditClosure = ObjectAssociation<EditClosure>()
    }

    @objc
    func callClosure(_ sender: NSControl) {
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
