import SwiftCrossUI
import UWP
import WinAppSDK
import WinUI
import WindowsFoundation

class WinRTApplication: SwiftApplication {
    static var callback: () -> Void = {}

    required init() {
        super.init()
    }

    override public func onLaunched(_: WinUI.LaunchActivatedEventArgs) {
        Self.callback()
    }
}

public struct WinUIBackend: AppBackend {
    public typealias Window = WinUI.Window
    public typealias Widget = WinUI.FrameworkElement

    private class InternalState {
        var buttonClickActions: [ObjectIdentifier: () -> Void] = [:]
        var toggleClickActions: [ObjectIdentifier: (Bool) -> Void] = [:]
        var switchClickActions: [ObjectIdentifier: (Bool) -> Void] = [:]
        var sliderChangeActions: [ObjectIdentifier: (Double) -> Void] = [:]
        var pickerChangeActions: [ObjectIdentifier: (Int?) -> Void] = [:]
        var textFieldChangeActions: [ObjectIdentifier: (String) -> Void] = [:]
    }

    private var internalState: InternalState

    public init(appIdentifier _: String) {
        internalState = InternalState()
    }

    public func runMainLoop(_ callback: @escaping () -> Void) {
        WinRTApplication.callback = callback
        WinRTApplication.main()
    }

    public func createWindow(withDefaultSize size: SwiftCrossUI.Size?) -> Window {
        let window = Window()

        if let size {
            try! window.appWindow.resizeClient(
                SizeInt32(width: Int32(size.width), height: Int32(size.height)))
        }
        return window
    }

    public func setTitle(ofWindow window: Window, to title: String) {
        window.title = title
    }

    public func setResizability(ofWindow window: Window, to value: Bool) {
        (window.appWindow.presenter as! OverlappedPresenter).isResizable = value
    }

    public func setChild(ofWindow window: Window, to widget: Widget) {
        window.content = widget
    }

    public func show(window: Window) {
        try! window.activate()
    }

    public func runInMainThread(action: @escaping () -> Void) {
        action()
    }

    public func show(widget _: Widget) {}

    public func createVStack() -> Widget {
        Grid()
    }

    public func setChildren(_ children: [Widget], ofVStack container: Widget) {
        let grid = container as! Grid
        for child in children {
            let rowDefinition = RowDefinition()
            if child.name != "Spacer" {
                rowDefinition.height = GridLength(value: 1, gridUnitType: .auto)
            }
            Grid.setRow(child, Int32(grid.rowDefinitions.count))
            grid.rowDefinitions.append(rowDefinition)
            grid.children.append(child)
        }
    }

    public func setSpacing(ofVStack widget: Widget, to spacing: Int) {
        (widget as! Grid).rowSpacing = Double(spacing)
    }

    public func createHStack() -> Widget {
        Grid()
    }

    public func setChildren(_ children: [Widget], ofHStack container: Widget) {
        let grid = container as! Grid
        for child in children {
            let columnDefinition = ColumnDefinition()
            if child.name != "Spacer" {
                columnDefinition.width = GridLength(value: 1, gridUnitType: .auto)
            }
            Grid.setColumn(child, Int32(grid.columnDefinitions.count))
            grid.columnDefinitions.append(columnDefinition)
            grid.children.append(child)
        }
    }

    public func setSpacing(ofHStack widget: Widget, to spacing: Int) {
        (widget as! Grid).columnSpacing = Double(spacing)
    }

    public func createSingleChildContainer() -> Widget {
        Frame()
    }

    public func setChild(ofSingleChildContainer container: Widget, to widget: Widget?) {
        (container as! Frame).content = widget
    }

    public func createPaddingContainer(for child: Widget) -> Widget {
        let border = Border()
        border.child = child
        return border
    }

    public func setPadding(
        ofPaddingContainer container: Widget, top: Int, bottom: Int, leading: Int, trailing: Int
    ) {
        (container as! Border).borderThickness = .init(
            left: Double(leading),
            top: Double(top),
            right: Double(trailing),
            bottom: Double(bottom)
        )
    }

    public func createLayoutTransparentStack() -> Widget {
        StackPanel()
    }

    public func addChild(_ child: Widget, toLayoutTransparentStack container: Widget) {
        (container as! StackPanel).children.append(child)
    }

    public func removeChild(_ child: UIElement, fromLayoutTransparentStack container: UIElement) {
        let container = (container as! StackPanel)
        let index = container.children.index(of: child)
        if let index {
            let _ = container.children.remove(at: index)
        }
    }

    public func updateLayoutTransparentStack(_: Widget) {}

    public func createScrollContainer(for child: Widget) -> Widget {
        let scrollViewer = ScrollViewer()
        scrollViewer.content = child
        return scrollViewer
    }

    public func createTextView() -> Widget {
        TextBlock()
    }

    public func updateTextView(_ textView: Widget, content: String, shouldWrap _: Bool) {
        (textView as! TextBlock).text = content
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

    public func updateButton(_ button: Widget, label: String, action: @escaping () -> Void) {
        (button as! WinUI.Button).content = label
        internalState.buttonClickActions[ObjectIdentifier(button)] = action
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
        return slider
    }

    public func updateSlider(
        _ slider: Widget, minimum: Double, maximum: Double, decimalPlaces _: Int,
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
        let picker = ComboBox()
        picker.selectionChanged.addHandler { [weak internalState] _, _ in
            guard let internalState = internalState else {
                return
            }
            internalState.pickerChangeActions[ObjectIdentifier(picker)]?(Int(picker.selectedIndex))
        }
        return picker
    }

    public func updatePicker(
        _ picker: Widget, options: [String], onChange: @escaping (Int?) -> Void
    ) {
        let picker = picker as! ComboBox
        guard options.count > 0 else { return }
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
        internalState.pickerChangeActions[ObjectIdentifier(picker)] = onChange
    }

    public func setSelectedOption(ofPicker picker: Widget, to selectedOption: Int?) {
        let picker = picker as! ComboBox
        picker.selectedIndex = Int32(selectedOption ?? 0)
    }

    public func createStyleContainer(for child: Widget) -> Widget {
        let panel = StackPanel()
        panel.children.append(child)
        panel.name = "StyleContainer"
        return panel
    }

    private func resolveTargetElement(of widget: Widget) -> Widget {
        if let content = (widget as? Frame)?.content as? Widget {
            return resolveTargetElement(of: content)
        } else if let content = (widget as? ScrollViewer)?.content as? Widget {
            return resolveTargetElement(of: content)
        } else {
            return widget
        }
    }

    public func setForegroundColor(ofStyleContainer container: Widget, to color: SwiftCrossUI.Color)
    {
        // Note: this works, but it's not optimal since we are iterating on all the childrens looking for
        let container = container as? StackPanel ?? container as! Grid
        let style = Style(.init(name: "TextBlock", kind: .primitive))
        style.setters.append(
            Setter(
                TextBlock.foregroundProperty,
                "sc#\(color.alpha),\(color.red),\(color.green),\(color.blue)"))

        // Since we are drilling down the tree if we encounter another style container with a foreground color
        // already set we stop here to avoid overwriting a more specific style that has been set.
        // Adding the style to the resources does nothing in practice, is just a way of keeping track if we need
        // to update that widget
        if container.name == "StyleContainer" {
            if container.resources.hasKey("ForegroundColor") {
                return
            } else {
                _ = container.resources.insert("ForegroundColor", style)
            }
        }

        for children in container.children {
            let targetElement: Widget = resolveTargetElement(of: children as! Widget)
            if let textBlock = targetElement as? TextBlock {
                textBlock.style = style
            } else if let stackPanel = targetElement as? StackPanel {
                setForegroundColor(ofStyleContainer: stackPanel, to: color)
            } else if let grid = targetElement as? Grid {
                setForegroundColor(ofStyleContainer: grid, to: color)
            }
        }
    }

    public func createTextField() -> Widget {
        let textField = TextBox()
        textField.textChanged.addHandler { [weak internalState] _, _ in
            guard let internalState = internalState else {
                return
            }
            internalState.textFieldChangeActions[ObjectIdentifier(textField)]?(textField.text)
        }
        return textField
    }

    public func updateTextField(
        _ textField: Widget, placeholder: String, onChange: @escaping (String) -> Void
    ) {
        let textField = (textField as! TextBox)
        textField.placeholderText = placeholder
        internalState.textFieldChangeActions[ObjectIdentifier(textField)] = onChange
    }

    public func setContent(ofTextField textField: Widget, to content: String) {
        (textField as! TextBox).text = content
    }

    public func getContent(ofTextField textField: Widget) -> String {
        (textField as! TextBox).text
    }

    public func createImageView(filePath: String) -> Widget {
        let image = Image()
        let bitMapImage = BitmapImage()
        bitMapImage.uriSource = Uri(filePath)
        image.source = bitMapImage
        image.minHeight = 5
        return image
    }

    public func updateImageView(_ imageView: Widget, filePath: String) {
        let bitMapImage = BitmapImage()
        bitMapImage.uriSource = Uri(filePath)
        (imageView as! WinUI.Image).source = bitMapImage
    }

    public func createOneOfContainer() -> Widget {
        let frame = Frame()
        frame.contentTransitions = TransitionCollection()
        frame.contentTransitions.append(NavigationThemeTransition())
        return frame
    }

    public func addChild(_ child: Widget, toOneOfContainer container: Widget) {
        let frame = container as! Frame
        frame.content = child
        // frame.contentTransitions.append(Transition(composing: child, createCallback: {})
    }

    public func setVisibleChild(ofOneOfContainer container: Widget, to child: Widget) {
        // TODO: the frame.navigate method should allow to change the content of the frame
        // with the specified animation (NavigationThemeTransition) but I fail to understant
        // how to pass the child widget to it, so for now it just set the new content
        let frame = container as! Frame
        frame.content = child
        // let _ = try! frame.navigate(TypeName(name: child.accessKey, kind: .custom))
    }

    public func removeChild(_: Widget, fromOneOfContainer _: Widget) {}

    public func createSpacer() -> Widget {
        StackPanel()
    }

    public func updateSpacer(
        _ spacer: Widget, expandHorizontally: Bool, expandVertically: Bool, minSize: Int
    ) {
        let stackPanel = spacer as! StackPanel
        if expandHorizontally {
            stackPanel.minWidth = Double(minSize)
        }
        if expandVertically {
            stackPanel.minHeight = Double(minSize)
        }
    }

    public func createSplitView(leadingChild: Widget, trailingChild: Widget) -> Widget {
        let grid = Grid()
        let leadingColumn = ColumnDefinition()
        let trailingColumn = ColumnDefinition()
        leadingColumn.width = GridLength(value: 1, gridUnitType: .star)
        trailingColumn.width = GridLength(value: 1, gridUnitType: .star)
        grid.columnDefinitions.append(leadingColumn)
        grid.columnDefinitions.append(trailingColumn)
        Grid.setColumn(leadingChild, 0)
        Grid.setColumn(trailingChild, 1)
        grid.children.append(leadingChild)
        grid.children.append(trailingChild)
        return grid
    }

    public func updateSplitView(_ splitView: Widget) {}

    public func getInheritedOrientation(of _: Widget) -> InheritedOrientation? {
        InheritedOrientation.vertical
    }

    public func createFrameContainer(for child: Widget) -> Widget {
        let frame = Frame()
        frame.content = child
        return frame
    }

    public func updateFrameContainer(_ container: Widget, minWidth: Int, minHeight: Int) {
        let frame = container as! Frame
        frame.minWidth = Double(minWidth)
        frame.minHeight = Double(minHeight)
    }

    public func createTable(rows: Int, columns: Int) -> Widget {
        let grid = Grid()
        grid.columnSpacing = 10
        grid.rowSpacing = 10
        for _ in 0..<rows {
            let rowDefinition = RowDefinition()
            rowDefinition.height = GridLength(value: 0, gridUnitType: .auto)
            grid.rowDefinitions.append(rowDefinition)
        }

        for _ in 0..<columns {
            let columnDefinition = ColumnDefinition()
            columnDefinition.width = GridLength(value: 0, gridUnitType: .auto)
            grid.columnDefinitions.append(columnDefinition)
        }
        return grid
    }

    public func setRowCount(ofTable table: Widget, to rows: Int) {
        let grid = table as! Grid
        grid.rowDefinitions.clear()
        for _ in 0..<rows {
            let rowDefinition = RowDefinition()
            rowDefinition.height = GridLength(value: 0, gridUnitType: .auto)
            grid.rowDefinitions.append(rowDefinition)
        }
    }

    public func setColumnCount(ofTable table: Widget, to columns: Int) {
        let grid = table as! Grid
        grid.columnDefinitions.clear()
        for _ in 0..<columns {
            let columnDefinition = ColumnDefinition()
            columnDefinition.width = GridLength(value: 0, gridUnitType: .auto)
            grid.columnDefinitions.append(columnDefinition)
        }
    }

    public func setCell(at position: CellPosition, inTable table: Widget, to widget: Widget) {
        let grid = table as! Grid
        Grid.setColumn(widget, Int32(position.column))
        Grid.setRow(widget, Int32(position.row))
        grid.children.append(widget)
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
        (toggle as! ToggleButton).content = label
        internalState.toggleClickActions[ObjectIdentifier(toggle)] = onChange
    }

    public func setState(ofToggle toggle: Widget, to state: Bool) {
        (toggle as! ToggleButton).isChecked = state
    }

    public func createSwitch() -> Widget {
        let toggleSwitch = ToggleSwitch()
        toggleSwitch.onContent = ""
        toggleSwitch.offContent = ""
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
    }

    public func setState(ofSwitch switchWidget: Widget, to state: Bool) {
        (switchWidget as! ToggleSwitch).isOn = state
    }
}
