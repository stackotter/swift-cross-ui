import CGtk
import Foundation
import Gtk
import SwiftCrossUI

extension App {
    public typealias Backend = GtkBackend

    public var backend: GtkBackend {
        GtkBackend(appIdentifier: Self.metadata?.identifier)
    }
}

extension SwiftCrossUI.Color {
    public var gtkColor: Gtk.Color {
        return Gtk.Color(red, green, blue, alpha)
    }
}

public final class GtkBackend: AppBackend {
    public typealias Window = Gtk.ApplicationWindow
    public typealias Widget = Gtk.Widget
    public typealias Menu = Gtk.PopoverMenu
    public typealias Alert = Gtk.MessageDialog
    public typealias Path = Never

    public let defaultTableRowContentHeight = 20
    public let defaultTableCellVerticalPadding = 4
    public let defaultPaddingAmount = 10
    public let scrollBarWidth = 0
    public let requiresToggleSwitchSpacer = false
    public let defaultToggleStyle = ToggleStyle.button
    public let requiresImageUpdateOnScaleFactorChange = false
    public let menuImplementationStyle = MenuImplementationStyle.dynamicPopover
    public let canRevealFiles = true

    var gtkApp: Application

    /// A window to be returned on the next call to ``GtkBackend/createWindow``.
    /// This is necessary because Gtk creates a root window no matter what, and
    /// this needs to be returned on the first call to `createWindow`.
    var precreatedWindow: Window?

    /// All current windows associated with the application. Doesn't include the
    /// precreated window until it gets 'created' via `createWindow`.
    var windows: [Window] = []

    // A separate initializer to satisfy ``AppBackend``'s requirements.
    public convenience init() {
        self.init(appIdentifier: nil)
    }

    /// Creates a backend instance. If `appIdentifier` is `nil`, the default
    /// identifier `com.example.SwiftCrossUIApp` is used.
    public init(appIdentifier: String?) {
        gtkApp = Application(
            applicationId: appIdentifier ?? "com.example.SwiftCrossUIApp",
            flags: G_APPLICATION_HANDLES_OPEN
        )
        gtkApp.registerSession = true
    }

    var globalCSSProvider: CSSProvider?

    public func runMainLoop(_ callback: @escaping () -> Void) {
        gtkApp.run { window in
            self.precreatedWindow = window
            callback()

            let provider = CSSProvider()
            provider.loadCss(
                from: """
                    list {
                        background: none;
                    }

                    list > row {
                        padding: 0;
                        min-height: 0;
                    }

                    .navigation-sidebar {
                        margin: 0;
                        padding: 0;
                    }

                    .navigation-sidebar > row { margin: 0;
                        padding: 0;
                    }
                    """
            )

            // Keep a reference around so that the provider doesn't get removed as
            // soon as we exit this scope.
            self.globalCSSProvider = provider

            #if !os(macOS)
                Self.mainRunLoopTicklingLoop()
            #endif
        }
    }

    private static func mainRunLoopTicklingLoop(nextDelayMilliseconds: Int? = nil) {
        Self.runInMainThread(afterMilliseconds: nextDelayMilliseconds ?? 50) {
            let nextDate = RunLoop.main.limitDate(forMode: .default)
            // This isn't expected to be nil, but if it is we can just loop
            // again quickly with the default delay.
            let nextDelay = nextDate.map {
                return max(min(Int($0.timeIntervalSinceNow * 1000), 50), 0)
            }
            mainRunLoopTicklingLoop(nextDelayMilliseconds: nextDelay)
        }
    }

    public func createWindow(withDefaultSize defaultSize: SIMD2<Int>?) -> Window {
        let window: Gtk.ApplicationWindow
        if let precreatedWindow = precreatedWindow {
            self.precreatedWindow = nil
            window = precreatedWindow
        } else {
            window = Gtk.ApplicationWindow(application: gtkApp)
        }

        windows.append(window)

        if let defaultSize = defaultSize {
            window.defaultSize = Size(
                width: defaultSize.x,
                height: defaultSize.y
            )
        }

        window.setChild(Gtk.Box())

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

    private func menubarHeight(ofWindow window: Window) -> Int {
        #if os(macOS)
            return 0
        #else
            if window.showMenuBar {
                // TODO: Don't hardcode this (if possible), because some Gtk
                //   themes may affect the height of the menu bar.
                25
            } else {
                0
            }
        #endif
    }

    public func size(ofWindow window: Window) -> SIMD2<Int> {
        let child = window.getChild() as! CustomRootWidget
        let size = child.getSize()
        return SIMD2(size.width, size.height)
    }

    public func isWindowProgrammaticallyResizable(_ window: Window) -> Bool {
        // TODO: Detect whether window is fullscreen
        return true
    }

    public func setSize(ofWindow window: Window, to newSize: SIMD2<Int>) {
        let child = window.getChild() as! CustomRootWidget
        window.size = Size(
            width: newSize.x,
            height: newSize.y + menubarHeight(ofWindow: window)
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
            self.runInMainThread {
                action(SIMD2(size.width, size.height))
            }
        }
    }

    public func show(window: Window) {
        window.show()
    }

    public func activate(window: Window) {
        window.present()
    }

    public func openExternalURL(_ url: URL) throws {
        // Used instead of gtk_uri_launcher_launch to maintain <4.10 compatibility
        gtk_show_uri(nil, url.absoluteString, guint(GDK_CURRENT_TIME))
    }

    public func revealFile(_ url: URL) throws {
        var success = false

        #if !os(Windows)
            let fileURI = url.absoluteString.replacingOccurrences(
                of: ",",
                with: "\\,"
            )
            let process = Process()
            process.arguments = [
                "dbus-send", "--print-reply",
                "--dest=org.freedesktop.FileManager1",
                "/org/freedesktop/FileManager1",
                "org.freedesktop.FileManager1.ShowItems",
                "array:string:\(fileURI)",
                "string:",
            ]
            process.executableURL = URL(fileURLWithPath: "/usr/bin/env")

            do {
                try process.run()
                process.waitUntilExit()

                success = process.terminationStatus == 0
            } catch {

            }
        #endif

        if !success {
            // Fall back to opening the parent directory without highlighting
            // the file.
            try openExternalURL(url.deletingLastPathComponent())
        }
    }

    private func renderMenu(
        _ menu: ResolvedMenu,
        actionMap: any GActionMap,
        actionNamespace: String,
        actionPrefix: String?
    ) -> GMenu {
        let model = GMenu()
        for (i, item) in menu.items.enumerated() {
            let actionName =
                if let actionPrefix {
                    "\(actionPrefix)_\(i)"
                } else {
                    "\(i)"
                }

            switch item {
                case .button(let label, let action):
                    if let action {
                        actionMap.addAction(named: actionName, action: action)
                    }

                    model.appendItem(label: label, actionName: "\(actionNamespace).\(actionName)")
                case .submenu(let submenu):
                    model.appendSubmenu(
                        label: submenu.label,
                        content: renderMenu(
                            submenu.content,
                            actionMap: actionMap,
                            actionNamespace: actionNamespace,
                            actionPrefix: actionName
                        )
                    )
            }
        }
        return model
    }

    private func renderMenuBar(_ submenus: [ResolvedMenu.Submenu]) -> GMenu {
        let model = GMenu()
        for (i, submenu) in submenus.enumerated() {
            model.appendSubmenu(
                label: submenu.label,
                content: renderMenu(
                    submenu.content,
                    actionMap: gtkApp,
                    actionNamespace: "app",
                    actionPrefix: "\(i)"
                )
            )
        }

        return model
    }

    public func setApplicationMenu(_ submenus: [ResolvedMenu.Submenu]) {
        let model = renderMenuBar(submenus)
        gtkApp.menuBarModel = model

        let showMenuBar = !submenus.isEmpty
        for window in windows {
            window.showMenuBar = showMenuBar
        }
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

    private static func runInMainThread(afterMilliseconds delay: Int, action: @escaping () -> Void) {
        let action = ThreadActionContext(action: action)
        g_timeout_add_full(
            0,
            guint(max(delay, 0)),
            { context in
                guard let context = context else {
                    fatalError("Gtk action callback called without context")
                }

                let action = Unmanaged<ThreadActionContext>.fromOpaque(context)
                    .takeUnretainedValue()
                action.action()

                // Cancel the recurring timeout after one iteration
                return 0
            },
            Unmanaged<ThreadActionContext>.passRetained(action).toOpaque(),
            { _ in }
        )
    }

    public func computeRootEnvironment(defaultEnvironment: EnvironmentValues) -> EnvironmentValues {
        defaultEnvironment
    }

    public func setRootEnvironmentChangeHandler(to action: @escaping () -> Void) {
        // TODO: React to theme changes
    }

    public func computeWindowEnvironment(
        window: Window,
        rootEnvironment: EnvironmentValues
    ) -> EnvironmentValues {
        // TODO: Record window scale factor in here
        rootEnvironment
    }

    public func setWindowEnvironmentChangeHandler(
        of window: Window,
        to action: @escaping () -> Void
    ) {
        // TODO: Notify when window scale factor changes
    }

    public func setIncomingURLHandler(to action: @escaping (URL) -> Void) {
        gtkApp.onOpen = { urls in
            for url in urls {
                action(url)
            }
        }
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
        return Box()
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
        to action: @escaping () -> Void
    ) {
        let splitView = splitView as! Paned
        splitView.notifyPosition = { splitView in
            action()
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

    public func createSelectableListView() -> Widget {
        let listView = CustomListBox()
        listView.selectionMode = .single
        gtk_widget_add_css_class(listView.widgetPointer, "navigation-sidebar")
        return listView
    }

    public func baseItemPadding(
        ofSelectableListView listView: Widget
    ) -> SwiftCrossUI.EdgeInsets {
        SwiftCrossUI.EdgeInsets()
    }

    public func minimumRowSize(ofSelectableListView listView: Widget) -> SIMD2<Int> {
        .zero
    }

    public func setItems(
        ofSelectableListView listView: Widget,
        to items: [Widget],
        withRowHeights rowHeights: [Int]
    ) {
        let listView = listView as! CustomListBox
        listView.removeAll()
        for item in items {
            listView.append(item)
        }
    }

    public func setSelectionHandler(
        forSelectableListView listView: Widget,
        to action: @escaping (_ selectedIndex: Int) -> Void
    ) {
        let listView = listView as! CustomListBox
        listView.rowSelected = { _, selectedRow in
            guard let selectedRow else {
                return
            }
            let selection = Int(gtk_list_box_row_get_index(selectedRow))
            guard selection != listView.cachedSelection else {
                return
            }
            listView.cachedSelection = selection
            action(selection)
        }
    }

    public func setSelectedItem(ofSelectableListView listView: Widget, toItemAt index: Int?) {
        let listView = listView as! ListBox
        let handler = listView.rowSelected
        listView.rowSelected = nil
        if let index {
            listView.selectRow(at: index)
        } else {
            listView.unselectAll()
        }
        listView.rowSelected = handler
    }

    // MARK: Passive views

    public func createTextView() -> Widget {
        let label = Label(string: "")
        label.horizontalAlignment = .start
        return label
    }

    public func updateTextView(
        _ textView: Widget,
        content: String,
        environment: EnvironmentValues
    ) {
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
        environment: EnvironmentValues
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
        dataHasChanged: Bool,
        environment: EnvironmentValues
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
        environment: EnvironmentValues,
        action: @escaping () -> Void
    ) {
        // TODO: Update button label color using environment
        let button = button as! Gtk.Button
        button.sensitive = environment.isEnabled
        button.label = label
        button.clicked = { _ in action() }
        button.css.clear()
        button.css.set(properties: Self.cssProperties(for: environment, isControl: true))
    }

    public func createToggle() -> Widget {
        return ToggleButton()
    }

    public func updateToggle(
        _ toggle: Widget,
        label: String,
        environment: EnvironmentValues,
        onChange: @escaping (Bool) -> Void
    ) {
        let toggle = toggle as! Gtk.ToggleButton
        toggle.sensitive = environment.isEnabled
        toggle.label = label
        toggle.toggled = { widget in
            onChange(widget.active)
        }
    }

    public func setState(ofToggle toggle: Widget, to state: Bool) {
        (toggle as! Gtk.ToggleButton).active = state
    }

    public func createSwitch() -> Widget {
        return Switch()
    }

    public func updateSwitch(
        _ switchWidget: Widget,
        environment: EnvironmentValues,
        onChange: @escaping (Bool) -> Void
    ) {
        let switchWidget = switchWidget as! Gtk.Switch
        switchWidget.sensitive = environment.isEnabled
        switchWidget.notifyActive = { widget,_ in
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
        environment: EnvironmentValues,
        onChange: @escaping (Double) -> Void
    ) {
        let slider = slider as! Scale
        slider.sensitive = environment.isEnabled
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
        environment: EnvironmentValues,
        onChange: @escaping (String) -> Void,
        onSubmit: @escaping () -> Void
    ) {
        let textField = textField as! Entry
        textField.sensitive = environment.isEnabled
        textField.placeholderText = placeholder
        textField.changed = { widget in
            onChange(widget.text)
        }
        textField.activate = { _ in
            onSubmit()
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
        environment: EnvironmentValues,
        onChange: @escaping (Int?) -> Void
    ) {
        let picker = picker as! DropDown
        picker.sensitive = environment.isEnabled

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

        picker.notifySelected = { picker, _ in
            if picker.selected == Int(Int32(bitPattern: GTK_INVALID_LIST_POSITION)) {
                onChange(nil)
            } else {
                onChange(picker.selected)
            }
        }
    }

    public func setSelectedOption(ofPicker picker: Widget, to selectedOption: Int?) {
        let picker = picker as! DropDown
        if selectedOption != picker.selected {
            picker.selected = selectedOption ?? Int(Int32(bitPattern: GTK_INVALID_LIST_POSITION))
        }
    }

    public func createProgressSpinner() -> Widget {
        let spinner = Spinner()
        spinner.spinning = true
        return spinner
    }

    public func createProgressBar() -> Widget {
        ProgressBar()
    }

    public func updateProgressBar(
        _ widget: Widget,
        progressFraction: Double?,
        environment: EnvironmentValues
    ) {
        let progressBar = widget as! ProgressBar
        progressBar.fraction = progressFraction ?? 0
        let backgroundColor: Gtk.Color
        switch environment.colorScheme {
            case .light:
                backgroundColor = Gtk.Color.eightBit(61, 61, 61, 38)
            case .dark:
                backgroundColor = Gtk.Color.eightBit(90, 90, 90)
        }
        progressBar.cssProvider.loadCss(
            from: """
                trough {
                    background-color: \(CSSProperty.rgba(backgroundColor));
                }
                """
        )
    }

    public func createPopoverMenu() -> PopoverMenu {
        let menu = Gtk.PopoverMenu()
        menu.hasArrow = false
        return menu
    }

    public func updatePopoverMenu(
        _ menu: Menu,
        content: ResolvedMenu,
        environment: EnvironmentValues
    ) {
        // Update menu model and action handlers
        let actionGroup = Gtk.GSimpleActionGroup()
        menu.model = renderMenu(
            content,
            actionMap: actionGroup,
            actionNamespace: "menu",
            actionPrefix: nil
        )
        menu.insertActionGroup("menu", actionGroup)

        // Compute styles
        let menuBackground: Gtk.Color
        let menuItemHoverBackground: Gtk.Color
        let foreground = environment.suggestedForegroundColor.gtkColor
        switch environment.colorScheme {
            case .light:
                menuBackground = Gtk.Color(1, 1, 1)
                menuItemHoverBackground = Gtk.Color(0.9, 0.9, 0.9)
            case .dark:
                menuBackground = Gtk.Color(0.175, 0.175, 0.175)
                menuItemHoverBackground = Gtk.Color(1, 1, 1, 0.1)
        }

        // Set styles
        menu.cssProvider.loadCss(
            from: """
                contents {
                    background: \(CSSProperty.rgba(menuBackground));
                }
                contents modelbutton:hover, contents modelbutton:selected {
                    background: \(CSSProperty.rgba(menuItemHoverBackground));
                }
                contents modelbutton label {
                    color: \(CSSProperty.rgba(foreground));
                }
                contents modelbutton {
                    color: \(CSSProperty.rgba(foreground));
                }
                """)
    }

    public func showPopoverMenu(
        _ menu: Menu,
        at position: SIMD2<Int>,
        relativeTo widget: Widget,
        closeHandler handleClose: @escaping () -> Void
    ) {
        menu.popUpAtWidget(widget, relativePosition: position)
        menu.onHide = {
            handleClose()
        }
    }

    public func createAlert() -> Alert {
        let dialog = Gtk.MessageDialog()

        // Register a custom shortcut controller to disable the default Escape-to-close
        // action. In future we'll probably want to conditionally re-enable this
        // shortcut in scenarios where we know which action button is the cancel action.
        let controller = gtk_shortcut_controller_new()
        let trigger = gtk_shortcut_trigger_parse_string("Escape")
        let action = gtk_callback_action_new({ _, _, _ in return 1 }, nil, { _ in })
        let shortcut = gtk_shortcut_new(trigger, action)
        gtk_shortcut_controller_add_shortcut(controller, shortcut)
        gtk_widget_add_controller(dialog.widgetPointer, controller)

        return dialog
    }

    public func updateAlert(
        _ alert: Alert,
        title: String,
        actionLabels: [String],
        environment: EnvironmentValues
    ) {
        alert.text = title
        for (i, label) in actionLabels.enumerated() {
            alert.addButton(label: label, responseId: i)
        }
    }

    public func showAlert(
        _ alert: Alert,
        window: Window?,
        responseHandler handleResponse: @escaping (Int) -> Void
    ) {
        alert.response = { _, responseId in
            guard responseId != Int(UInt32(bitPattern: -4)) else {
                // Ignore escape key for now. Once we support detecting
                // the primary and secondary actions of alerts we can wire
                // this up to whichever action is the default cancellation
                // action.
                return
            }

            alert.destroy()
            handleResponse(responseId)
        }
        alert.isModal = true
        alert.isDecorated = false
        alert.setTransient(for: window ?? windows[0])
        alert.show()
    }

    public func dismissAlert(_ alert: Alert, window: Window?) {
        alert.destroy()
    }

    public func showOpenDialog(
        fileDialogOptions: FileDialogOptions,
        openDialogOptions: OpenDialogOptions,
        window: Window?,
        resultHandler handleResult: @escaping (DialogResult<[URL]>) -> Void
    ) {
        showFileChooserDialog(
            fileDialogOptions: fileDialogOptions,
            action: .open,
            configure: { chooser in
                chooser.selectMultiple = openDialogOptions.allowMultipleSelections
            },
            window: window ?? windows[0],
            resultHandler: handleResult
        )
    }

    public func showSaveDialog(
        fileDialogOptions: FileDialogOptions,
        saveDialogOptions: SaveDialogOptions,
        window: Window?,
        resultHandler handleResult: @escaping (DialogResult<URL>) -> Void
    ) {
        showFileChooserDialog(
            fileDialogOptions: fileDialogOptions,
            action: .save,
            configure: { chooser in
                if let defaultFileName = saveDialogOptions.defaultFileName {
                    chooser.setCurrentName(defaultFileName)
                }
            },
            window: window ?? windows[0]
        ) { result in
            switch result {
                case .success(let urls):
                    handleResult(.success(urls[0]))
                case .cancelled:
                    handleResult(.cancelled)
            }
        }

    }

    private func showFileChooserDialog(
        fileDialogOptions: FileDialogOptions,
        action: FileChooserAction,
        configure: (Gtk.FileChooserNative) -> Void,
        window: Window?,
        resultHandler handleResult: @escaping (DialogResult<[URL]>) -> Void
    ) {
        let chooser = Gtk.FileChooserNative(
            title: fileDialogOptions.title,
            parent: window?.widgetPointer.cast(),
            action: action.toGtk(),
            acceptLabel: fileDialogOptions.defaultButtonLabel,
            cancelLabel: "Cancel"
        )

        if let initialDirectory = fileDialogOptions.initialDirectory {
            chooser.setCurrentFolder(initialDirectory)
        }

        configure(chooser)

        chooser.registerSignals()
        chooser.response = { (_: NativeDialog, response: Int) -> Void in
            // Release our intentional retain cycle which ironically only exists
            // because of this line. The retain cycle keeps the file chooser
            // around long enough for the user to respond (it gets released
            // immediately if we don't do this in the response signal handler).
            chooser.response = nil

            let response = Int32(bitPattern: UInt32(UInt(response)))
            if response == Int(ResponseType.accept.toGtk().rawValue) {
                let files = chooser.getFiles()
                var urls: [URL] = []
                for i in 0..<files.count {
                    let url = URL(
                        fileURLWithPath: GFile(files[i]).path
                    )
                    urls.append(url)
                }
                handleResult(.success(urls))
            } else {
                handleResult(.cancelled)
            }
        }

        gtk_native_dialog_show(chooser.gobjectPointer.cast())
    }

    public func createTapGestureTarget(wrapping child: Widget, gesture: TapGesture) -> Widget {
        var gtkGesture: GestureSingle
        switch gesture.kind {
            case .primary:
                gtkGesture = GestureClick()
            case .secondary:
                gtkGesture = GestureClick()
                gtk_gesture_single_set_button(gtkGesture.opaquePointer, guint(GDK_BUTTON_SECONDARY))
            case .longPress:
                gtkGesture = GestureLongPress()
        }
        child.addEventController(gtkGesture)
        return child
    }

    public func updateTapGestureTarget(
        _ tapGestureTarget: Widget,
        gesture: TapGesture,
        environment: EnvironmentValues,
        action: @escaping () -> Void
    ) {
        switch gesture.kind {
            case .primary:
                let gesture =
                    tapGestureTarget.eventControllers.first {
                        $0 is GestureClick
                            && gtk_gesture_single_get_button($0.opaquePointer) == GDK_BUTTON_PRIMARY
                    } as! GestureClick
                gesture.pressed = { _, nPress, _, _ in
                    guard environment.isEnabled, nPress == 1 else {
                        return
                    }
                    action()
                }
            case .secondary:
                let gesture =
                    tapGestureTarget.eventControllers.first {
                        $0 is GestureClick
                            && gtk_gesture_single_get_button($0.opaquePointer)
                                == GDK_BUTTON_SECONDARY
                    } as! GestureClick
                gesture.pressed = { _, nPress, _, _ in
                    guard environment.isEnabled, nPress == 1 else {
                        return
                    }
                    action()
                }
            case .longPress:
                let gesture =
                    tapGestureTarget.eventControllers.lazy.compactMap { $0 as? GestureLongPress }
                    .first!
                gesture.pressed = { _, _, _ in
                    guard environment.isEnabled else {
                        return
                    }
                    action()
                }
        }
    }

    // MARK: Helpers

    private func wrapInCustomRootContainer(_ widget: Widget) -> Widget {
        let container = CustomRootWidget()
        container.setChild(to: widget)
        return container
    }

    private static func cssProperties(
        for environment: EnvironmentValues,
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
            switch environment.colorScheme {
                case .light:
                    properties.append(.backgroundColor(Color(0.9, 0.9, 0.9, 1)))
                case .dark:
                    properties.append(.backgroundColor(Color(1, 1, 1, 0.1)))
            }
            properties.append(CSSProperty(key: "border", value: "none"))
            properties.append(CSSProperty(key: "box-shadow", value: "none"))
        }

        return properties
    }
}

extension UnsafeMutablePointer {
    func cast<T>() -> UnsafeMutablePointer<T> {
        let pointer = UnsafeRawPointer(self).bindMemory(to: T.self, capacity: 1)
        return UnsafeMutablePointer<T>(mutating: pointer)
    }
}

class CustomListBox: ListBox {
    var cachedSelection: Int? = nil
}
