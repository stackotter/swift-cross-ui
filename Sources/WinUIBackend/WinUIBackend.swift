import CWinRT
import Foundation
import SwiftCrossUI
import UWP
import WinAppSDK
import WinUI
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
    static var callback: (() -> Void)?

    override func onLaunched(_ args: WinUI.LaunchActivatedEventArgs) {
        Self.callback?()
    }
}

public struct WinUIBackend: AppBackend {
    public typealias Window = WinUI.Window
    public typealias Widget = WinUI.FrameworkElement
    public typealias Menu = Void
    public typealias Alert = Void

    public let defaultTableRowContentHeight = 20
    public let defaultTableCellVerticalPadding = 4
    public let defaultPaddingAmount = 10

    public var scrollBarWidth: Int {
        fatalError("TODO")
    }

    private class InternalState {
        var buttonClickActions: [ObjectIdentifier: () -> Void] = [:]
        var toggleClickActions: [ObjectIdentifier: (Bool) -> Void] = [:]
        var switchClickActions: [ObjectIdentifier: (Bool) -> Void] = [:]
        var sliderChangeActions: [ObjectIdentifier: (Double) -> Void] = [:]
        var textFieldChangeActions: [ObjectIdentifier: (String) -> Void] = [:]
        var textFieldSubmitActions: [ObjectIdentifier: () -> Void] = [:]
        var dispatcherQueue: WinAppSDK.DispatcherQueue?
    }

    private var internalState: InternalState

    public init() {
        internalState = InternalState()
    }

    public func runMainLoop(_ callback: @escaping () -> Void) {
        WinUIApplication.callback = {
            callback()
        }
        WinUIApplication.main()
    }

    public func createWindow(withDefaultSize size: SIMD2<Int>?) -> Window {
        let window = Window()

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
            Int(size.height)
        )
        return out
    }

    public func setSize(ofWindow window: Window, to newSize: SIMD2<Int>) {
        let size = UWP.SizeInt32(
            width: Int32(newSize.x),
            height: Int32(newSize.y)
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
                Int(args!.size.height.rounded(.awayFromZero))
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
        window.content = widget
        try! widget.updateLayout()
    }

    public func show(window: Window) {
        try! window.activate()
    }

    public func activate(window: Window) {
        try! window.activate()
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

    public func setApplicationMenu(_ submenus: [ResolvedMenu.Submenu]) {
        missing("setApplicationMenu(_:) implementation")
    }

    public func computeRootEnvironment(
        defaultEnvironment: EnvironmentValues
    ) -> EnvironmentValues {
        return defaultEnvironment
    }

    private func fatalError(_ message: String) -> Never {
        print(message)
        fflush(stdout)
        Foundation.exit(1)
    }

    public func setRootEnvironmentChangeHandler(to action: @escaping () -> Void) {
        print("Implement set root environment change handler")
        // TODO
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
        try! container.updateLayout()
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

        let allocation =
            proposedFrame.map(WindowsFoundation.Size.init(_:))
            ?? WindowsFoundation.Size(
                width: .infinity,
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
        textBlock.textWrapping = __x_ABI_CMicrosoft_CUI_CXaml_CTextWrapping_Wrap
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
    }

    // public func createScrollContainer(for child: Widget) -> Widget {
    //     let scrollViewer = ScrollViewer()
    //     scrollViewer.content = child
    //     return scrollViewer
    // }

    public func createSlider() -> Widget {
        let slider = Slider()
        slider.valueChanged.addHandler { [weak internalState] _, event in
            guard let internalState = internalState else {
                return
            }
            internalState.sliderChangeActions[ObjectIdentifier(slider)]?(
                Double(event?.newValue ?? 0))
        }
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
        missing("picker environment handling")

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

            if event?.key == __x_ABI_CWindows_CSystem_CVirtualKey_Enter {
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

        missing("text field environment handling")
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

        // Convert RGBA to BGRA in-place.
        for i in 0..<(width * height) {
            let offset = i * 4
            let tmp = buffer[offset]
            buffer[offset] = buffer[offset + 2]
            buffer[offset + 2] = tmp
        }

        imageView.source = bitmap
    }

    public func createSplitView(leadingChild: Widget, trailingChild: Widget) -> Widget {
        let splitView = CustomSplitView()
        splitView.pane = leadingChild
        splitView.content = trailingChild
        splitView.isPaneOpen = true
        splitView.displayMode = __x_ABI_CMicrosoft_CUI_CXaml_CControls_CSplitViewDisplayMode_Inline
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

    // public func createToggle() -> Widget {
    //     let toggle = ToggleButton()
    //     toggle.click.addHandler { [weak internalState] _, _ in
    //         guard let internalState = internalState else {
    //             return
    //         }
    //         internalState.toggleClickActions[ObjectIdentifier(toggle)]?(toggle.isChecked ?? false)
    //     }
    //     return toggle
    // }

    // public func updateToggle(_ toggle: Widget, label: String, onChange: @escaping (Bool) -> Void) {
    //     (toggle as! ToggleButton).content = label
    //     internalState.toggleClickActions[ObjectIdentifier(toggle)] = onChange
    // }

    // public func setState(ofToggle toggle: Widget, to state: Bool) {
    //     (toggle as! ToggleButton).isChecked = state
    // }

    // public func createSwitch() -> Widget {
    //     let toggleSwitch = ToggleSwitch()
    //     toggleSwitch.onContent = ""
    //     toggleSwitch.offContent = ""
    //     toggleSwitch.toggled.addHandler { [weak internalState] _, _ in
    //         guard let internalState = internalState else {
    //             return
    //         }
    //         internalState.switchClickActions[ObjectIdentifier(toggleSwitch)]?(toggleSwitch.isOn)
    //     }
    //     return toggleSwitch
    // }

    // public func updateSwitch(_ toggleSwitch: Widget, onChange: @escaping (Bool) -> Void) {
    //     internalState.switchClickActions[ObjectIdentifier(toggleSwitch)] = onChange
    // }

    // public func setState(ofSwitch switchWidget: Widget, to state: Bool) {
    //     (switchWidget as! ToggleSwitch).isOn = state
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

extension WindowsFoundation.Size {
    init(_ other: SIMD2<Int>) {
        self.init(
            width: Float(other.x),
            height: Float(other.y)
        )
    }
}
