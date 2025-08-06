import Foundation
import SwiftCrossUI
import TermKit

extension App {
    public typealias Backend = CursesBackend
}

public class TKMenu {
    
}

public class TKAlert {
    
}

public class TKPath {
    
}

public final class CursesBackend: AppBackend {
    public typealias Menu = TKMenu
    
    public typealias Alert = TKAlert
    
    public typealias Path = TKPath

    public var defaultTableRowContentHeight: Int = 1

    public var defaultTableCellVerticalPadding: Int = 0

    public var defaultPaddingAmount: Int = 1

    public var defaultStackSpacingAmount: Int = 0

    public var scrollBarWidth: Int = 2

    public var requiresToggleSwitchSpacer: Bool = false

    public var requiresImageUpdateOnScaleFactorChange: Bool = false

    public var menuImplementationStyle: SwiftCrossUI.MenuImplementationStyle = .dynamicPopover

    public var deviceClass: SwiftCrossUI.DeviceClass = .desktop

    public var canRevealFiles: Bool = false

    public func isWindowProgrammaticallyResizable(_ window: RootView) -> Bool {
        return true
    }
    
    public func setSize(ofWindow window: RootView, to newSize: SIMD2<Int>) {
        window.width = Dim.sized(min(newSize.x, Application.terminalSize.width))
        window.height = Dim.sized(min(newSize.y, Application.terminalSize.height))
    }
    
    public func setMinimumSize(ofWindow window: RootView, to minimumSize: SIMD2<Int>) {
        // TODO
    }
    
    public func activate(window: RootView) {
        fatalError()
    }

    public func runInMainThread(action: @escaping @MainActor () -> Void) {
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
    DispatchQueue.main.async {
        action()
    }
#else
    action()
#endif
    }
    
    public func computeRootEnvironment(defaultEnvironment: SwiftCrossUI.EnvironmentValues) -> SwiftCrossUI.EnvironmentValues {
        return defaultEnvironment
    }
    
    public func setRootEnvironmentChangeHandler(to action: @escaping () -> Void) {
        // TODO
    }

    public func setApplicationMenu(_ submenus: [ResolvedMenu.Submenu]) {
        // TODO
    }

    public func computeWindowEnvironment(window: RootView, rootEnvironment: SwiftCrossUI.EnvironmentValues) -> SwiftCrossUI.EnvironmentValues {
        return rootEnvironment
    }
    
    public func setWindowEnvironmentChangeHandler(of window: RootView, to action: @escaping () -> Void) {
        // TODO
    }

    public func setIncomingURLHandler(to action: @escaping (URL) -> Void) {
        // TODO
    }

    public func createContainer() -> TermKit.View {
        let c = TermKit.View()
        c.canFocus = true
        return c
    }
    
    public func removeAllChildren(of container: TermKit.View) {
        container.removeAllSubviews()
    }
    
    public func addChild(_ child: TermKit.View, to container: TermKit.View) {
        container.addSubview(child)
    }
    
    public func setPosition(ofChildAt index: Int, in container: TermKit.View, to position: SIMD2<Int>) {
        let view = container.subviews[index]
        view.x = Pos.at(position.x)
        view.y = Pos.at(position.y)
    }
    
    public func removeChild(_ child: TermKit.View, from container: TermKit.View) {
        container.removeSubview(child)
    }
    
    public func naturalSize(of widget: TermKit.View) -> SIMD2<Int> {
        // TODO
        return SIMD2(10, 1)
    }
    
    public func setSize(of widget: TermKit.View, to size: SIMD2<Int>) {
        if size.x > 127 || size.y > 32 {
            //fatalError()
        }
        widget.width = Dim.sized(size.x)
        widget.height = Dim.sized(size.y)
    }
    
    public typealias Window = RootView
    public typealias Widget = TermKit.View

    var root: RootView
    var hasCreatedWindow = false

    public init() {
        Application.prepare()
        root = RootView()
        Application.top.addSubview(root)
    }

    public func runMainLoop(_ callback: @escaping @MainActor () -> Void) {
        callback()
        Application.run()
    }

    public func setResizeHandler(ofWindow window: RootView, to action: @escaping (SIMD2<Int>) -> Void) {
        // TODO: implement this
    }

    public func size(ofWindow window: RootView) -> SIMD2<Int> {
        return SIMD2(window.frame.width, window.frame.height)
    }

    public func size(
        of text: String,
        whenDisplayedIn widget: Widget,
        proposedFrame: SIMD2<Int>?,
        environment: EnvironmentValues
    ) -> SIMD2<Int> {
        // TODO
        return SIMD2(text.count, 1)
    }

    public func createWindow(withDefaultSize defaultSize: SIMD2<Int>?) -> RootView {
        guard !hasCreatedWindow else {
            fatalError("CursesBackend doesn't support multi-windowing")
        }
        hasCreatedWindow = true
        return root
    }


    public func setTitle(ofWindow window: Window, to title: String) {}

    public func setResizability(ofWindow window: Window, to resizable: Bool) {}

    public func setChild(ofWindow window: Window, to child: Widget) {
        window.addSubview(child)
    }

    public func show(window: Window) {}

    public func show(widget: Widget) {
        widget.setNeedsDisplay()
    }

    public func createVStack() -> Widget {
        return View()
    }

    public func setChildren(_ children: [Widget], ofVStack container: Widget) {
        // TODO: Properly calculate layout
        for child in children {
            child.y = Pos.at(container.subviews.count)
            container.addSubview(child)
        }
    }

    public func setSpacing(ofVStack container: Widget, to spacing: Int) {}

    public func createHStack() -> Widget {
        return View()
    }

    public func setChildren(_ children: [Widget], ofHStack container: Widget) {
        // TODO: Properly calculate layout
        for child in children {
            child.y = Pos.at(container.subviews.count)
            container.addSubview(child)
        }
    }

    public func setSpacing(ofHStack container: Widget, to spacing: Int) {}

    public func updateScrollContainer(_ scrollView: Widget, environment: EnvironmentValues) {}

    public func createTextView() -> Widget {
        let label = Label("TEXT")
        label.width = Dim.fill()
        return label
    }

    public func updateTextView(
        _ textView: Widget,
        content: String,
        environment: EnvironmentValues
    ) {
        // TODO: Implement text wrap handling
        let label = textView as! Label
        label.text = content
    }

    public func updateTextField(
        _ textField: Widget,
        placeholder: String,
        environment: EnvironmentValues,
        onChange: @escaping (String) -> Void,
        onSubmit: @escaping () -> Void
    ) {
        guard let textField = textField as? TermKit.TextField else { return }
        textField.enabled =  environment.isEnabled
        // TODO placeholder
        // TODO appearance
        textField.textChanged = { textField, _ in
            onChange(textField.text)
        }
        textField.onSubmit = { _ in onSubmit() }
        // TODO: environment.textContentType can be used to configure the input
    }

    public func getContent(ofTextField textField: Widget) -> String {
        guard let textField = textField as? TermKit.TextField else { return "" }
        return textField.text
    }

    public func setContent(ofTextField textField: Widget, to content: String) {
        guard let textField = textField as? TermKit.TextField else { return }
        textField.text = content
    }


    public func createTextField() -> Widget {
        return TermKit.TextField()
    }

    public func createButton() -> Widget {
        let button = TermKit.Button("BUTTON")
        button.height = Dim.sized(1)
        return button
    }

    public func updateToggle(
        _ toggle: Widget,
        label: String,
        environment: EnvironmentValues,
        onChange: @escaping (Bool) -> Void
    ) {
        guard let checkbox = toggle as? TermKit.Checkbox else {
            return
        }
        checkbox.text = label
        checkbox.enabled = environment.isEnabled
        checkbox.toggled =  { toggle in
            onChange(toggle.checked)
        }
    }

    public func setState(ofToggle toggle: Widget, to state: Bool) {
        guard let checkbox = toggle as? TermKit.Checkbox else {
            return
        }
        checkbox.setState(to: state)
    }


    public func createToggle() -> Widget {
        return TermKit.Checkbox("TOGGLE")
    }

    public func setState(ofSwitch toggleSwitch: Widget, to state: Bool) {
        guard let checkbox = toggleSwitch as? TermKit.Checkbox else {
            return
        }
        checkbox.setState(to: state)
    }

    public func updateSwitch(
        _ toggleSwitch: Widget,
        environment: EnvironmentValues,
        onChange: @escaping (Bool) -> Void
    ) {
        guard let checkbox = toggleSwitch as? TermKit.Checkbox else {
            return
        }
        checkbox.text = "SWITCH"
        checkbox.enabled = environment.isEnabled
        checkbox.toggled =  { toggle in
            onChange(toggle.checked)
        }
    }

    public func createSwitch() -> Widget {
        return TermKit.Checkbox("SWITCH")
    }

    public func updateCheckbox(
        _ checkbox: Widget,
        environment: EnvironmentValues,
        onChange: @escaping (Bool) -> Void
    ) {
        guard let checkbox = checkbox as? TermKit.Checkbox else {
            return
        }
        checkbox.text = "CHECK"
        checkbox.enabled = environment.isEnabled
        checkbox.toggled =  { toggle in
            onChange(toggle.checked)
        }
    }

    public func setState(ofCheckbox checkbox: Widget, to state: Bool) {
        guard let checkbox = checkbox as? TermKit.Checkbox else {
            return
        }
        checkbox.setState(to: state)
    }

    public func createCheckbox() -> Widget {
        return TermKit.Checkbox("CHECK")
    }

    public func updateSlider(
        _ slider: Widget,
        minimum: Double,
        maximum: Double,
        decimalPlaces: Int,
        environment: EnvironmentValues,
        onChange: @escaping (Double) -> Void
    ) {
        // TODO
    }

    public func setValue(ofSlider slider: Widget, to value: Double) {
        guard let slider = slider as? TermKit.View else { return }
        // TODO: set the value
    }

    public func createSlider() -> Widget {
        return Label("TODO:SLIDER")
    }

    public func updatePicker(
        _ picker: Widget,
        options: [String],
        environment: EnvironmentValues,
        onChange: @escaping (Int?) -> Void
    ) {
    }

    public func setSelectedOption(ofPicker picker: Widget, to selectedOption: Int?) {
    }

    public func createPicker() -> Widget {
        return Label("TODO:PICKER")
    }

    public func updateButton(
        _ button: Widget,
        label: String,
        environment: EnvironmentValues,
        action: @escaping () -> Void
    ) {
        (button as! TermKit.Button).text = label
        (button as! TermKit.Button).clicked = { _ in
            action()
        }
    }

    // TODO: Properly implement padding container. Perhaps use a conversion factor to
    //   convert the pixel values to 'characters' of padding
    public func createPaddingContainer(for child: Widget) -> Widget {
        return child
    }

    public func getChild(ofPaddingContainer container: Widget) -> Widget {
        return container
    }

    public func setPadding(
        ofPaddingContainer container: Widget,
        top: Int,
        bottom: Int,
        leading: Int,
        trailing: Int
    ) {}

    public func limitScreenBounds(_ bounds: SIMD2<Int>) -> SIMD2<Int> {
        return SIMD2(min(bounds.x, Application.terminalSize.width),
                     min(bounds.y, Application.terminalSize.height))
    }
}

public class RootView: TermKit.View {
    override init() {
        super.init()
        canFocus = true
    }

    public override func processKey(event: KeyEvent) -> Bool {
        if super.processKey(event: event) {
            return true
        }

        switch event.key {
            case .controlC, .esc:
                Application.requestStop()
                return true
            default:
                return false
        }
    }
}
