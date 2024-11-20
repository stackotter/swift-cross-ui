import AppKit
import SwiftCrossUI

extension App {
    public typealias Backend = AppKitBackend
}

public final class AppKitBackend: AppBackend {
    public typealias Window = NSCustomWindow

    public typealias Widget = NSView

    public let defaultTableRowContentHeight = 20
    public let defaultTableCellVerticalPadding = 4
    public let defaultPaddingAmount = 10

    public var scrollBarWidth: Int {
        // We assume that all scrollers have their controlSize set to `.regular` by default.
        // The internet seems to indicate that this is true regardless of any system wide
        // preferences etc.
        Int(
            NSScroller.scrollerWidth(
                for: .regular,
                scrollerStyle: NSScroller.preferredScrollerStyle
            ).rounded(.awayFromZero)
        )
    }

    public init() {}

    public func runMainLoop(_ callback: @escaping () -> Void) {
        callback()
        NSApplication.shared.activate(ignoringOtherApps: true)
        NSApplication.shared.run()
    }

    public func createWindow(withDefaultSize defaultSize: SIMD2<Int>?) -> Window {
        let nsApp = NSApplication.shared
        nsApp.setActivationPolicy(.regular)

        let window = NSCustomWindow(
            contentRect: NSRect(
                x: 0,
                y: 0,
                width: CGFloat(defaultSize?.x ?? 0),
                height: CGFloat(defaultSize?.y ?? 0)
            ),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: true
        )
        window.delegate = window.resizeDelegate
        return window
    }

    public func size(ofWindow window: Window) -> SIMD2<Int> {
        let contentRect = window.contentRect(forFrameRect: window.frame)
        return SIMD2(
            Int(contentRect.width.rounded(.towardZero)),
            Int(contentRect.height.rounded(.towardZero))
        )
    }

    public func setSize(ofWindow window: Window, to newSize: SIMD2<Int>) {
        window.setContentSize(NSSize(width: newSize.x, height: newSize.y))
    }

    public func setMinimumSize(ofWindow window: Window, to minimumSize: SIMD2<Int>) {
        window.contentMinSize.width = CGFloat(minimumSize.x)
        window.contentMinSize.height = CGFloat(minimumSize.y)
    }

    public func setResizeHandler(
        ofWindow window: Window,
        to action: @escaping (SIMD2<Int>) -> Void
    ) {
        window.resizeDelegate.setHandler(action)
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

    public func setChild(ofWindow window: Window, to child: Widget) {
        window.contentView = child
    }

    public func show(window: Window) {
        window.makeKeyAndOrderFront(nil)
    }

    public func runInMainThread(action: @escaping () -> Void) {
        DispatchQueue.main.async {
            action()
        }
    }

    public func computeRootEnvironment(defaultEnvironment: Environment) -> Environment {
        let isDark = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark"
        let font = Font.system(
            size: Int(NSFont.systemFont(ofSize: 0.0).pointSize.rounded(.awayFromZero))
        )
        return
            defaultEnvironment
            .with(\.colorScheme, isDark ? .dark : .light)
            .with(\.font, font)
    }

    public func setRootEnvironmentChangeHandler(to action: @escaping () -> Void) {
        DistributedNotificationCenter.default.addObserver(
            forName: .AppleInterfaceThemeChangedNotification,
            object: nil,
            queue: OperationQueue.main
        ) { notification in
            action()
        }

        // This doesn't strictly affect the root environment, but it does require us
        // to re-compute the app's layout, and this is how backends should trigger top
        // level updates.
        DistributedNotificationCenter.default.addObserver(
            forName: NSScroller.preferredScrollerStyleDidChangeNotification,
            object: nil,
            queue: OperationQueue.main
        ) { notification in
            // Self.scrollBarWidth has changed
            action()
        }
    }

    public func show(widget: Widget) {}

    class NSContainerView: NSView {
        var children: [NSView] = []

        override func addSubview(_ view: NSView) {
            children.append(view)
            super.addSubview(view)
        }

        func removeSubview(_ view: NSView) {
            children.removeAll { other in
                view === other
            }
            view.removeFromSuperview()
        }

        func removeAllSubviews() {
            for child in children {
                child.removeFromSuperview()
            }
            children = []
        }
    }

    public func createContainer() -> Widget {
        let container = NSContainerView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }

    public func removeAllChildren(of container: Widget) {
        let container = container as! NSContainerView
        container.removeAllSubviews()
    }

    public func addChild(_ child: Widget, to container: Widget) {
        container.addSubview(child)
        child.translatesAutoresizingMaskIntoConstraints = false
    }

    public func setPosition(ofChildAt index: Int, in container: Widget, to position: SIMD2<Int>) {
        let container = container as! NSContainerView
        guard container.children.indices.contains(index) else {
            // TODO: Create proper logging system.
            print("warning: Attempted to set position of non-existent container child")
            return
        }

        let child = container.children[index]

        var foundConstraint = false
        for constraint in container.constraints {
            if constraint.firstAnchor === child.leftAnchor
                && constraint.secondAnchor === container.leftAnchor
            {
                constraint.constant = CGFloat(position.x)
                foundConstraint = true
                break
            }
        }

        if !foundConstraint {
            let constraint = child.leftAnchor.constraint(
                equalTo: container.leftAnchor, constant: CGFloat(position.x)
            )
            constraint.isActive = true
        }

        foundConstraint = false
        for constraint in container.constraints {
            if constraint.firstAnchor === child.topAnchor
                && constraint.secondAnchor === container.topAnchor
            {
                constraint.constant = CGFloat(position.y)
                foundConstraint = true
                break
            }
        }

        if !foundConstraint {
            child.topAnchor.constraint(
                equalTo: container.topAnchor,
                constant: CGFloat(position.y)
            ).isActive = true
        }
    }

    public func removeChild(_ child: Widget, from container: Widget) {
        let container = container as! NSContainerView
        container.removeSubview(child)
    }

    public func createColorableRectangle() -> Widget {
        let widget = NSView()
        widget.wantsLayer = true
        return widget
    }

    public func setColor(ofColorableRectangle widget: Widget, to color: Color) {
        widget.layer?.backgroundColor = color.nsColor.cgColor
    }

    public func setCornerRadius(of widget: Widget, to radius: Int) {
        widget.clipsToBounds = true
        widget.wantsLayer = true
        widget.layer?.cornerRadius = CGFloat(radius)
    }

    public func naturalSize(of widget: Widget) -> SIMD2<Int> {
        let size = widget.intrinsicContentSize
        return SIMD2(
            Int(size.width),
            Int(size.height)
        )
    }

    public func setSize(of widget: Widget, to size: SIMD2<Int>) {
        var foundConstraint = false
        for constraint in widget.constraints {
            if constraint.firstAnchor === widget.widthAnchor {
                constraint.constant = CGFloat(size.x)
                foundConstraint = true
                break
            }
        }

        if !foundConstraint {
            widget.widthAnchor.constraint(equalToConstant: CGFloat(size.x)).isActive = true
        }

        foundConstraint = false
        for constraint in widget.constraints {
            if constraint.firstAnchor === widget.heightAnchor {
                constraint.constant = CGFloat(size.y)
                foundConstraint = true
                break
            }
        }

        if !foundConstraint {
            widget.heightAnchor.constraint(equalToConstant: CGFloat(size.y)).isActive = true
        }
    }

    public func size(
        of text: String,
        whenDisplayedIn textView: Widget,
        proposedFrame: SIMD2<Int>?,
        environment: Environment
    ) -> SIMD2<Int> {
        if let proposedFrame, proposedFrame.x == 0 {
            // We want the text to have the same height as it would have if it were
            // one pixel wide so that the layout doesn't suddely jump when the text
            // reaches zero width.
            let size = size(
                of: text,
                whenDisplayedIn: textView,
                proposedFrame: SIMD2(1, proposedFrame.y),
                environment: environment
            )
            return SIMD2(
                0,
                size.y
            )
        }

        let proposedSize = NSSize(
            width: (proposedFrame?.x).map(CGFloat.init) ?? 0,
            height: .greatestFiniteMagnitude
        )
        let rect = NSString(string: text).boundingRect(
            with: proposedSize,
            options: [.usesLineFragmentOrigin],
            attributes: Self.attributes(forTextIn: environment)
        )
        return SIMD2(
            Int(rect.size.width.rounded(.awayFromZero)),
            Int(rect.size.height.rounded(.awayFromZero))
        )
    }

    public func createTextView() -> Widget {
        let field = NSTextField(wrappingLabelWithString: "")
        // Somewhat unintuitively, this changes the behaviour of the text field even
        // though it's not editable. It prevents the text from resetting to default
        // styles when clicked (yeah that happens...)
        field.allowsEditingTextAttributes = true
        return field
    }

    public func updateTextView(_ textView: Widget, content: String, environment: Environment) {
        let field = textView as! NSTextField
        field.attributedStringValue = Self.attributedString(for: content, in: environment)
    }

    public func createButton() -> Widget {
        return NSButton(title: "", target: nil, action: nil)
    }

    public func updateButton(
        _ button: Widget,
        label: String,
        action: @escaping () -> Void,
        environment: Environment
    ) {
        let button = button as! NSButton
        button.attributedTitle = Self.attributedString(for: label, in: environment)
        button.bezelStyle = .regularSquare
        button.appearance = environment.colorScheme.nsAppearance
        button.onAction = { _ in
            action()
        }
    }

    public func createSwitch() -> Widget {
        return NSSwitch()
    }

    public func updateSwitch(_ toggleSwitch: Widget, onChange: @escaping (Bool) -> Void) {
        let toggleSwitch = toggleSwitch as! NSSwitch
        toggleSwitch.onAction = { toggleSwitch in
            let toggleSwitch = toggleSwitch as! NSSwitch
            onChange(toggleSwitch.state == .on)
        }
    }

    public func setState(ofSwitch toggleSwitch: Widget, to state: Bool) {
        let toggleSwitch = toggleSwitch as! NSSwitch
        toggleSwitch.state = state ? .on : .off
    }

    public func createToggle() -> Widget {
        let toggle = NSButton()
        toggle.setButtonType(.pushOnPushOff)
        return toggle
    }

    public func updateToggle(_ toggle: Widget, label: String, onChange: @escaping (Bool) -> Void) {
        let toggle = toggle as! NSButton
        toggle.title = label
        toggle.onAction = { toggle in
            let toggle = toggle as! NSButton
            onChange(toggle.state == .on)
        }
    }

    public func setState(ofToggle toggle: Widget, to state: Bool) {
        let toggle = toggle as! NSButton
        toggle.state = state ? .on : .off
    }

    public func createSlider() -> Widget {
        return NSSlider()
    }

    public func updateSlider(
        _ slider: Widget,
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

    public func setValue(ofSlider slider: Widget, to value: Double) {
        let slider = slider as! NSSlider
        slider.doubleValue = value
    }

    public func createPicker() -> Widget {
        return NSPopUpButton()
    }

    public func updatePicker(
        _ picker: Widget,
        options: [String],
        environment: Environment,
        onChange: @escaping (Int?) -> Void
    ) {
        let picker = picker as! NSPopUpButton
        picker.menu?.removeAllItems()
        for option in options {
            let item = NSMenuItem()
            item.attributedTitle = Self.attributedString(for: option, in: environment)
            picker.menu?.addItem(item)
        }
        picker.onAction = { picker in
            let picker = picker as! NSPopUpButton
            onChange(picker.indexOfSelectedItem)
        }
        picker.bezelStyle = .regularSquare
    }

    public func setSelectedOption(ofPicker picker: Widget, to selectedOption: Int?) {
        let picker = picker as! NSPopUpButton
        if let index = selectedOption {
            picker.selectItem(at: index)
        } else {
            picker.select(nil)
        }
    }

    public func createTextField() -> Widget {
        let field = NSObservableTextField()
        return field
    }

    public func updateTextField(
        _ textField: Widget,
        placeholder: String,
        environment: Environment,
        onChange: @escaping (String) -> Void
    ) {
        let textField = textField as! NSObservableTextField
        textField.placeholderString = placeholder
        textField.appearance = environment.colorScheme.nsAppearance
        textField.onEdit = { textField in
            onChange(textField.stringValue)
        }
    }

    public func getContent(ofTextField textField: Widget) -> String {
        let textField = textField as! NSTextField
        return textField.stringValue
    }

    public func setContent(ofTextField textField: Widget, to content: String) {
        let textField = textField as! NSTextField
        textField.stringValue = content
    }

    public func createScrollContainer(for child: Widget) -> Widget {
        let scrollView = NSScrollView()

        let clipView = scrollView.contentView
        let documentView = NSStackView()
        documentView.orientation = .vertical
        documentView.alignment = .centerX
        documentView.translatesAutoresizingMaskIntoConstraints = false
        documentView.addView(child, in: .top)
        scrollView.documentView = documentView
        scrollView.drawsBackground = false

        documentView.topAnchor.constraint(equalTo: clipView.topAnchor).isActive = true
        documentView.leftAnchor.constraint(equalTo: clipView.leftAnchor).isActive = true
        documentView.heightAnchor.constraint(greaterThanOrEqualTo: clipView.heightAnchor)
            .isActive = true
        documentView.widthAnchor.constraint(greaterThanOrEqualTo: clipView.widthAnchor)
            .isActive = true

        return scrollView
    }

    public func setScrollBarPresence(
        ofScrollContainer scrollView: Widget,
        hasVerticalScrollBar: Bool,
        hasHorizontalScrollBar: Bool
    ) {
        let scrollView = scrollView as! NSScrollView
        scrollView.hasVerticalScroller = hasVerticalScrollBar
        scrollView.hasHorizontalScroller = hasHorizontalScrollBar
    }

    public func createSplitView(leadingChild: Widget, trailingChild: Widget) -> Widget {
        let splitView = NSCustomSplitView()
        let leadingChildWithEffect = NSVisualEffectView()
        leadingChildWithEffect.blendingMode = .behindWindow
        leadingChildWithEffect.material = .sidebar
        leadingChildWithEffect.addSubview(leadingChild)
        leadingChild.widthAnchor.constraint(equalTo: leadingChildWithEffect.widthAnchor)
            .isActive = true
        leadingChild.heightAnchor.constraint(equalTo: leadingChildWithEffect.heightAnchor)
            .isActive = true
        leadingChild.topAnchor.constraint(equalTo: leadingChildWithEffect.topAnchor)
            .isActive = true
        leadingChild.leadingAnchor.constraint(equalTo: leadingChildWithEffect.leadingAnchor)
            .isActive = true
        leadingChild.translatesAutoresizingMaskIntoConstraints = false
        leadingChildWithEffect.translatesAutoresizingMaskIntoConstraints = false

        splitView.addArrangedSubview(leadingChildWithEffect)
        splitView.addArrangedSubview(trailingChild)
        splitView.isVertical = true
        splitView.dividerStyle = .thin
        let defaultLeadingWidth = 200
        splitView.setPosition(CGFloat(defaultLeadingWidth), ofDividerAt: 0)
        splitView.adjustSubviews()

        let delegate = NSSplitViewResizingDelegate()
        delegate.leadingWidth = defaultLeadingWidth
        splitView.delegate = delegate
        splitView.resizingDelegate = delegate
        return splitView
    }

    public func setResizeHandler(
        ofSplitView splitView: Widget,
        to action: @escaping (_ leadingWidth: Int, _ trailingWidth: Int) -> Void
    ) {
        let splitView = splitView as! NSCustomSplitView
        splitView.resizingDelegate?.setResizeHandler { paneWidths in
            action(paneWidths[0], paneWidths[1])
        }
    }

    public func sidebarWidth(ofSplitView splitView: Widget) -> Int {
        let splitView = splitView as! NSCustomSplitView
        return splitView.resizingDelegate!.leadingWidth
    }

    public func setSidebarWidthBounds(
        ofSplitView splitView: Widget,
        minimum minimumWidth: Int,
        maximum maximumWidth: Int
    ) {
        let splitView = splitView as! NSCustomSplitView
        splitView.resizingDelegate!.minimumLeadingWidth = minimumWidth
        splitView.resizingDelegate!.maximumLeadingWidth = maximumWidth
    }

    public func createImageView() -> Widget {
        let imageView = NSImageView()
        imageView.imageScaling = .scaleAxesIndependently
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

        let imageView = imageView as! NSImageView
        var rgbaData = rgbaData
        let context = CGContext(
            data: &rgbaData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: 4 * width,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )
        let cgImage = context!.makeImage()!

        imageView.image = NSImage(cgImage: cgImage, size: NSSize(width: width, height: height))
    }

    public func createTable() -> Widget {
        let scrollView = NSScrollView()
        let table = NSCustomTableView()
        table.delegate = table.customDelegate
        table.dataSource = table.customDelegate
        table.usesAlternatingRowBackgroundColors = true
        table.rowHeight = CGFloat(
            defaultTableRowContentHeight + 2 * defaultTableCellVerticalPadding
        )
        table.columnAutoresizingStyle = .lastColumnOnlyAutoresizingStyle
        table.allowsColumnSelection = false
        scrollView.documentView = table
        return scrollView
    }

    public func setRowCount(ofTable table: Widget, to rowCount: Int) {
        let table = (table as! NSScrollView).documentView as! NSCustomTableView
        table.customDelegate.rowCount = rowCount
    }

    public func setColumnLabels(
        ofTable table: Widget,
        to labels: [String],
        environment: Environment
    ) {
        let table = (table as! NSScrollView).documentView as! NSCustomTableView
        var columnIndices: [ObjectIdentifier: Int] = [:]
        let columns = labels.enumerated().map { (i, label) in
            let column = NSTableColumn(
                identifier: NSUserInterfaceItemIdentifier("Column \(i)")
            )
            column.headerCell = NSTableHeaderCell()
            column.headerCell.attributedStringValue = Self.attributedString(
                for: label,
                in: environment
            )
            columnIndices[ObjectIdentifier(column)] = i
            return column
        }
        table.customDelegate.columnIndices = columnIndices
        for column in table.tableColumns {
            table.removeTableColumn(column)
        }
        table.customDelegate.columnCount = labels.count
        for column in columns {
            table.addTableColumn(column)
        }
    }

    public func setCells(
        ofTable table: Widget,
        to cells: [Widget],
        withRowHeights rowHeights: [Int]
    ) {
        let table = (table as! NSScrollView).documentView as! NSCustomTableView
        table.customDelegate.widgets = cells
        table.customDelegate.rowHeights = rowHeights
        table.reloadData()
    }

    private static func attributedString(
        for text: String,
        in environment: Environment
    ) -> NSAttributedString {
        NSAttributedString(
            string: text,
            attributes: attributes(forTextIn: environment)
        )
    }

    private static func attributes(
        forTextIn environment: Environment
    ) -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment =
            switch environment.multilineTextAlignment {
                case .leading:
                    .left
                case .center:
                    .center
                case .trailing:
                    .right
            }
        return [
            .foregroundColor: environment.suggestedForegroundColor.nsColor,
            .font: font(for: environment),
            .paragraphStyle: paragraphStyle,
        ]
    }

    private static func font(for environment: Environment) -> NSFont {
        switch environment.font {
            case .system(let size, let weight, let design):
                switch design {
                    case .default, .none:
                        NSFont.systemFont(
                            ofSize: CGFloat(size), weight: weight.map(Self.weight(for:)) ?? .regular
                        )
                    case .monospaced:
                        NSFont.monospacedSystemFont(
                            ofSize: CGFloat(size),
                            weight: weight.map(Self.weight(for:)) ?? .regular
                        )
                }
        }
    }

    private static func weight(for weight: Font.Weight) -> NSFont.Weight {
        switch weight {
            case .black:
                .black
            case .bold:
                .bold
            case .heavy:
                .heavy
            case .light:
                .light
            case .medium:
                .medium
            case .regular:
                .regular
            case .semibold:
                .semibold
            case .thin:
                .thin
            case .ultraLight:
                .ultraLight
        }
    }

    public func createProgressSpinner() -> Widget {
        let spinner = NSProgressIndicator()
        spinner.isIndeterminate = true
        spinner.style = .spinning
        spinner.startAnimation(nil)
        return spinner
    }

}

class NSCustomTableView: NSTableView {
    var customDelegate = NSCustomTableViewDelegate()
}

class NSCustomTableViewDelegate: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    var widgets: [AppKitBackend.Widget] = []
    var rowHeights: [Int] = []
    var columnIndices: [ObjectIdentifier: Int] = [:]
    var rowCount = 0
    var columnCount = 0

    func numberOfRows(in tableView: NSTableView) -> Int {
        return rowCount
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return CGFloat(rowHeights[row])
    }

    func tableView(
        _ tableView: NSTableView,
        viewFor tableColumn: NSTableColumn?,
        row: Int
    ) -> NSView? {
        guard let tableColumn else {
            print("warning: No column provided")
            return nil
        }
        guard let columnIndex = columnIndices[ObjectIdentifier(tableColumn)] else {
            print("warning: NSTableView asked for value of non-existent column")
            return nil
        }
        return widgets[row * columnCount + columnIndex]
    }

    func tableView(
        _ tableView: NSTableView,
        selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet
    ) -> IndexSet {
        []
    }
}

extension ColorScheme {
    var nsAppearance: NSAppearance? {
        switch self {
            case .light:
                return NSAppearance(named: .aqua)
            case .dark:
                return NSAppearance(named: .darkAqua)
        }
    }
}

extension Color {
    init(_ nsColor: NSColor) {
        guard let resolvedNSColor = nsColor.usingColorSpace(.deviceRGB) else {
            print("error: Failed to convert NSColor to RGB")
            self = .black
            return
        }
        self.init(
            Float(resolvedNSColor.redComponent),
            Float(resolvedNSColor.greenComponent),
            Float(resolvedNSColor.blueComponent),
            Float(resolvedNSColor.alphaComponent)
        )
    }

    var nsColor: NSColor {
        NSColor(
            calibratedRed: CGFloat(red),
            green: CGFloat(green),
            blue: CGFloat(blue),
            alpha: 1
        )
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

class NSCustomSplitView: NSSplitView {
    var resizingDelegate: NSSplitViewResizingDelegate?
}

class NSSplitViewResizingDelegate: NSObject, NSSplitViewDelegate {
    var resizeHandler: ((_ paneWidths: [Int]) -> Void)?
    var leadingWidth = 0
    var minimumLeadingWidth = 0
    var maximumLeadingWidth = 0
    var isFirstUpdate = true
    /// Tracks whether AppKit is resizing the side bar (as opposed to the user resizing it).
    var appKitIsResizing = false

    func setResizeHandler(_ handler: @escaping (_ paneWidths: [Int]) -> Void) {
        resizeHandler = handler
    }

    func splitView(_ splitView: NSSplitView, shouldAdjustSizeOfSubview view: NSView) -> Bool {
        appKitIsResizing = true
        return true
    }

    func splitViewDidResizeSubviews(_ notification: Notification) {
        appKitIsResizing = false
        let splitView = notification.object! as! NSSplitView
        let paneWidths = splitView.subviews.map(\.frame.width).map { width in
            Int(width.rounded())
        }
        let previousWidth = leadingWidth
        leadingWidth = paneWidths[0]

        // Only call the handler if the side bar has actually changed size.
        if leadingWidth != previousWidth {
            resizeHandler?(paneWidths)
        }
    }

    func splitView(
        _ splitView: NSSplitView,
        constrainMinCoordinate proposedMinimumPosition: CGFloat,
        ofSubviewAt dividerIndex: Int
    ) -> CGFloat {
        if dividerIndex == 0 {
            return CGFloat(minimumLeadingWidth)
        } else {
            return proposedMinimumPosition
        }
    }

    func splitView(
        _ splitView: NSSplitView,
        constrainMaxCoordinate proposedMaximumPosition: CGFloat,
        ofSubviewAt dividerIndex: Int
    ) -> CGFloat {
        if dividerIndex == 0 {
            return CGFloat(maximumLeadingWidth)
        } else {
            return proposedMaximumPosition
        }
    }

    func splitView(_ splitView: NSSplitView, resizeSubviewsWithOldSize oldSize: NSSize) {
        splitView.adjustSubviews()

        if isFirstUpdate {
            splitView.setPosition(max(200, CGFloat(minimumLeadingWidth)), ofDividerAt: 0)
            isFirstUpdate = false
        } else {
            let newWidth = splitView.subviews[0].frame.width
            // If AppKit is trying to automatically resize our side bar (e.g. because the split
            // view has changed size), only let it do so if not doing so would put out side bar
            // outside of the allowed bounds.
            if appKitIsResizing
                && leadingWidth >= minimumLeadingWidth
                && leadingWidth <= maximumLeadingWidth
            {
                splitView.setPosition(CGFloat(leadingWidth), ofDividerAt: 0)
            } else {
                // Magic! Thanks https://stackoverflow.com/a/30494691. This one line fixed all
                // of the split view resizing issues.
                splitView.setPosition(newWidth, ofDividerAt: 0)
            }
        }
    }
}

public class NSCustomWindow: NSWindow {
    var resizeDelegate = ResizeDelegate()

    class ResizeDelegate: NSObject, NSWindowDelegate {
        var resizeHandler: ((SIMD2<Int>) -> Void)?

        func setHandler(_ resizeHandler: @escaping (SIMD2<Int>) -> Void) {
            self.resizeHandler = resizeHandler
        }

        func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
            guard let resizeHandler else {
                return frameSize
            }

            let contentSize = sender.contentRect(
                forFrameRect: NSRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
            )

            resizeHandler(
                SIMD2(
                    Int(contentSize.width.rounded(.towardZero)),
                    Int(contentSize.height.rounded(.towardZero))
                )
            )

            return frameSize
        }
    }
}

extension Notification.Name {
    static let AppleInterfaceThemeChangedNotification = Notification.Name(
        "AppleInterfaceThemeChangedNotification"
    )
}
