import CGtk
import Foundation
import Gtk
import SwiftCrossUI

extension SwiftCrossUI.Color {
    public var gtkColor: Gtk.Color {
        return Gtk.Color(red, green, blue, alpha)
    }
}

public final class GtkBackend: AppBackend {
    public typealias Window = Gtk.Window
    public typealias Widget = Gtk.Widget

    var gtkApp: Application

    /// A window to be returned on the next call to ``GtkBackend/createWindow``.
    /// This is necessary because Gtk creates a root window no matter what, and
    /// this needs to be returned on the first call to `createWindow`.
    var precreatedWindow: Window?

    public init(appIdentifier: String) {
        gtkApp = Application(applicationId: appIdentifier)
    }

    public func runMainLoop(_ callback: @escaping () -> Void) {
        // TODO: Setup the main window such that its child is centered like it would be in SwiftUI
        gtkApp.run { window in
            self.precreatedWindow = window
            callback()
        }
    }

    public func createWindow(withDefaultSize defaultSize: SwiftCrossUI.Size?) -> Window {
        let window: Gtk.Window
        if let precreatedWindow = precreatedWindow {
            self.precreatedWindow = nil
            window = precreatedWindow
        } else {
            window = Gtk.Window()
        }

        if let defaultSize = defaultSize {
            window.defaultSize = Size(
                width: defaultSize.width,
                height: defaultSize.height
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
        window.setChild(child)
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

    public func show(widget: Widget) {
        widget.show()
    }

    // MARK: Containers

    public func createVStack() -> Widget {
        return Box(orientation: .vertical, spacing: 0)
    }

    public func addChild(_ child: Widget, toVStack container: Widget) {
        (container as! Box).add(child)
    }

    public func setSpacing(ofVStack container: Widget, to spacing: Int) {
        (container as! Box).spacing = spacing
    }

    public func createHStack() -> Widget {
        return Box(orientation: .horizontal, spacing: 0)
    }

    public func addChild(_ child: Widget, toHStack container: Widget) {
        (container as! Box).add(child)
    }

    public func setSpacing(ofHStack container: Widget, to spacing: Int) {
        (container as! Box).spacing = spacing
    }

    public func createSingleChildContainer() -> Widget {
        return ModifierBox()
    }

    public func setChild(ofSingleChildContainer container: Widget, to widget: Widget?) {
        (container as! ModifierBox).setChild(widget)
    }

    public func createLayoutTransparentStack() -> Widget {
        return SectionBox(orientation: .vertical, spacing: 0)
    }

    public func addChild(_ child: Widget, toLayoutTransparentStack container: Widget) {
        (container as! SectionBox).add(child)
    }

    public func removeChild(_ child: Widget, fromLayoutTransparentStack container: Widget) {
        (container as! SectionBox).remove(child)
    }

    public func updateLayoutTransparentStack(_ container: Widget) {
        (container as! SectionBox).update()
    }

    public func createScrollContainer(for child: Widget) -> Widget {
        let scrolledWindow = ScrolledWindow()
        scrolledWindow.setChild(child)
        scrolledWindow.propagateNaturalHeight = true
        return scrolledWindow
    }

    public func createOneOfContainer() -> Widget {
        return Stack(transitionDuration: 300, transitionType: .slideLeftRight)
    }

    public func addChild(_ child: Widget, toOneOfContainer container: Widget) {
        (container as! Stack).add(child, named: UUID().uuidString)
    }

    public func removeChild(_ child: Widget, fromOneOfContainer container: Widget) {
        (container as! Stack).remove(child)
    }

    public func setVisibleChild(ofOneOfContainer container: Widget, to child: Widget) {
        (container as! Stack).setVisible(child)
    }

    public func createSplitView(leadingChild: Widget, trailingChild: Widget) -> Widget {
        let widget = Paned(orientation: .horizontal)
        widget.startChild = leadingChild
        widget.endChild = trailingChild
        widget.shrinkStartChild = false
        widget.shrinkEndChild = false
        // Set the position to the farthest left possible.
        // TODO: Allow setting the default offset (SwiftUI api: `navigationSplitViewColumnWidth(min:ideal:max:)`).
        //   This needs frame modifier to be fleshed out first
        widget.position = 0
        widget.expandVertically = true
        return widget
    }

    // MARK: Layout

    public func createSpacer() -> Widget {
        return ModifierBox()
    }

    public func updateSpacer(
        _ spacer: Widget,
        expandHorizontally: Bool,
        expandVertically: Bool,
        minSize: Int
    ) {
        let spacer = spacer as! ModifierBox
        spacer.expandHorizontally = expandHorizontally
        spacer.expandVertically = expandVertically
        spacer.marginEnd = expandHorizontally ? minSize : 0
        spacer.marginBottom = expandVertically ? minSize : 0
    }

    public func getInheritedOrientation(of widget: Widget) -> InheritedOrientation? {
        let parent = widget.firstNonModifierParent() as? Box
        switch parent?.orientation {
            case .vertical:
                return .vertical
            case .horizontal:
                return .horizontal
            case nil:
                return nil
        }
    }

    // MARK: Passive views

    public func createTextView() -> Widget {
        let label = Label(string: "")
        label.horizontalAlignment = .start
        return label
    }

    public func updateTextView(_ textView: Widget, content: String, shouldWrap: Bool) {
        let textView = textView as! Label
        textView.label = content
        textView.wrap = shouldWrap
    }

    public func createImageView(filePath: String) -> Widget {
        let picture = Picture(filename: filePath)
        // Prevent the image from completely disappearing if it isn't given space
        // because that can be very confusing as a developer
        picture.minHeight = 5
        return picture
    }

    public func updateImageView(_ imageView: Widget, filePath: String) {
        (imageView as! Gtk.Picture).setPath(filePath)
    }

    private class Tables {
        var tableSizes: [ObjectIdentifier: (rows: Int, columns: Int)] = [:]
    }

    private let tables = Tables()

    public func createTable(rows: Int, columns: Int) -> Widget {
        let widget = Grid()

        for i in 0..<rows {
            widget.insertRow(position: i)
        }

        for i in 0..<columns {
            widget.insertRow(position: i)
        }

        tables.tableSizes[ObjectIdentifier(widget)] = (rows: rows, columns: columns)

        widget.columnSpacing = 10
        widget.rowSpacing = 10

        return widget
    }

    public func setRowCount(ofTable table: Widget, to rows: Int) {
        let table = table as! Grid

        let rowDifference = rows - tables.tableSizes[ObjectIdentifier(table)]!.rows
        tables.tableSizes[ObjectIdentifier(table)]!.rows = rows
        if rowDifference < 0 {
            for _ in 0..<(-rowDifference) {
                table.removeRow(position: 0)
            }
        } else if rowDifference > 0 {
            for _ in 0..<rowDifference {
                table.insertRow(position: 0)
            }
        }

    }

    public func setColumnCount(ofTable table: Widget, to columns: Int) {
        let table = table as! Grid

        let columnDifference = columns - tables.tableSizes[ObjectIdentifier(table)]!.columns
        tables.tableSizes[ObjectIdentifier(table)]!.columns = columns
        if columnDifference < 0 {
            for _ in 0..<(-columnDifference) {
                table.removeColumn(position: 0)
            }
        } else if columnDifference > 0 {
            for _ in 0..<columnDifference {
                table.insertColumn(position: 0)
            }
        }

    }

    public func setCell(at position: CellPosition, inTable table: Widget, to widget: Widget) {
        let table = table as! Grid
        table.attach(
            child: widget,
            left: position.column,
            top: position.row,
            width: 1,
            height: 1
        )
    }

    // MARK: Controls

    public func createButton() -> Widget {
        return Button()
    }

    public func updateButton(_ button: Widget, label: String, action: @escaping () -> Void) {
        let button = button as! Gtk.Button
        button.label = label
        button.clicked = { _ in action() }
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
        _ textField: Widget, placeholder: String, onChange: @escaping (String) -> Void
    ) {
        let textField = textField as! Entry
        textField.placeholderText = placeholder
        textField.changed = { widget in
            onChange(widget.text)
        }
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
        _ picker: Widget, options: [String], onChange: @escaping (Int?) -> Void
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

    // MARK: Modifiers

    public func createFrameContainer(for child: Widget) -> Widget {
        let widget = ModifierBox()
        widget.setChild(child)
        return widget
    }

    public func updateFrameContainer(_ container: Widget, minWidth: Int, minHeight: Int) {
        let container = container as! ModifierBox
        container.css.set(properties: [.minWidth(minWidth)], clear: false)
        container.css.set(properties: [.minHeight(minHeight)], clear: false)
    }

    public func createPaddingContainer(for child: Widget) -> Widget {
        let box = ModifierBox()
        box.setChild(child)
        return box
    }

    public func setPadding(
        ofPaddingContainer container: Widget,
        top: Int,
        bottom: Int,
        leading: Int,
        trailing: Int
    ) {
        let container = container as! ModifierBox
        container.marginTop = top
        container.marginBottom = bottom
        container.marginStart = leading
        container.marginEnd = trailing
    }

    public func createStyleContainer(for child: Widget)
        -> Widget
    {
        let widget = ModifierBox()
        widget.setChild(child)
        return widget
    }

    public func setForegroundColor(
        ofStyleContainer container: Widget,
        to color: SwiftCrossUI.Color
    ) {
        (container as! ModifierBox).css.set(properties: [.foregroundColor(color.gtkColor)])
    }
}
