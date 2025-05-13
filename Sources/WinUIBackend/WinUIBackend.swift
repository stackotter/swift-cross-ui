import CWinRT
import Foundation
import SwiftCrossUI
import UWP
import WinAppSDK
import WinSDK
import WinUI
import WinUIInterop
import WindowsFoundation

// Many force tries are required for the WinUI backend but we don't really want them
// anywhere else so just disable them for this file.
// swiftlint:disable force_try

extension App {
    public typealias Backend = WinUIBackend

    public var backend: WinUIBackend {
        WinUIBackend()
    }
}
class WinUIApplication: SwiftApplication {
    static var callback: ((WinUIApplication) -> Void)?

    override func onLaunched(_ args: WinUI.LaunchActivatedEventArgs) {
        Self.callback?(self)
    }
}
public final class WinUIBackend: AppBackend {
    public typealias Window = CustomWindow
    public typealias Widget = WinUI.FrameworkElement
    public typealias Menu = Void
    public typealias Alert = WinUI.ContentDialog
    public typealias Path = GeometryGroupHolder

    public let defaultTableRowContentHeight = 20
    public let defaultTableCellVerticalPadding = 4
    public let defaultPaddingAmount = 10
    public let requiresToggleSwitchSpacer = false
    public let defaultToggleStyle = ToggleStyle.button
    public let requiresImageUpdateOnScaleFactorChange = false
    public let menuImplementationStyle = MenuImplementationStyle.dynamicPopover
    public let canRevealFiles = false

    public var scrollBarWidth: Int {
        12
    }

    private class InternalState {
        var buttonClickActions: [ObjectIdentifier: () -> Void] = [:]
        var toggleClickActions: [ObjectIdentifier: (Bool) -> Void] = [:]
        var switchClickActions: [ObjectIdentifier: (Bool) -> Void] = [:]
        var sliderChangeActions: [ObjectIdentifier: (Double) -> Void] = [:]
        var textFieldChangeActions: [ObjectIdentifier: (String) -> Void] = [:]
        var textFieldSubmitActions: [ObjectIdentifier: () -> Void] = [:]
        var dispatcherQueue: WinAppSDK.DispatcherQueue?
        var themeChangeAction: (() -> Void)?
    }

    private var internalState: InternalState
    /// WinUI only allows one dialog at a time (subsequent dialogs throw
    /// exceptions), so we limit ourselves.
    private var dialogSemaphore = DispatchSemaphore(value: 1)

    private var windows: [Window] = []

    public init() {
        internalState = InternalState()
    }

    struct Error: LocalizedError {
        var message: String

        var errorDescription: String? {
            message
        }
    }

    public func runMainLoop(_ callback: @escaping () -> Void) {
        do {
            try Self.attachToParentConsole()
        } catch {
            // We essentially just ignore if this fails because it's just a QoL
            // debugging feature, and if it fails then any warning we print likely
            // won't get seen anyway. But I don't trust my Windows knowledge enough
            // to assert that it's impossible to view logs on failure, so let's
            // print a warning anyway.
            print("Warning: Failed to attach to parent console: \(error.localizedDescription)")
        }

        // Ensure that the app's windows adapt to DPI changes at runtime
        SetThreadDpiAwarenessContext(DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2)

        WinUIApplication.callback = { application in
            // Toggle Switch has annoying default 'internal margins' (not Control
            // margins that we can set directly) that we can luckily get rid of by
            // overriding the relevant resource values.
            _ = application.resources.insert("ToggleSwitchPreContentMargin", 0.0 as Double)
            _ = application.resources.insert("ToggleSwitchPostContentMargin", 0.0 as Double)

            // Handle theme changes
            UWP.UISettings().colorValuesChanged.addHandler { _, _ in
                self.internalState.themeChangeAction?()
            }

            // TODO: Read in previously hardcoded values from the application's
            // resources dictionary for future-proofing. Example code for getting
            // property values;
            //   let iinspectable =
            //       application.resources.lookup("ToggleSwitchPreContentMargin")!
            //       as! WindowsFoundation.IInspectable
            //   let pv: __ABI_Windows_Foundation.IPropertyValue = try! iinspectable.QueryInterface()
            //   let value = try! pv.GetDoubleImpl()

            callback()
        }
        WinUIApplication.main()
    }

    public func createWindow(withDefaultSize size: SIMD2<Int>?) -> Window {
        let window = CustomWindow()
        windows.append(window)
        window.closed.addHandler { _, _ in
            self.windows.removeAll { other in
                window === other
            }
        }

        if internalState.dispatcherQueue == nil {
            internalState.dispatcherQueue = window.dispatcherQueue
        }

        // import WinSDK
        // import CWinRT
        // @_spi(WinRTInternal) import WindowsFoundation
        // let minSizeHook: HOOKPROC = { (nCode: Int32, wParam: WPARAM, lParam: LPARAM) in
        //     if nCode >= 0 {
        //         let ptr = UnsafeRawPointer(bitPattern: Int(lParam))?
        //             .assumingMemoryBound(to: CWPRETSTRUCT.self)
        //         if let msgInfo = ptr?.pointee, msgInfo.message == WM_GETMINMAXINFO {
        //             print("Received WM_GETMINMAXINFO")

        //             // var value: HWND = .init(0)
        //             _ = try! window._inner.perform(
        //                 as: __x_ABI_CMicrosoft_CUI_CXaml_CIWindowNative.self
        //             ) { pThis in
        //                 try! CHECKED(pThis.pointee.lpVtbl.pointee.get_WindowHandle(pThis, nil))
        //             }
        //         }
        //     }
        //     return CallNextHookEx(nil, nCode, wParam, lParam)
        // }

        // _ = SetWindowsHookExW(WH_CALLWNDPROCRET, minSizeHook, nil, GetCurrentThreadId())
        // print("Registered")

        // print(GetDpiForWindow(nil))

        if let size {
            try! window.appWindow.resizeClient(
                SizeInt32(
                    width: Int32(size.x),
                    height: Int32(size.y)
                )
            )
        }
        return window
    }

    public func size(ofWindow window: Window) -> SIMD2<Int> {
        let size = window.appWindow.clientSize
        let out = SIMD2(
            Int(size.width),
            Int(size.height) - CustomWindow.menuBarHeight
        )
        return out
    }

    public func isWindowProgrammaticallyResizable(_ window: Window) -> Bool {
        // TODO: Detect whether window is fullscreen
        return true
    }

    public func setSize(ofWindow window: Window, to newSize: SIMD2<Int>) {
        let scaleFactor = window.scaleFactor
        let width = scaleFactor * Double(newSize.x)
        let height = scaleFactor * Double(newSize.y + CustomWindow.menuBarHeight)
        let size = UWP.SizeInt32(
            width: Int32(width.rounded(.towardZero)),
            height: Int32(height.rounded(.towardZero))
        )
        try! window.appWindow.resizeClient(size)
    }

    public func setMinimumSize(ofWindow window: Window, to minimumSize: SIMD2<Int>) {
        missing("window minimum size")
    }

    public func setResizeHandler(
        ofWindow window: Window,
        to action: @escaping (SIMD2<Int>) -> Void
    ) {
        window.sizeChanged.addHandler { _, args in
            let size = SIMD2(
                Int(args!.size.width.rounded(.awayFromZero)),
                Int(args!.size.height.rounded(.awayFromZero)) - CustomWindow.menuBarHeight
            )
            action(size)
        }
    }

    public func setTitle(ofWindow window: Window, to title: String) {
        window.title = title
    }

    public func setResizability(ofWindow window: Window, to value: Bool) {
        (window.appWindow.presenter as! OverlappedPresenter).isResizable = value
    }

    public func setChild(ofWindow window: Window, to widget: Widget) {
        window.setChild(widget)
        try! widget.updateLayout()
        widget.actualThemeChanged.addHandler { _, _ in
            self.internalState.themeChangeAction?()
        }
    }

    public func show(window: Window) {
        try! window.activate()
    }

    public func activate(window: Window) {
        try! window.activate()
    }

    public func openExternalURL(_ url: URL) throws {
        _ = UWP.Launcher.launchUriAsync(WindowsFoundation.Uri(url.absoluteString))
    }

    public func runInMainThread(action: @escaping () -> Void) {
        _ = try! internalState.dispatcherQueue!.tryEnqueue(.normal) {
            action()
        }
    }

    public func show(widget _: Widget) {}

    private func missing(_ message: String) {
        // print("missing: \(message)")
    }

    private func renderItems(_ items: [ResolvedMenu.Item]) -> [MenuFlyoutItemBase] {
        items.map { item in
            switch item {
                case .button(let label, let action):
                    let widget = MenuFlyoutItem()
                    widget.text = label
                    widget.click.addHandler { _, _ in
                        action?()
                    }
                    return widget
                case .submenu(let submenu):
                    let widget = MenuFlyoutSubItem()
                    widget.text = submenu.label
                    for subitem in renderItems(submenu.content.items) {
                        widget.items.append(subitem)
                    }
                    return widget
            }
        }
    }

    public func setApplicationMenu(_ submenus: [ResolvedMenu.Submenu]) {
        let items = submenus.map { submenu in
            let item = MenuBarItem()
            item.title = submenu.label
            for subitem in renderItems(submenu.content.items) {
                item.items.append(subitem)
            }
            return item
        }

        for window in windows {
            window.menuBar.items.clear()
            for item in items {
                window.menuBar.items.append(item)
            }
        }
    }

    public func computeRootEnvironment(
        defaultEnvironment: EnvironmentValues
    ) -> EnvironmentValues {
        // Source: https://learn.microsoft.com/en-us/windows/apps/desktop/modernize/ui/apply-windows-themes#know-when-dark-mode-is-enabled
        let backgroundColor = try! UWP.UISettings().getColorValue(.background)

        let green = Int(backgroundColor.g)
        let red = Int(backgroundColor.r)
        let blue = Int(backgroundColor.b)
        let isLight = 5 * green + 2 * red + blue > 8 * 128

        return
            defaultEnvironment
            .with(\.font, .system(size: 14))
            .with(\.colorScheme, isLight ? .light : .dark)
    }

    public func setRootEnvironmentChangeHandler(to action: @escaping () -> Void) {
        internalState.themeChangeAction = action
    }

    public func computeWindowEnvironment(
        window: Window,
        rootEnvironment: EnvironmentValues
    ) -> EnvironmentValues {
        // TODO: Compute window scale factor (easy enough, but we would also have to keep
        //   it up-to-date then, which is kinda annoying for now)
        rootEnvironment
    }

    public func setWindowEnvironmentChangeHandler(
        of window: Window,
        to action: @escaping () -> Void
    ) {
        // TODO: Notify when window scale factor changes
    }

    public func setIncomingURLHandler(to action: @escaping (URL) -> Void) {
        print("Implement set incoming url handler")
        // TODO
    }

    public func createContainer() -> Widget {
        Canvas()
    }

    public func removeAllChildren(of container: Widget) {
        let container = container as! Canvas
        container.children.clear()
    }

    public func addChild(_ child: Widget, to container: Widget) {
        let container = container as! Canvas
        container.children.append(child)
    }

    public func setPosition(ofChildAt index: Int, in container: Widget, to position: SIMD2<Int>) {
        let container = container as! Canvas
        guard let child = container.children.getAt(UInt32(index)) else {
            print("warning: child to set position of not found")
            return
        }

        Canvas.setTop(child, Double(position.y))
        Canvas.setLeft(child, Double(position.x))
    }

    public func removeChild(_ child: Widget, from container: Widget) {
        let container = container as! Canvas
        let count = container.children.size
        for index in 0..<count {
            if container.children.getAt(index) == child {
                container.children.removeAt(index)
                return
            }
        }

        print("warning: child to remove not found")
    }

    public func createColorableRectangle() -> Widget {
        Canvas()
    }

    public func setColor(
        ofColorableRectangle widget: Widget,
        to color: SwiftCrossUI.Color
    ) {
        let canvas = widget as! Canvas
        let brush = WinUI.SolidColorBrush()
        brush.color = color.uwpColor
        canvas.background = brush
    }

    public func setCornerRadius(of widget: Widget, to radius: Int) {
        let visual: WinAppSDK.Visual = try! widget.getVisualInternal()

        let geometry = try! visual.compositor.createRoundedRectangleGeometry()!
        geometry.cornerRadius = WindowsFoundation.Vector2(
            x: Float(radius),
            y: Float(radius)
        )

        // We assume that SwiftCrossUI has explicitly set the size of the
        // underlying widget.
        geometry.size = WindowsFoundation.Vector2(
            x: Float(widget.width),
            y: Float(widget.height)
        )

        let clip = try! visual.compositor.createGeometricClip()!
        clip.geometry = geometry

        visual.clip = clip
    }

    public func naturalSize(of widget: Widget) -> SIMD2<Int> {
        let allocation = WindowsFoundation.Size(
            width: .infinity,
            height: .infinity
        )

        // Some elements don't return any sort of sensible measurement before
        // they've been rendered. For said elements, we just compute their sizes
        // as best we can by roughly replicating WinUI's internal calculations.
        let noPadding = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        if widget is WinUI.Slider {
            // As with buttons, slider sizing also doesn't work before the first
            // view update. The width and height I've hardcoded here were taken
            // from the WinUI source code: https://github.com/microsoft/microsoft-ui-xaml/blob/650b2c1bad272393400403ca323b3cb8745f95d0/src/controls/dev/CommonStyles/Slider_themeresources.xaml#L169
            return SIMD2(
                18 + 8,
                18 + 8
            )
        } else if widget is WinUI.ToggleSwitch {
            // WinUI sets the min-width of switches to 154 for whatever reason,
            // and I don't know how to override that default from Swift, so I'm
            // just hardcoding the size. This keeps getting jankier and
            // jankier...
            return SIMD2(
                40,
                20
            )
        } else if let picker = widget as? CustomComboBox, picker.padding == noPadding {
            let label = TextBlock()
            label.text = picker.options[Int(max(picker.selectedIndex, 0))]
            label.fontSize = picker.fontSize
            label.fontWeight = picker.fontWeight
            try! label.measure(allocation)

            // These padding values were gathered experimentally. I've found that
            // WinUI generally hardcodes padding, border thickness and such in its
            // default theme, so I feel it's safe enough to use this workaround for
            // now (until https://github.com/microsoft/microsoft-ui-xaml/issues/10278
            // gets an answer).
            let labelSize = label.desiredSize
            return SIMD2(
                Int(labelSize.width) + 50,
                // The default minimum picker height is 32 pixels
                max(Int(labelSize.height) + 12, 32)
            )
        } else if widget is ProgressRing {
            // ProgressRing appears to kind of grow to fill by default, but
            // SwiftCrossUI expects progress spinners to be fixed size, which
            // results in WinUI progress rings getting given astronomically
            // large fixed dimensions and causing crashes. To work around that,
            // we just override their 'natural size' to 32x32, which is based off
            // the defaults set in the following code from the WinUI repository:
            // https://github.com/marcelwgn/microsoft-ui-xaml/blob/ff21f9b212cea2191b959649e45e52486c8465aa/src/controls/dev/ProgressRing/ProgressRing.xaml#L12
            return SIMD2(32, 32)
        }

        let oldWidth = widget.width
        let oldHeight = widget.height
        defer {
            widget.width = oldWidth
            widget.height = oldHeight
        }

        widget.width = .nan
        widget.height = .nan

        try! widget.measure(allocation)

        let computedSize = widget.desiredSize

        // Some elements don't get their default padding/border applied until
        // they've been rendered. For such elements we have to compute out own
        // adjustment factors based off values taken from WinUI's default theme.
        // We can detect such elements because their padding property will be set
        // to zero until first render (and atm WinUIBackend doesn't set this padding
        // property itself so this is a safe detection method).
        let adjustment: SIMD2<Int>
        if let button = widget as? WinUI.Button, button.padding == noPadding {
            // WinUI buttons have padding, but the `padding` property returns
            // zero until the button has been rendered at least once. And even
            // if you manually set the button's padding, it gets ignored by
            // `measure()` before first render.
            //
            // The default in my Windows 11 VM seems to be 11 pixels either
            // side, 5 pixels above, and 6 pixels below. I found this hardcoded
            // in the WinUI repository, so hopefully it is the same everywhere...
            // Hardcoded here: https://github.com/microsoft/microsoft-ui-xaml/blob/650b2c1bad272393400403ca323b3cb8745f95d0/src/controls/dev/CommonStyles/Button_themeresources.xaml#L116
            //
            // We'll have to find a more dynamic way of correcting for WinUI's
            // measurement weirdness at some point (which will probably involve
            // figuring out how to access the `ButtonPadding` resource value
            // from Swift).
            //
            // Buttons seem to have 1 pixel of border on each side which also
            // gets ignored before first render.
            adjustment = SIMD2(
                11 + 11 + 2,
                5 + 6 + 2
            )
        } else if let toggleButton = widget as? WinUI.ToggleButton,
            toggleButton.padding == noPadding
        {
            // See the above comment regarding Button. Very similar situation.
            adjustment = SIMD2(
                11 + 11 + 2,
                5 + 6 + 2
            )
        } else if let textField = widget as? WinUI.TextBox, textField.padding == noPadding {
            // The default padding applied to text boxes can be found here:
            // https://github.com/microsoft/microsoft-ui-xaml/blob/650b2c1bad272393400403ca323b3cb8745f95d0/src/controls/dev/CommonStyles/Common_themeresources.xaml#L12
            // However, text fields return 0x0 before rendering so our adjustment
            // just has to be the entire size of the text field. I've currently just
            // hardcoded a value obtained from one of my example apps.
            adjustment = SIMD2(
                64,
                32
            )
        } else {
            adjustment = .zero
        }

        let out = SIMD2(
            Int(computedSize.width) + adjustment.x,
            Int(computedSize.height) + adjustment.y
        )

        return out
    }

    public func setSize(of widget: Widget, to size: SIMD2<Int>) {
        widget.width = Double(size.x)
        widget.height = Double(size.y)
    }

    public func size(
        of text: String,
        whenDisplayedIn textView: Widget,
        proposedFrame: SIMD2<Int>?,
        environment: EnvironmentValues
    ) -> SIMD2<Int> {
        let block = createTextView()
        updateTextView(block, content: text, environment: environment)

        let allocation = WindowsFoundation.Size(
            width: (proposedFrame?.x).map(Float.init(_:)) ?? .infinity,
            height: .infinity
        )
        try! block.measure(allocation)

        let computedSize = block.desiredSize
        return SIMD2(
            Int(computedSize.width),
            Int(computedSize.height)
        )
    }

    public func createTextView() -> Widget {
        let textBlock = TextBlock()
        textBlock.textWrapping = .wrap
        return textBlock
    }

    public func updateTextView(
        _ textView: Widget,
        content: String,
        environment: EnvironmentValues
    ) {
        let block = textView as! TextBlock
        block.text = content
        missing("font design handling (monospace vs normal)")
        environment.apply(to: block)
    }

    public func createButton() -> Widget {
        let button = Button()
        button.click.addHandler { [weak internalState] _, _ in
            guard let internalState = internalState else {
                return
            }
            internalState.buttonClickActions[ObjectIdentifier(button)]?()
        }
        return button
    }

    public func updateButton(
        _ button: Widget,
        label: String,
        action: @escaping () -> Void,
        environment: EnvironmentValues
    ) {
        let button = button as! WinUI.Button
        let block = TextBlock()
        block.text = label
        button.content = block
        environment.apply(to: block)
        internalState.buttonClickActions[ObjectIdentifier(button)] = action

        switch environment.colorScheme {
            case .light:
                button.requestedTheme = .light
            case .dark:
                button.requestedTheme = .dark
        }
    }

    public func createScrollContainer(for child: Widget) -> Widget {
        let scrollViewer = WinUI.ScrollViewer()
        scrollViewer.content = child
        child.horizontalAlignment = .left
        child.verticalAlignment = .top
        return scrollViewer
    }

    public func setScrollBarPresence(
        ofScrollContainer scrollView: Widget,
        hasVerticalScrollBar: Bool,
        hasHorizontalScrollBar: Bool
    ) {
        let scrollViewer = scrollView as! WinUI.ScrollViewer

        scrollViewer.isHorizontalRailEnabled = hasHorizontalScrollBar
        scrollViewer.horizontalScrollMode = hasHorizontalScrollBar ? .enabled : .disabled
        scrollViewer.horizontalScrollBarVisibility = hasHorizontalScrollBar ? .visible : .hidden

        scrollViewer.isVerticalRailEnabled = hasVerticalScrollBar
        scrollViewer.verticalScrollMode = hasVerticalScrollBar ? .enabled : .disabled
        scrollViewer.verticalScrollBarVisibility = hasVerticalScrollBar ? .visible : .hidden
    }

    class CustomListView: WinUI.ListView {
        var selectionHandler: ((_ selectedIndex: Int) -> Void)?
        var currentItems: [WinUI.ListViewItem] = []
        var cachedSelectedItem: Int? = nil
    }

    public func createSelectableListView() -> Widget {
        let listView = CustomListView()
        listView.selectionMode = .single
        listView.selectionChanged.addHandler { [weak listView] _, args in
            guard let listView else { return }
            guard listView.selectedRanges.count > 0 else {
                return
            }
            let selection = Int(listView.selectedRanges[0]!.firstIndex)
            guard selection != listView.cachedSelectedItem else {
                return
            }
            listView.selectionHandler?(selection)
        }
        return listView
    }

    public func baseItemPadding(ofSelectableListView listView: Widget) -> EdgeInsets {
        EdgeInsets(
            top: 8,
            bottom: 8,
            leading: 16,
            trailing: 12
        )
    }

    public func minimumRowSize(ofSelectableListView listView: Widget) -> SIMD2<Int> {
        SIMD2(
            80,
            40
        )
    }

    public func setItems(
        ofSelectableListView listView: Widget,
        to items: [Widget],
        withRowHeights rowHeights: [Int]
    ) {
        let listView = listView as! CustomListView
        listView.itemContainerTransitions.clear()

        for listItem in listView.currentItems {
            listItem.content = nil
        }

        if items.count != listView.currentItems.count {
            listView.items.clear()
        }

        // We add the new items to the list but also to `listView.currentItems`.
        // This is so that we can retrieve the correct list item instances in
        // setSelectedItem. If we just use `listView.items` instead we get separate
        // incorrect instances for whatever reason (symptom is that it crashes stuff).
        var listItems: [WinUI.ListViewItem] = []
        for (index, item) in items.enumerated() {
            let listItem: WinUI.ListViewItem
            if items.count == listView.currentItems.count {
                listItem = listView.currentItems[index]
            } else {
                listItem = WinUI.ListViewItem()
            }
            listItem.horizontalContentAlignment = .left
            listItem.content = item
            listItem.padding = Thickness(left: 16, top: 8, right: 12, bottom: 8)
            if items.count != listView.currentItems.count {
                listItems.append(listItem)
                listView.items.append(listItem)
            }
        }

        if items.count != listView.currentItems.count {
            listView.currentItems = listItems
            listView.cachedSelectedItem = nil
        }
    }

    public func setSelectionHandler(
        forSelectableListView listView: Widget,
        to action: @escaping (_ selectedIndex: Int) -> Void
    ) {
        let listView = listView as! CustomListView
        listView.selectionHandler = action
    }

    public func setSelectedItem(
        ofSelectableListView listView: Widget,
        toItemAt index: Int?
    ) {
        let listView = listView as! CustomListView
        guard index != listView.cachedSelectedItem else {
            return
        }
        listView.cachedSelectedItem = index
        if let index {
            // We use `listView.currentItems` instead of `listView.items` because
            // `listView.items` isn't the original instances we added and WinUI
            // doesn't like that.
            listView.selectedItem = listView.currentItems[index]
        } else {
            listView.selectedItem = nil
        }
    }

    public func createSlider() -> Widget {
        let slider = Slider()
        slider.valueChanged.addHandler { [weak internalState] _, event in
            guard let internalState = internalState else {
                return
            }
            internalState.sliderChangeActions[ObjectIdentifier(slider)]?(
                Double(event?.newValue ?? 0))
        }
        slider.stepFrequency = 0.01
        return slider
    }

    public func updateSlider(
        _ slider: Widget,
        minimum: Double,
        maximum: Double,
        decimalPlaces _: Int,
        onChange: @escaping (Double) -> Void
    ) {
        let slider = slider as! WinUI.Slider
        slider.minimum = minimum
        slider.maximum = maximum
        internalState.sliderChangeActions[ObjectIdentifier(slider)] = onChange

        // TODO: Add environment to updateSlider API
        // switch environment.colorScheme {
        //     case .light:
        //         slider.requestedTheme = .light
        //     case .dark:
        //         slider.requestedTheme = .dark
        // }
    }

    public func setValue(ofSlider slider: Widget, to value: Double) {
        let slider = slider as! WinUI.Slider
        slider.value = value
    }

    public func createPicker() -> Widget {
        let picker = CustomComboBox()
        picker.selectionChanged.addHandler { [weak picker] _, _ in
            guard let picker else { return }
            picker.onChangeSelection?(Int(picker.selectedIndex))
        }

        // When hovering over a picker, its foreground changes to black,
        // when the pointer exits the picker the foreground color remains
        // black instead of returning to its regular value. I've tried various
        // variations of the solution below and it seems like the only thing
        // that works is fully recreating the brush.
        picker.pointerExited.addHandler { [weak picker] _, _ in
            guard let picker else { return }
            let brush = SolidColorBrush()
            brush.color = picker.actualForegroundColor
            picker.foreground = brush
        }

        return picker
    }

    public func updatePicker(
        _ picker: Widget,
        options: [String],
        environment: EnvironmentValues,
        onChange: @escaping (Int?) -> Void
    ) {
        let picker = picker as! CustomComboBox

        picker.onChangeSelection = onChange
        environment.apply(to: picker)
        picker.actualForegroundColor = environment.suggestedForegroundColor.uwpColor

        switch environment.colorScheme {
            case .light:
                picker.requestedTheme = .light
            case .dark:
                picker.requestedTheme = .dark
        }

        // Only update options past this point, otherwise the early return
        // will cause issues.
        guard options.count > 0 else {
            picker.options = []
            return
        }

        if options.count == picker.items.count {
            // for i in 0 ..< options.count {
            // TODO: Understands how to get ComboBox items in WinUI
            // if picker.items.getAt(UInt32(i)) as? String != options[i] {
            // picker.items.setAt(UInt32(1), options[i])
            // }
            // }
        } else if options.count > picker.items.count {
            if !picker.items.isEmpty {
                for i in 0..<picker.items.count {
                    // if picker.items.getAt(UInt32(i)) as? String != options[i] {
                    picker.items.setAt(UInt32(i), options[i])
                    // }
                }
            }
            for i in picker.items.count..<options.count {
                picker.items.append(options[i])
            }
        } else {
            for i in 0..<options.count {
                // if picker.items.getAt(UInt32(i)) as? String != options[i] {
                picker.items.setAt(UInt32(i), options[i])
                // }
            }
            for i in options.count..<picker.items.count {
                picker.items.removeAt(UInt32(i))
            }
        }

        missing("proper picker updating logic")
        missing("picker font handling")

        picker.options = options
    }

    public func setSelectedOption(ofPicker picker: Widget, to selectedOption: Int?) {
        let picker = picker as! ComboBox
        picker.selectedIndex = Int32(selectedOption ?? 0)
    }

    public func createTextField() -> Widget {
        let textField = TextBox()
        textField.textChanged.addHandler { [weak internalState] _, _ in
            guard let internalState = internalState else {
                return
            }
            internalState.textFieldChangeActions[ObjectIdentifier(textField)]?(textField.text)
        }
        textField.keyUp.addHandler { [weak internalState] _, event in
            guard let internalState = internalState else {
                return
            }

            if event?.key == .enter {
                internalState.textFieldSubmitActions[ObjectIdentifier(textField)]?()
            }
        }
        return textField
    }

    public func updateTextField(
        _ textField: Widget,
        placeholder: String,
        environment: EnvironmentValues,
        onChange: @escaping (String) -> Void,
        onSubmit: @escaping () -> Void
    ) {
        let textField = (textField as! TextBox)
        textField.placeholderText = placeholder
        internalState.textFieldChangeActions[ObjectIdentifier(textField)] = onChange
        internalState.textFieldSubmitActions[ObjectIdentifier(textField)] = onSubmit

        switch environment.colorScheme {
            case .light:
                textField.requestedTheme = .light
            case .dark:
                textField.requestedTheme = .dark
        }

        missing("text field font handling")
    }

    public func setContent(ofTextField textField: Widget, to content: String) {
        (textField as! TextBox).text = content
    }

    public func getContent(ofTextField textField: Widget) -> String {
        (textField as! TextBox).text
    }

    public func createImageView() -> Widget {
        WinUI.Image()
    }

    public func updateImageView(
        _ imageView: Widget,
        rgbaData: [UInt8],
        width: Int,
        height: Int,
        targetWidth: Int,
        targetHeight: Int,
        dataHasChanged: Bool
    ) {
        let imageView = imageView as! WinUI.Image
        let bitmap = WriteableBitmap(Int32(width), Int32(height))
        let buffer = try! bitmap.pixelBuffer.buffer!
        memcpy(buffer, rgbaData, min(Int(bitmap.pixelBuffer.length), rgbaData.count))

        // Convert RGBA to BGRA in-place, and apply janky transparency fix until we
        // figure out how to fix WinUI image blending (non-black transparent pixels
        // just don't seem to get blended at all, or at least pixels that are white
        // enough, haven't tested many colours).
        for i in 0..<(width * height) {
            let offset = i * 4
            if buffer[offset + 3] == 0 {
                // If transparent, make the pixel black (this is the janky blending fix).
                buffer[offset] = 0
                buffer[offset + 1] = 0
                buffer[offset + 2] = 0
            } else {
                // Swap R and B (RGBA to BGRA)
                let tmp = buffer[offset]
                buffer[offset] = buffer[offset + 2]
                buffer[offset + 2] = tmp
            }
        }

        imageView.source = bitmap
    }

    public func createSplitView(leadingChild: Widget, trailingChild: Widget) -> Widget {
        let splitView = CustomSplitView()
        splitView.pane = leadingChild
        splitView.content = trailingChild
        splitView.isPaneOpen = true
        splitView.displayMode = .inline
        return splitView
    }

    public func setResizeHandler(
        ofSplitView splitView: Widget,
        to action: @escaping () -> Void
    ) {
        // WinUI's SplitView currently doesn't support resizing, but we still
        // store the sidebar resize handler because we programmatically resize
        // the sidebar and call the handler whenever the minimum sidebar width
        // changes.
        let splitView = splitView as! CustomSplitView
        splitView.sidebarResizeHandler = action
    }

    public func sidebarWidth(ofSplitView splitView: Widget) -> Int {
        let splitView = splitView as! CustomSplitView
        return Int(splitView.openPaneLength.rounded(.towardZero))
    }

    public func setSidebarWidthBounds(
        ofSplitView splitView: Widget,
        minimum minimumWidth: Int,
        maximum maximumWidth: Int
    ) {
        let splitView = splitView as! CustomSplitView
        let newWidth = Double(max(minimumWidth, 10))
        if newWidth != splitView.openPaneLength {
            splitView.openPaneLength = newWidth
            splitView.sidebarResizeHandler?()
        }
    }

    public func createToggle() -> Widget {
        let toggle = ToggleButton()
        toggle.click.addHandler { [weak internalState] _, _ in
            guard let internalState = internalState else {
                return
            }
            internalState.toggleClickActions[ObjectIdentifier(toggle)]?(toggle.isChecked ?? false)
        }
        return toggle
    }

    public func updateToggle(_ toggle: Widget, label: String, onChange: @escaping (Bool) -> Void) {
        let toggle = toggle as! ToggleButton
        let block = TextBlock()
        block.text = label
        toggle.content = block
        internalState.toggleClickActions[ObjectIdentifier(toggle)] = onChange

        // TODO: Add environment to updateToggle API. Rename updateToggle etc to
        //   updateToggleButton etc
        // switch environment.colorScheme {
        //     case .light:
        //         toggle.requestedTheme = .light
        //     case .dark:
        //         toggle.requestedTheme = .dark
        // }
    }

    public func setState(ofToggle toggle: Widget, to state: Bool) {
        (toggle as! ToggleButton).isChecked = state
    }

    public func createSwitch() -> Widget {
        let toggleSwitch = ToggleSwitch()
        toggleSwitch.offContent = ""
        toggleSwitch.onContent = ""
        toggleSwitch.padding = Thickness(left: 0, top: 0, right: 0, bottom: 0)
        toggleSwitch.toggled.addHandler { [weak internalState] _, _ in
            guard let internalState = internalState else {
                return
            }
            internalState.switchClickActions[ObjectIdentifier(toggleSwitch)]?(toggleSwitch.isOn)
        }
        return toggleSwitch
    }

    public func updateSwitch(_ toggleSwitch: Widget, onChange: @escaping (Bool) -> Void) {
        internalState.switchClickActions[ObjectIdentifier(toggleSwitch)] = onChange

        // TODO: Add environment to updateSwitch API
        // switch environment.colorScheme {
        //     case .light:
        //         toggleSwitch.requestedTheme = .light
        //     case .dark:
        //         toggleSwitch.requestedTheme = .dark
        // }
    }

    public func setState(ofSwitch switchWidget: Widget, to state: Bool) {
        let switchWidget = switchWidget as! ToggleSwitch
        if switchWidget.isOn != state {
            switchWidget.isOn = state
        }
    }

    public func createAlert() -> Alert {
        ContentDialog()
    }

    public func updateAlert(
        _ alert: Alert,
        title: String,
        actionLabels: [String],
        environment: EnvironmentValues
    ) {
        alert.title = title
        if actionLabels.count >= 1 {
            alert.primaryButtonText = actionLabels[0]
        }
        if actionLabels.count >= 2 {
            alert.secondaryButtonText = actionLabels[1]
        }
        if actionLabels.count >= 3 {
            alert.closeButtonText = actionLabels[2]
        }

        switch environment.colorScheme {
            case .light:
                alert.requestedTheme = .light
            case .dark:
                alert.requestedTheme = .dark
        }
    }

    public func showAlert(
        _ alert: Alert,
        window: Window?,
        responseHandler handleResponse: @escaping (Int) -> Void
    ) {
        // WinUI only allows one dialog at a time so we limit ourselves using
        // a semaphore.
        guard let window = window ?? windows.first else {
            print("warning: WinUI can't show alert without window")
            return
        }

        alert.xamlRoot = window.content.xamlRoot
        dialogSemaphore.wait()
        let promise = try! alert.showAsync()!
        promise.completed = { operation, status in
            self.dialogSemaphore.signal()
            guard
                status == .completed,
                let operation,
                let result = try? operation.getResults()
            else {
                return
            }
            let index =
                switch result {
                    case .primary: 0
                    case .secondary: 1
                    case .none: 2
                    default:
                        fatalError("WinUIBackend: Invalid dialog response")
                }
            handleResponse(index)
        }
    }

    public func showOpenDialog(
        fileDialogOptions: FileDialogOptions,
        openDialogOptions: OpenDialogOptions,
        window: Window?,
        resultHandler handleResult: @escaping (DialogResult<[URL]>) -> Void
    ) {
        let picker = FileOpenPicker()

        let window = window ?? windows[0]
        let hwnd = window.getHWND()!
        let interface: SwiftIInitializeWithWindow = try! picker.thisPtr.QueryInterface()
        try! interface.initialize(with: hwnd)

        picker.fileTypeFilter.append("*")

        if openDialogOptions.allowMultipleSelections {
            let promise = try! picker.pickMultipleFilesAsync()!
            promise.completed = { operation, status in
                guard
                    status == .completed,
                    let operation,
                    let result = try? operation.getResults()
                else {
                    handleResult(.cancelled)
                    return
                }

                let files = Array(result).compactMap { $0 }
                    .map(\.path)
                    .map(URL.init(fileURLWithPath:))
                handleResult(.success(files))
            }
        } else {
            let promise = try! picker.pickSingleFileAsync()!
            promise.completed = { operation, status in
                guard
                    status == .completed,
                    let operation,
                    let result = try? operation.getResults()
                else {
                    handleResult(.cancelled)
                    return
                }

                let file = URL(fileURLWithPath: result.path)
                handleResult(.success([file]))
            }
        }
    }

    public func showSaveDialog(
        fileDialogOptions: FileDialogOptions,
        saveDialogOptions: SaveDialogOptions,
        window: Window?,
        resultHandler handleResult: @escaping (DialogResult<URL>) -> Void
    ) {
        let picker = FileSavePicker()

        let window = window ?? windows[0]
        let hwnd = window.getHWND()!
        let interface: SwiftIInitializeWithWindow = try! picker.thisPtr.QueryInterface()
        try! interface.initialize(with: hwnd)

        _ = picker.fileTypeChoices.insert("Text", [".txt"].toVector())
        let promise = try! picker.pickSaveFileAsync()!
        promise.completed = { operation, status in
            guard
                status == .completed,
                let operation,
                let result = try? operation.getResults()
            else {
                handleResult(.cancelled)
                return
            }

            let file = URL(fileURLWithPath: result.path)
            handleResult(.success(file))
        }
    }

    public func createTapGestureTarget(wrapping child: Widget, gesture: TapGesture) -> Widget {
        if gesture != .primary {
            fatalError("Unsupported gesture type \(gesture)")
        }
        let tapGestureTarget = TapGestureTarget()
        addChild(child, to: tapGestureTarget)
        tapGestureTarget.child = child

        // Set a background so that the click target's entire area gets hit
        // tested. The background we set is transparent so that it doesn't
        // change the visual appearance of the view.
        let brush = SolidColorBrush()
        brush.color = UWP.Color(a: 0, r: 0, g: 0, b: 0)
        tapGestureTarget.background = brush

        tapGestureTarget.pointerPressed.addHandler { [weak tapGestureTarget] _, _ in
            guard let tapGestureTarget else {
                return
            }
            tapGestureTarget.clickHandler?()
        }
        return tapGestureTarget
    }

    public func updateTapGestureTarget(
        _ tapGestureTarget: Widget,
        gesture: TapGesture,
        action: @escaping () -> Void
    ) {
        if gesture != .primary {
            fatalError("Unsupported gesture type \(gesture)")
        }
        let tapGestureTarget = tapGestureTarget as! TapGestureTarget
        tapGestureTarget.clickHandler = action
        tapGestureTarget.width = tapGestureTarget.child!.width
        tapGestureTarget.height = tapGestureTarget.child!.height
    }

    public func createProgressSpinner() -> Widget {
        let spinner = ProgressRing()
        spinner.isIndeterminate = true
        return spinner
    }

    public func createProgressBar() -> Widget {
        let progressBar = ProgressBar()
        progressBar.maximum = 10_000
        return progressBar
    }

    public func updateProgressBar(
        _ widget: Widget,
        progressFraction: Double?,
        environment: EnvironmentValues
    ) {
        let progressBar = widget as! ProgressBar
        if let progressFraction = progressFraction {
            progressBar.isIndeterminate = false
            progressBar.value = progressBar.maximum * progressFraction
        } else {
            progressBar.isIndeterminate = true
        }
    }

    public func createPathWidget() -> Widget {
        WinUI.Path()
    }

    public func createPath() -> Path {
        GeometryGroupHolder()
    }

    public func updatePath(_ path: Path, _ source: SwiftCrossUI.Path, pointsChanged: Bool) {
        path.strokeStyle = source.strokeStyle

        if pointsChanged {
            path.group.children.clear()
            applyActions(source.actions, to: path.group.children)
        }

        path.group.fillRule =
            switch source.fillRule {
                case .evenOdd:
                    .evenOdd
                case .winding:
                    .nonzero
            }
    }

    func requirePathFigure(
        _ collection: WinUI.GeometryCollection,
        lastPoint: Point
    ) -> PathFigure {
        var pathGeometry: PathGeometry
        if collection.size > 0,
            let castedLast = collection.getAt(collection.size - 1) as? PathGeometry
        {
            pathGeometry = castedLast
        } else {
            pathGeometry = PathGeometry()
            collection.append(pathGeometry)
        }

        var figure: PathFigure
        if pathGeometry.figures.size > 0 {
            // Note: the if check and force-unwrap is necessary. You can't do an `if let`
            // here because PathFigureCollection uses unsigned integers for its indices so
            // `size - 1` would underflow (causing a fatalError) if it's empty.
            figure = pathGeometry.figures.getAt(pathGeometry.figures.size - 1)!
        } else {
            figure = PathFigure()
            figure.startPoint = lastPoint
            pathGeometry.figures.append(figure)
        }

        return figure
    }

    func applyActions(_ actions: [SwiftCrossUI.Path.Action], to geometry: WinUI.GeometryCollection)
    {
        var lastPoint = Point(x: 0.0, y: 0.0)

        for action in actions {
            switch action {
                case .moveTo(let point):
                    lastPoint = Point(x: Float(point.x), y: Float(point.y))

                    if geometry.size > 0,
                        let pathGeometry = geometry.getAt(geometry.size - 1) as? PathGeometry,
                        pathGeometry.figures.size > 0
                    {
                        let figure = pathGeometry.figures.getAt(pathGeometry.figures.size - 1)!
                        if figure.segments.size > 0 {
                            let newFigure = PathFigure()
                            newFigure.startPoint = lastPoint
                            pathGeometry.figures.append(newFigure)
                        } else {
                            figure.startPoint = lastPoint
                        }
                    }
                case .lineTo(let point):
                    let wfPoint = Point(x: Float(point.x), y: Float(point.y))
                    defer { lastPoint = wfPoint }

                    let figure = requirePathFigure(geometry, lastPoint: lastPoint)

                    let segment = LineSegment()
                    segment.point = wfPoint
                    figure.segments.append(segment)
                case .quadCurve(let control, let end):
                    let wfControl = Point(x: Float(control.x), y: Float(control.y))
                    let wfEnd = Point(x: Float(end.x), y: Float(end.y))
                    defer { lastPoint = wfEnd }

                    let figure = requirePathFigure(geometry, lastPoint: lastPoint)

                    let segment = QuadraticBezierSegment()
                    segment.point1 = wfControl
                    segment.point2 = wfEnd
                    figure.segments.append(segment)
                case .cubicCurve(let control1, let control2, let end):
                    let wfControl1 = Point(x: Float(control1.x), y: Float(control1.y))
                    let wfControl2 = Point(x: Float(control2.x), y: Float(control2.y))
                    let wfEnd = Point(x: Float(end.x), y: Float(end.y))
                    defer { lastPoint = wfEnd }

                    let figure = requirePathFigure(geometry, lastPoint: lastPoint)

                    let segment = BezierSegment()
                    segment.point1 = wfControl1
                    segment.point2 = wfControl2
                    segment.point3 = wfEnd
                    figure.segments.append(segment)
                case .rectangle(let rect):
                    let rectGeo = RectangleGeometry()
                    rectGeo.rect = Rect(
                        x: Float(rect.x),
                        y: Float(rect.y),
                        width: Float(rect.width),
                        height: Float(rect.height)
                    )
                    geometry.append(rectGeo)
                case .circle(let center, let radius):
                    let ellipse = EllipseGeometry()
                    ellipse.radiusX = radius
                    ellipse.radiusY = radius
                    ellipse.center = Point(x: Float(center.x), y: Float(center.y))
                    geometry.append(ellipse)
                case .arc(
                    let center,
                    let radius,
                    let startAngle,
                    let endAngle,
                    let clockwise
                ):
                    let startPoint = Point(
                        x: Float(center.x + radius * cos(startAngle)),
                        y: Float(center.y + radius * sin(startAngle))
                    )
                    let endPoint = Point(
                        x: Float(center.x + radius * cos(endAngle)),
                        y: Float(center.y + radius * sin(endAngle))
                    )
                    defer { lastPoint = endPoint }

                    let figure = requirePathFigure(geometry, lastPoint: lastPoint)

                    if startPoint != lastPoint {
                        if figure.segments.size > 0 {
                            let connector = LineSegment()
                            connector.point = startPoint
                            figure.segments.append(connector)
                        } else {
                            figure.startPoint = startPoint
                        }
                    }

                    let segment = ArcSegment()

                    if clockwise {
                        if startAngle < endAngle {
                            segment.isLargeArc = (endAngle - startAngle > .pi)
                        } else {
                            segment.isLargeArc = (startAngle - endAngle < .pi)
                        }
                        segment.sweepDirection = .clockwise
                    } else {
                        if startAngle < endAngle {
                            segment.isLargeArc = (endAngle - startAngle < .pi)
                        } else {
                            segment.isLargeArc = (startAngle - endAngle > .pi)
                        }
                        segment.sweepDirection = .counterclockwise
                    }

                    segment.point = endPoint
                    segment.size = Size(width: Float(radius), height: Float(radius))

                    figure.segments.append(segment)
                case .transform(let transform):
                    let matrixTransform = MatrixTransform()
                    matrixTransform.matrix = Matrix(
                        m11: transform.linearTransform.x,
                        m12: transform.linearTransform.z,
                        m21: transform.linearTransform.y,
                        m22: transform.linearTransform.w,
                        offsetX: transform.translation.x,
                        offsetY: transform.translation.y
                    )

                    for case let geo? in geometry {
                        if geo.transform == nil {
                            geo.transform = matrixTransform
                        } else if let group = geo.transform as? TransformGroup {
                            group.children.append(matrixTransform)
                        } else {
                            let group = TransformGroup()
                            group.children.append(geo.transform)
                            group.children.append(matrixTransform)
                            geo.transform = group
                        }
                    }

                    if geometry.size > 0,
                        let pathGeometry = geometry.getAt(geometry.size - 1) as? PathGeometry,
                        pathGeometry.figures.contains(where: { ($0?.segments.size ?? 0) > 0 })
                    {
                        // Start a new PathGeometry so that transforms don't apply going forward
                        geometry.append(PathGeometry())
                    }
                case .subpath(let actions):
                    let subGeo = GeometryGroup()
                    applyActions(actions, to: subGeo.children)
                    geometry.append(subGeo)
            }
        }
    }

    public func renderPath(
        _ path: Path,
        container: Widget,
        strokeColor: SwiftCrossUI.Color,
        fillColor: SwiftCrossUI.Color,
        overrideStrokeStyle: StrokeStyle?
    ) {
        let winUiPath = container as! WinUI.Path
        let strokeStyle = overrideStrokeStyle ?? path.strokeStyle!

        winUiPath.fill = WinUI.SolidColorBrush(fillColor.uwpColor)
        winUiPath.stroke = WinUI.SolidColorBrush(strokeColor.uwpColor)
        winUiPath.strokeThickness = strokeStyle.width

        switch strokeStyle.cap {
            case .butt:
                winUiPath.strokeStartLineCap = .flat
                winUiPath.strokeEndLineCap = .flat
            case .round:
                winUiPath.strokeStartLineCap = .round
                winUiPath.strokeEndLineCap = .round
            case .square:
                winUiPath.strokeStartLineCap = .square
                winUiPath.strokeEndLineCap = .square
        }

        switch strokeStyle.join {
            case .miter(let limit):
                winUiPath.strokeMiterLimit = limit
                winUiPath.strokeLineJoin = .miter
            case .round:
                winUiPath.strokeLineJoin = .round
            case .bevel:
                winUiPath.strokeLineJoin = .bevel
        }

        winUiPath.data = path.group
    }

    // public func createTable(rows: Int, columns: Int) -> Widget {
    //     let grid = Grid()
    //     grid.columnSpacing = 10
    //     grid.rowSpacing = 10
    //     for _ in 0..<rows {
    //         let rowDefinition = RowDefinition()
    //         rowDefinition.height = GridLength(value: 0, gridUnitType: .auto)
    //         grid.rowDefinitions.append(rowDefinition)
    //     }

    //     for _ in 0..<columns {
    //         let columnDefinition = ColumnDefinition()
    //         columnDefinition.width = GridLength(value: 0, gridUnitType: .auto)
    //         grid.columnDefinitions.append(columnDefinition)
    //     }
    //     return grid
    // }

    // public func setRowCount(ofTable table: Widget, to rows: Int) {
    //     let grid = table as! Grid
    //     grid.rowDefinitions.clear()
    //     for _ in 0..<rows {
    //         let rowDefinition = RowDefinition()
    //         rowDefinition.height = GridLength(value: 0, gridUnitType: .auto)
    //         grid.rowDefinitions.append(rowDefinition)
    //     }
    // }

    // public func setColumnCount(ofTable table: Widget, to columns: Int) {
    //     let grid = table as! Grid
    //     grid.columnDefinitions.clear()
    //     for _ in 0..<columns {
    //         let columnDefinition = ColumnDefinition()
    //         columnDefinition.width = GridLength(value: 0, gridUnitType: .auto)
    //         grid.columnDefinitions.append(columnDefinition)
    //     }
    // }

    // public func setCell(at position: CellPosition, inTable table: Widget, to widget: Widget) {
    //     let grid = table as! Grid
    //     Grid.setColumn(widget, Int32(position.column))
    //     Grid.setRow(widget, Int32(position.row))
    //     grid.children.append(widget)
    // }
}

extension SwiftCrossUI.Color {
    var uwpColor: UWP.Color {
        UWP.Color(
            a: UInt8((alpha * Float(UInt8.max)).rounded()),
            r: UInt8((red * Float(UInt8.max)).rounded()),
            g: UInt8((green * Float(UInt8.max)).rounded()),
            b: UInt8((blue * Float(UInt8.max)).rounded())
        )
    }

    init(uwpColor: UWP.Color) {
        self.init(
            Float(uwpColor.r) / Float(UInt8.max),
            Float(uwpColor.g) / Float(UInt8.max),
            Float(uwpColor.b) / Float(UInt8.max),
            Float(uwpColor.a) / Float(UInt8.max)
        )
    }
}

extension EnvironmentValues {
    var winUIFontSize: Double {
        switch font {
            case .system(let size, _, _):
                Double(size)
        }
    }

    var winUIFontWeight: UInt16 {
        switch font {
            case .system(_, let weight, _):
                switch weight {
                    case .thin:
                        100
                    case .ultraLight:
                        200
                    case .light:
                        300
                    case .regular, .none:
                        400
                    case .medium:
                        500
                    case .semibold:
                        600
                    case .bold:
                        700
                    case .black:
                        900
                    case .heavy:
                        900
                }
        }

    }

    var winUIForegroundBrush: WinUI.Brush {
        let brush = SolidColorBrush()
        brush.color = suggestedForegroundColor.uwpColor
        return brush
    }

    func apply(to control: WinUI.Control) {
        control.fontSize = winUIFontSize
        control.fontWeight.weight = winUIFontWeight
        control.foreground = winUIForegroundBrush
    }

    func apply(to textBlock: WinUI.TextBlock) {
        textBlock.fontSize = winUIFontSize
        textBlock.fontWeight.weight = winUIFontWeight
        textBlock.foreground = winUIForegroundBrush
    }
}

final class CustomComboBox: ComboBox {
    var options: [String] = []
    var onChangeSelection: ((Int?) -> Void)?
    var actualForegroundColor: UWP.Color = UWP.Color(a: 255, r: 0, g: 0, b: 0)
}

final class CustomSplitView: SplitView {
    var sidebarResizeHandler: (() -> Void)?
}

final class TapGestureTarget: WinUI.Canvas {
    var clickHandler: (() -> Void)?
    var child: WinUI.FrameworkElement?
}

class SwiftIInitializeWithWindow: WindowsFoundation.IUnknown {
    override class var IID: WindowsFoundation.IID {
        WindowsFoundation.IID(
            Data1: 0x3E68_D4BD,
            Data2: 0x7135,
            Data3: 0x4D10,
            Data4: (0x80, 0x18, 0x9F, 0xB6, 0xD9, 0xF3, 0x3F, 0xA1)
        )
    }

    func initialize(with hwnd: HWND) throws {
        _ = try perform(as: IInitializeWithWindow.self) { pThis in
            try CHECKED(pThis.pointee.lpVtbl.pointee.Initialize(pThis, hwnd))
        }
    }
}

public class CustomWindow: WinUI.Window {
    /// Hardcoded menu bar height from MenuBar_themeresources.xaml in the
    /// microsoft-ui-xaml repository.
    static let menuBarHeight = 0

    var menuBar = WinUI.MenuBar()
    var child: WinUIBackend.Widget?
    var grid: WinUI.Grid
    var cachedAppWindow: WinAppSDK.AppWindow!

    var scaleFactor: Double {
        // I'm leaving this code here for future travellers. Be warned that this always
        // seems to return 100% even if the scale factor is set to 125% in settings.
        // Perhaps it's only the device's built-in default scaling? But that seems pretty
        // useless, and isn't what the docs seem to imply.
        //
        //   var deviceScaleFactor = SCALE_125_PERCENT
        //   _ = GetScaleFactorForMonitor(monitor, &deviceScaleFactor)

        let hwnd = cachedAppWindow.getHWND()!
        let monitor = MonitorFromWindow(hwnd, DWORD(bitPattern: MONITOR_DEFAULTTONEAREST))!

        var x: UINT = 0
        var y: UINT = 0
        let result = GetDpiForMonitor(monitor, MDT_EFFECTIVE_DPI, &x, &y)

        let windowScaleFactor: Double
        if result == S_OK {
            windowScaleFactor = Double(x) / Double(USER_DEFAULT_SCREEN_DPI)
        } else {
            print("Warning: Failed to get window scale factor, defaulting to 1.0")
            windowScaleFactor = 1
        }

        return windowScaleFactor
    }

    public override init() {
        grid = WinUI.Grid()

        super.init()

        let menuBarRowDefinition = WinUI.RowDefinition()
        menuBarRowDefinition.height = WinUI.GridLength(
            value: Double(Self.menuBarHeight),
            gridUnitType: .pixel
        )
        let contentRowDefinition = WinUI.RowDefinition()
        grid.rowDefinitions.append(menuBarRowDefinition)
        grid.rowDefinitions.append(contentRowDefinition)
        grid.children.append(menuBar)
        WinUI.Grid.setRow(menuBar, 0)
        self.content = grid

        // Caching appWindow is apparently a good idea in terms of performance:
        // https://github.com/thebrowsercompany/swift-winrt/issues/199#issuecomment-2611006020
        cachedAppWindow = appWindow
    }

    public func setChild(_ child: WinUIBackend.Widget) {
        self.child = child
        grid.children.append(child)
        WinUI.Grid.setRow(child, 1)
    }
}

public final class GeometryGroupHolder {
    var group = GeometryGroup()
    var strokeStyle: StrokeStyle?
}
