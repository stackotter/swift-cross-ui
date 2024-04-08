import AppKit
import SwiftCrossUI

extension App {
    public typealias Backend = AppKitBackend
}

public struct AppKitBackend: AppBackend {
    public typealias Window = NSWindow

    public enum Widget {
        case view(NSView)
        case viewController(NSViewController)

        public var view: NSView {
            switch self {
                case .view(let view):
                    return view
                case .viewController(let controller):
                    return controller.view
            }
        }

        public var viewController: NSViewController? {
            switch self {
                case .viewController(let controller):
                    return controller
                case .view:
                    return nil
            }
        }
    }

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

    public func setChild(ofWindow window: NSWindow, to child: Widget) {
        let container = NSStackView()
        container.orientation = .vertical
        container.alignment = .centerX
        container.addView(child.view, in: .center)
        child.view.pinEdges(to: container)
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
        return .view(NSTextField(wrappingLabelWithString: ""))
    }

    public func updateTextView(_ textView: Widget, content: String, shouldWrap: Bool) {
        // TODO: Implement text wrap handling
        (textView.view as! NSTextField).stringValue = content
    }

    public func createVStack() -> Widget {
        let view = NSStackView()
        view.orientation = .vertical
        view.alignment = .centerX
        return .view(view)
    }

    public func setChildren(_ children: [Widget], ofVStack container: Widget) {
        let stack = container.view as! NSStackView
        for child in children {
            stack.addView(child.view, in: .center)
        }
        if let first = children.first, children.count == 1 {
            first.view.pinEdges(to: container.view)
        }
    }

    public func setSpacing(ofVStack widget: Widget, to spacing: Int) {
        (widget.view as! NSStackView).spacing = CGFloat(spacing)
    }

    public func createHStack() -> Widget {
        let view = NSStackView()
        view.orientation = .horizontal
        view.alignment = .centerY
        return .view(view)
    }

    public func setChildren(_ children: [Widget], ofHStack container: Widget) {
        let stack = container.view as! NSStackView
        for child in children {
            stack.addView(child.view, in: .center)
        }
        if let first = children.first, children.count == 1 {
            first.view.pinEdges(to: container.view)
        }
    }

    public func setSpacing(ofHStack widget: Widget, to spacing: Int) {
        (widget.view as! NSStackView).spacing = CGFloat(spacing)
    }

    public func createButton() -> Widget {
        return .view(NSButton(title: "", target: nil, action: nil))
    }

    public func updateButton(_ button: Widget, label: String, action: @escaping () -> Void) {
        let button = button.view as! NSButton
        button.title = label
        button.onAction = { _ in
            action()
        }
    }

    public func createPaddingContainer(for child: Widget) -> Widget {
        let paddingContainer = NSStackView(views: [child.view])
        // child.view.pinEdges(to: paddingContainer)
        return .view(paddingContainer)
    }

    public func getChild(ofPaddingContainer container: Widget) -> Widget {
        return .view((container.view as! NSStackView).views[0])
    }

    public func setPadding(
        ofPaddingContainer container: Widget,
        top: Int,
        bottom: Int,
        leading: Int,
        trailing: Int
    ) {
        let view = container.view as! NSStackView
        view.edgeInsets.top = CGFloat(top)
        view.edgeInsets.bottom = CGFloat(bottom)
        view.edgeInsets.left = CGFloat(leading)
        view.edgeInsets.right = CGFloat(trailing)
    }

    public func createSpacer() -> Widget {
        return .view(NSView())
    }

    public func updateSpacer(
        _ spacer: Widget, expandHorizontally: Bool, expandVertically: Bool, minSize: Int
    ) {
        // TODO: Update spacer
    }

    public func createSwitch() -> Widget {
        return .view(NSSwitch())
    }

    public func updateSwitch(_ toggleSwitch: Widget, onChange: @escaping (Bool) -> Void) {
        let toggleSwitch = toggleSwitch.view as! NSSwitch
        toggleSwitch.onAction = { toggleSwitch in
            let toggleSwitch = toggleSwitch as! NSSwitch
            onChange(toggleSwitch.state == .on)
        }
    }

    public func setState(ofSwitch toggleSwitch: Widget, to state: Bool) {
        let toggleSwitch = toggleSwitch.view as! NSSwitch
        toggleSwitch.state = state ? .on : .off
    }

    public func createToggle() -> Widget {
        let toggle = NSButton()
        toggle.setButtonType(.pushOnPushOff)
        return .view(toggle)
    }

    public func updateToggle(_ toggle: Widget, label: String, onChange: @escaping (Bool) -> Void) {
        let toggle = toggle.view as! NSButton
        toggle.title = label
        toggle.onAction = { toggle in
            let toggle = toggle as! NSButton
            onChange(toggle.state == .on)
        }
    }

    public func setState(ofToggle toggle: Widget, to state: Bool) {
        let toggle = toggle.view as! NSButton
        toggle.state = state ? .on : .off
    }

    public func getInheritedOrientation(of widget: Widget) -> InheritedOrientation? {
        guard let superview = widget.view.superview else {
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

        return getInheritedOrientation(of: .view(superview))
    }

    public func createSingleChildContainer() -> Widget {
        let container = NSStackView()
        container.orientation = .vertical
        container.alignment = .centerX
        return .view(container)
    }

    public func setChild(ofSingleChildContainer container: Widget, to widget: Widget?) {
        let container = container.view as! NSStackView
        for child in container.arrangedSubviews {
            container.removeView(child)
        }
        if let widget = widget {
            container.addView(widget.view, in: .center)
            widget.view.pinEdges(to: container)
        }
    }

    public func createSlider() -> Widget {
        return .view(NSSlider())
    }

    public func updateSlider(
        _ slider: Widget,
        minimum: Double,
        maximum: Double,
        decimalPlaces: Int,
        onChange: @escaping (Double) -> Void
    ) {
        // TODO: Implement decimalPlaces
        let slider = slider.view as! NSSlider
        slider.minValue = minimum
        slider.maxValue = maximum
        slider.onAction = { slider in
            let slider = slider as! NSSlider
            onChange(slider.doubleValue)
        }
    }

    public func setValue(ofSlider slider: Widget, to value: Double) {
        let slider = slider.view as! NSSlider
        slider.doubleValue = value
    }

    public func createPicker() -> Widget {
        return .view(NSPopUpButton())
    }

    public func updatePicker(
        _ picker: Widget, options: [String], onChange: @escaping (Int?) -> Void
    ) {
        let picker = picker.view as! NSPopUpButton
        picker.addItems(withTitles: options)
        picker.onAction = { picker in
            let picker = picker as! NSPopUpButton
            onChange(picker.indexOfSelectedItem)
        }
    }

    public func setSelectedOption(ofPicker picker: Widget, to selectedOption: Int?) {
        let picker = picker.view as! NSPopUpButton
        if let index = selectedOption {
            picker.selectItem(at: index)
        } else {
            picker.select(nil)
        }
    }

    public func createStyleContainer(for child: Widget) -> Widget {
        return child
    }

    public func setForegroundColor(ofStyleContainer container: Widget, to color: Color) {
        // TODO: Implement foreground color
    }

    public func createTextField() -> Widget {
        return .view(NSObservableTextField())
    }

    public func updateTextField(
        _ textField: Widget, placeholder: String, onChange: @escaping (String) -> Void
    ) {
        let textField = textField.view as! NSObservableTextField
        textField.placeholderString = placeholder
        textField.onEdit = { textField in
            onChange(textField.stringValue)
        }
    }

    public func getContent(ofTextField textField: Widget) -> String {
        let textField = textField.view as! NSTextField
        return textField.stringValue
    }

    public func setContent(ofTextField textField: Widget, to content: String) {
        let textField = textField.view as! NSTextField
        textField.stringValue = content
    }

    public func createScrollContainer(for child: Widget) -> Widget {
        let scrollView = NSScrollView()
        scrollView.addSubview(child.view)
        child.view.pinEdges(to: scrollView)
        return .view(scrollView)
    }

    public func createLayoutTransparentStack() -> Widget {
        return .view(NSStackView())
    }

    public func updateLayoutTransparentStack(_ container: Widget) {
        let stack = container.view as! NSStackView
        // Inherit orientation of nearest oriented parent (defaulting to vertical)
        stack.orientation =
            getInheritedOrientation(of: .view(stack)) == .horizontal ? .horizontal : .vertical
    }

    public func addChild(_ child: Widget, toLayoutTransparentStack container: Widget) {
        let stack = container.view as! NSStackView
        stack.addView(child.view, in: .bottom)
    }

    public func createSplitView(leadingChild: Widget, trailingChild: Widget) -> Widget {
        let splitViewController = NSSplitViewController()

        let leadingViewController = NSViewController()
        leadingViewController.view = leadingChild.view
        let trailingViewController = NSViewController()
        trailingViewController.view = trailingChild.view

        splitViewController.addSplitViewItem(
            NSSplitViewItem(sidebarWithViewController: leadingViewController)
        )
        splitViewController.addSplitViewItem(
            NSSplitViewItem(viewController: trailingViewController)
        )

        return .viewController(splitViewController)
    }

    public func updateSplitView(_ splitView: Widget) {
        guard let parent = splitView.view.superview else {
            return
        }
        print("yep")

        let splitView = splitView.view
        splitView.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        splitView.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        splitView.leftAnchor.constraint(equalTo: parent.leftAnchor).isActive = true
        splitView.rightAnchor.constraint(equalTo: parent.rightAnchor).isActive = true
    }

    public func createFrameContainer(for child: Widget) -> Widget {
        return child
    }

    public func updateFrameContainer(_ container: Widget, minWidth: Int, minHeight: Int) {
        container.view.widthAnchor
            .constraint(greaterThanOrEqualToConstant: CGFloat(minWidth))
            .isActive = true
        container.view.heightAnchor
            .constraint(greaterThanOrEqualToConstant: CGFloat(minHeight))
            .isActive = true
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

extension NSView {
    func pinEdges(to parent: NSView) {
        topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        leftAnchor.constraint(equalTo: parent.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: parent.rightAnchor).isActive = true
    }
}
