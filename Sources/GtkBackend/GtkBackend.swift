import CGtk
import Foundation
import Gtk
import SwiftCrossUI

extension App {
    public typealias Backend = GtkBackend
}

extension SwiftCrossUI.Color {
    public var gtkColor: Gtk.Color {
        return Gtk.Color(red, green, blue, alpha)
    }
}

public final class GtkBackend: AppBackend {
    public typealias Window = Gtk.Window
    public typealias Widget = Gtk.Widget

    public let defaultTableRowContentHeight = 20
    public let defaultTableCellVerticalPadding = 4
    public let defaultPaddingAmount = 10
    public let scrollBarWidth = 0

    var gtkApp: Application

    /// A window to be returned on the next call to ``GtkBackend/createWindow``.
    /// This is necessary because Gtk creates a root window no matter what, and
    /// this needs to be returned on the first call to `createWindow`.
    var precreatedWindow: Window?

    /// Creates a backend instance using the default app identifier `com.example.SwiftCrossUIApp`.
    convenience public init() {
        self.init(appIdentifier: "com.example.SwiftCrossUIApp")
    }

    public init(appIdentifier: String) {
        gtkApp = Application(applicationId: appIdentifier)
    }

    public func runMainLoop(_ callback: @escaping () -> Void) {
        gtkApp.run { window in
            self.precreatedWindow = window
            callback()
        }
    }

    public func createWindow(withDefaultSize defaultSize: SIMD2<Int>?) -> Window {
        let window: Gtk.Window
        if let precreatedWindow = precreatedWindow {
            self.precreatedWindow = nil
            window = precreatedWindow
        } else {
            window = Gtk.Window()
        }

        if let defaultSize = defaultSize {
            window.defaultSize = Size(
                width: defaultSize.x,
                height: defaultSize.y
            )
        }

        return window
    }

    public func setTitle(ofWindow window: Window, to title: String) {
        window.title = title
    }

    public func setResizability(ofWindow window: Window, to resizable: Bool) {
        window.resizable = resizable
    }

    public func setChild(ofWindow window: Window, to child: Widget) {
        let container = wrapInCustomRootContainer(child)
        window.setChild(container)
    }

    public func size(ofWindow window: Window) -> SIMD2<Int> {
        let child = window.getChild() as! CustomRootWidget
        let size = child.getSize()
        return SIMD2(size.width, size.height)
    }

    public func setSize(ofWindow window: Window, to newSize: SIMD2<Int>) {
        let child = window.getChild() as! CustomRootWidget
        let windowSize = window.defaultSize
        let childSize = child.getSize()
        let decorationsSize = SIMD2(
            windowSize.width - childSize.width,
            windowSize.height - childSize.height
        )
        window.size = Size(
            width: decorationsSize.x + newSize.x,
            height: decorationsSize.y + newSize.y
        )
        child.preemptAllocatedSize(allocatedWidth: newSize.x, allocatedHeight: newSize.y)
    }

    public func setMinimumSize(ofWindow window: Window, to minimumSize: SIMD2<Int>) {
        window.setMinimumSize(to: Size(width: minimumSize.x, height: minimumSize.y))
    }

    public func setResizeHandler(
        ofWindow window: Window,
        to action: @escaping (_ newSize: SIMD2<Int>) -> Void
    ) {
        let child = window.getChild() as! CustomRootWidget
        child.setResizeHandler { size in
            action(SIMD2(size.width, size.height))
        }
    }

    public func show(window: Window) {
        window.show()
    }

    class ThreadActionContext {
        var action: () -> Void

        init(action: @escaping () -> Void) {
            self.action = action
        }
    }

    public func runInMainThread(action: @escaping () -> Void) {
        let action = ThreadActionContext(action: action)
        g_idle_add_full(
            0,
            { context in
                guard let context = context else {
                    fatalError("Gtk action callback called without context")
                }

                let action = Unmanaged<ThreadActionContext>.fromOpaque(context)
                    .takeUnretainedValue()
                action.action()

                return 0
            },
            Unmanaged<ThreadActionContext>.passRetained(action).toOpaque(),
            { _ in }
        )
    }

    public func computeRootEnvironment(defaultEnvironment: Environment) -> Environment {
        defaultEnvironment
    }

    public func setRootEnvironmentChangeHandler(to action: @escaping () -> Void) {
        // TODO: React to theme changes
    }

    public func show(widget: Widget) {
        widget.show()
    }

    public func tag(widget: Widget, as tag: String) {
        widget.tag(as: tag)
    }

    // MARK: Containers

    public func createContainer() -> Widget {
        return Fixed()
    }

    public func removeAllChildren(of container: Widget) {
        let container = container as! Fixed
        container.removeAllChildren()
    }

    public func addChild(_ child: Widget, to container: Widget) {
        let container = container as! Fixed
        container.put(child, x: 0, y: 0)
    }

    public func setPosition(ofChildAt index: Int, in container: Widget, to position: SIMD2<Int>) {
        let container = container as! Fixed
        container.move(container.children[index], x: Double(position.x), y: Double(position.y))
    }

    public func removeChild(_ child: Widget, from container: Widget) {
        let container = container as! Fixed
        container.remove(child)
    }

    public func createColorableRectangle() -> Widget {
        return Fixed()
    }

    public func setColor(ofColorableRectangle widget: Widget, to color: SwiftCrossUI.Color) {
        widget.css.set(property: .backgroundColor(color.gtkColor))
    }

    public func setCornerRadius(of widget: Widget, to radius: Int) {
        widget.css.set(property: .cornerRadius(radius))
    }

    public func naturalSize(of widget: Widget) -> SIMD2<Int> {
        let currentSize = widget.getSizeRequest()
        widget.setSizeRequest(width: -1, height: -1)
        let (width, height) = widget.getNaturalSize()
        widget.setSizeRequest(width: currentSize.width, height: currentSize.height)
        return SIMD2(width, height)
    }

    public func setSize(of widget: Widget, to size: SIMD2<Int>) {
        widget.setSizeRequest(width: size.x, height: size.y)
    }

    public func createSplitView(leadingChild: Widget, trailingChild: Widget) -> Widget {
        let widget = Paned(orientation: .horizontal)
        let leadingContainer = wrapInCustomRootContainer(leadingChild)
        let trailingContainer = wrapInCustomRootContainer(trailingChild)

        widget.startChild = leadingContainer
        widget.endChild = trailingContainer
        widget.shrinkStartChild = false
        widget.shrinkEndChild = false

        widget.position = 200
        return widget
    }

    public func setResizeHandler(
        ofSplitView splitView: Widget,
        to action: @escaping (_ leadingWidth: Int, _ trailingWidth: Int) -> Void
    ) {
        let splitView = splitView as! Paned
        splitView.notifyPosition = { splitView in
            action(splitView.position, splitView.getNaturalSize().width - splitView.position)
        }
    }

    public func sidebarWidth(ofSplitView splitView: Widget) -> Int {
        let splitView = splitView as! Paned
        return splitView.position
    }

    public func setSidebarWidthBounds(
        ofSplitView splitView: Widget,
        minimum minimumWidth: Int,
        maximum maximumWidth: Int
    ) {
        let splitView = splitView as! Paned
        show(widget: splitView.startChild!)
        let width = splitView.getNaturalSize().width
        splitView.startChild?.setSizeRequest(width: minimumWidth, height: 0)
        splitView.endChild?.setSizeRequest(width: width - maximumWidth, height: 0)
    }

    public func createScrollContainer(for child: Widget) -> Widget {
        let scrollView = ScrolledWindow()
        scrollView.setChild(child)
        return scrollView
    }

    public func setScrollBarPresence(
        ofScrollContainer scrollView: Widget,
        hasVerticalScrollBar: Bool,
        hasHorizontalScrollBar: Bool
    ) {
        let scrollView = scrollView as! ScrolledWindow
        scrollView.setScrollBarPresence(
            hasVerticalScrollBar: hasVerticalScrollBar,
            hasHorizontalScrollBar: hasHorizontalScrollBar
        )
    }

    // MARK: Passive views

    public func createTextView() -> Widget {
        let label = Label(string: "")
        label.horizontalAlignment = .start
        return label
    }

    public func updateTextView(_ textView: Widget, content: String, environment: Environment) {
        let textView = textView as! Label
        textView.label = content
        textView.wrap = true
        textView.lineWrapMode = .wordCharacter
        textView.justify =
            switch environment.multilineTextAlignment {
                case .leading:
                    Justification.left
                case .center:
                    Justification.center
                case .trailing:
                    Justification.right
            }

        textView.css.clear()
        textView.css.set(properties: Self.cssProperties(for: environment))
    }

    public func size(
        of text: String,
        whenDisplayedIn textView: Widget,
        proposedFrame: SIMD2<Int>?,
        environment: Environment
    ) -> SIMD2<Int> {
        let pango = Pango(for: textView)
        let (width, height) = pango.getTextSize(
            text,
            proposedWidth: (proposedFrame?.x).map(Double.init),
            proposedHeight: nil
        )
        return SIMD2(width, height)
    }

    public func createImageView() -> Widget {
        let imageView = Gtk.Picture()
        imageView.keepAspectRatio = false
        imageView.canShrink = true
        return imageView
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
        guard dataHasChanged else {
            return
        }

        let imageView = imageView as! Gtk.Picture
        let buffer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: rgbaData.count)
        memcpy(buffer.baseAddress!, rgbaData, rgbaData.count)
        let pixbuf = gdk_pixbuf_new_from_data(
            buffer.baseAddress,
            GDK_COLORSPACE_RGB,
            1,
            8,
            Int32(width),
            Int32(height),
            Int32(width * 4),
            { buffer, _ in
                buffer?.deallocate()
            },
            nil
        )
        let texture = gdk_texture_new_for_pixbuf(pixbuf)!
        imageView.setPaintable(texture)
    }

    // private class Tables {
    //     var tableSizes: [ObjectIdentifier: (rows: Int, columns: Int)] = [:]
    // }

    // private let tables = Tables()

    // TODO: Implement tables
    // public func createTable(rows: Int, columns: Int) -> Widget {
    //     let widget = Grid()

    //     for i in 0..<rows {
    //         widget.insertRow(position: i)
    //     }

    //     for i in 0..<columns {
    //         widget.insertRow(position: i)
    //     }

    //     tables.tableSizes[ObjectIdentifier(widget)] = (rows: rows, columns: columns)

    //     widget.columnSpacing = 10
    //     widget.rowSpacing = 10

    //     return widget
    // }

    // public func setRowCount(ofTable table: Widget, to rows: Int) {
    //     let table = table as! Grid

    //     let rowDifference = rows - tables.tableSizes[ObjectIdentifier(table)]!.rows
    //     tables.tableSizes[ObjectIdentifier(table)]!.rows = rows
    //     if rowDifference < 0 {
    //         for _ in 0..<(-rowDifference) {
    //             table.removeRow(position: 0)
    //         }
    //     } else if rowDifference > 0 {
    //         for _ in 0..<rowDifference {
    //             table.insertRow(position: 0)
    //         }
    //     }

    // }

    // public func setColumnCount(ofTable table: Widget, to columns: Int) {
    //     let table = table as! Grid

    //     let columnDifference = columns - tables.tableSizes[ObjectIdentifier(table)]!.columns
    //     tables.tableSizes[ObjectIdentifier(table)]!.columns = columns
    //     if columnDifference < 0 {
    //         for _ in 0..<(-columnDifference) {
    //             table.removeColumn(position: 0)
    //         }
    //     } else if columnDifference > 0 {
    //         for _ in 0..<columnDifference {
    //             table.insertColumn(position: 0)
    //         }
    //     }

    // }

    // public func setCell(at position: CellPosition, inTable table: Widget, to widget: Widget) {
    //     let table = table as! Grid
    //     table.attach(
    //         child: widget,
    //         left: position.column,
    //         top: position.row,
    //         width: 1,
    //         height: 1
    //     )
    // }

    // MARK: Controls

    public func createButton() -> Widget {
        return Button()
    }

    public func updateButton(
        _ button: Widget,
        label: String,
        action: @escaping () -> Void,
        environment: Environment
    ) {
        // TODO: Update button label color using environment
        let button = button as! Gtk.Button
        button.label = label
        button.clicked = { _ in action() }
        button.css.clear()
        button.css.set(properties: Self.cssProperties(for: environment, isControl: true))
    }

    public func createToggle() -> Widget {
        return ToggleButton()
    }

    public func updateToggle(_ toggle: Widget, label: String, onChange: @escaping (Bool) -> Void) {
        (toggle as! ToggleButton).label = label
        (toggle as! Gtk.ToggleButton).toggled = { widget in
            onChange(widget.active)
        }
    }

    public func setState(ofToggle toggle: Widget, to state: Bool) {
        (toggle as! Gtk.ToggleButton).active = state
    }

    public func createSwitch() -> Widget {
        return Switch()
    }

    public func updateSwitch(_ switchWidget: Widget, onChange: @escaping (Bool) -> Void) {
        (switchWidget as! Gtk.Switch).notifyActive = { widget in
            onChange(widget.active)
        }
    }

    public func setState(ofSwitch switchWidget: Widget, to state: Bool) {
        (switchWidget as! Gtk.Switch).active = state
    }

    public func createSlider() -> Widget {
        let scale = Scale()
        scale.expandHorizontally = true
        return scale
    }

    public func updateSlider(
        _ slider: Widget,
        minimum: Double,
        maximum: Double,
        decimalPlaces: Int,
        onChange: @escaping (Double) -> Void
    ) {
        let slider = slider as! Scale
        slider.minimum = minimum
        slider.maximum = maximum
        slider.digits = decimalPlaces
        slider.valueChanged = { widget in
            onChange(widget.value)
        }
    }

    public func setValue(ofSlider slider: Widget, to value: Double) {
        (slider as! Scale).value = value
    }

    public func createTextField() -> Widget {
        return Entry()
    }

    public func updateTextField(
        _ textField: Widget,
        placeholder: String,
        environment: Environment,
        onChange: @escaping (String) -> Void
    ) {
        let textField = textField as! Entry
        textField.placeholderText = placeholder
        textField.changed = { widget in
            onChange(widget.text)
        }

        textField.css.clear()
        textField.css.set(properties: Self.cssProperties(for: environment, isControl: true))
    }

    public func setContent(ofTextField textField: Widget, to content: String) {
        (textField as! Entry).text = content
    }

    public func getContent(ofTextField textField: Widget) -> String {
        return (textField as! Entry).text
    }

    public func createPicker() -> Widget {
        return DropDown(strings: [])
    }

    public func updatePicker(
        _ picker: Widget,
        options: [String],
        environment: Environment,
        onChange: @escaping (Int?) -> Void
    ) {
        let picker = picker as! DropDown

        // Check whether the options need to be updated or not (avoiding unnecessary updates is
        // required to prevent an infinite loop caused by the onChange handler)
        var hasChanged = false
        for index in 0..<options.count {
            guard
                let item = gtk_string_list_get_string(picker.model, guint(index)),
                String(cString: item) == options[index]
            else {
                hasChanged = true
                break
            }
        }

        // picker.model could be longer than options
        if gtk_string_list_get_string(picker.model, guint(options.count)) != nil {
            hasChanged = true
        }

        // Apply the current text styles to the dropdown's labels
        var block = CSSBlock(forClass: picker.css.cssClass + " label")
        block.set(properties: Self.cssProperties(for: environment))
        picker.cssProvider.loadCss(from: block.stringRepresentation)

        guard hasChanged else {
            return
        }

        picker.model = gtk_string_list_new(
            UnsafePointer(
                options
                    .map({ UnsafePointer($0.unsafeUTF8Copy().baseAddress) })
                    .unsafeCopy()
                    .baseAddress
            )
        )

        picker.notifySelected = { picker in
            if picker.selected == GTK_INVALID_LIST_POSITION {
                onChange(nil)
            } else {
                onChange(picker.selected)
            }
        }
    }

    public func setSelectedOption(ofPicker picker: Widget, to selectedOption: Int?) {
        let picker = picker as! DropDown
        if selectedOption != picker.selected {
            picker.selected = selectedOption ?? Int(GTK_INVALID_LIST_POSITION)
        }
    }

    public func createProgressSpinner() -> Widget {
        let spinner = Spinner()
        spinner.spinning = true
        return spinner
    }

    // MARK: Helpers

    private func wrapInCustomRootContainer(_ widget: Widget) -> Widget {
        let container = CustomRootWidget()
        container.setChild(to: widget)
        return container
    }

    private static func cssProperties(
        for environment: Environment,
        isControl: Bool = false
    ) -> [CSSProperty] {
        var properties: [CSSProperty] = []
        properties.append(.foregroundColor(environment.suggestedForegroundColor.gtkColor))
        switch environment.font {
            case .system(let size, let weight, let design):
                properties.append(.fontSize(size))
                let weightNumber =
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
                properties.append(.fontWeight(weightNumber))
                switch design {
                    case .monospaced:
                        properties.append(.fontFamily("monospace"))
                    case .default, .none:
                        break
                }
        }

        if isControl {
            properties.append(.backgroundColor(Color(1, 1, 1, 0.1)))
            properties.append(CSSProperty(key: "border", value: "none"))
            properties.append(CSSProperty(key: "box-shadow", value: "none"))
        }

        return properties
    }
}
