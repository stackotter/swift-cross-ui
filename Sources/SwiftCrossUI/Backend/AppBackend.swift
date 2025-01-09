import Foundation

/// A backend that can be used to run an app (e.g. Gtk or Qt).
///
/// Default placeholder implementations are available for all non-essential
/// app lifecycle methods. These implementations will fatally crash when called
/// and are simply intended to allow incremental implementation of backends,
/// not a production-ready fallback for views that cannot be represented by a
/// given backend. The methods you need to implemented up-front (which don't
/// have default implementations) are: ``AppBackend/createRootWindow(withDefaultSize:_:)``,
/// ``AppBackend/setTitle(ofWindow:to:)``, ``AppBackend/setResizability(ofWindow:to:)``,
/// ``AppBackend/setChild(ofWindow:to:)``, ``AppBackend/show(window:)``,
/// ``AppBackend/runMainLoop()``, ``AppBackend/runInMainThread(action:)``,
/// ``AppBackend/show(widget:)``. Many of these can simply be given dummy
/// implementations until you're ready to implement them properly.
///
/// If you need to modify the children of a widget after creation but there
/// aren't update methods available, this is an intentional limitation to
/// reduce the complexity of maintaining a multitude of backends -- nest
/// another container, such as a VStack, inside the container to allow you
/// to change its children on demand.
///
/// For interactive controls with values, the method for setting the
/// control's value is always separate from the method for updating the
/// control's properties (e.g. its minimum value, or placeholder label etc).
/// This is because it's very common for view implementations to either
/// update a control's properties without updating its value (in the case
/// of an unbound control), or update a control's value only if it doesn't
/// match its current value (to prevent infinite loops).
///
/// Many views have both a `create` and an `update` method. The `create`
/// method should only have parameters for properties which don't have
/// sensible defaults (e.g. under some backends, image widgets can't be
/// created without an underlying image being selected up-front, so the
/// `create` method requires a `filePath` and will overlap with the `update`
/// method). This design choice was made to reduce the amount of repeated
/// code between the `create` and `update` methods of the various widgets
/// (since the `update` method is always called between calling `create`
/// and actually displaying the widget anyway).
public protocol AppBackend {
    associatedtype Window
    associatedtype Widget
    associatedtype Menu
    associatedtype Alert

    /// The default height of a table row excluding cell padding. This is a
    /// recommendation by the backend that SwiftCrossUI won't necessarily
    /// follow in all cases.
    var defaultTableRowContentHeight: Int { get }
    /// The default vertical padding to apply to table cells. This is a
    /// recommendation by the backend that SwiftCrossUI won't necessarily
    /// follow in all cases. This is the amount of padding added above and
    /// below each cell, not the total amount added along the vertical axis.
    var defaultTableCellVerticalPadding: Int { get }
    /// The default amount of padding used when a user uses the ``View/padding(_:_:)``
    /// modifier.
    var defaultPaddingAmount: Int { get }
    /// Gets the layout width of a backend's scroll bars. Assumes that the width
    /// is the same for both vertical and horizontal scroll bars (where the width
    /// of a horizontal scroll bar is what pedants may call its height). If the
    /// backend uses overlay scroll bars then this width should be 0.
    ///
    /// This value may make sense to have as a computed property for some backends
    /// such as `AppKitBackend` where plugging in a mouse can cause the default
    /// scroll bar style to change. If something does cause this value to change,
    /// ensure that the configured root environment change handler gets called so
    /// that SwiftCrossUI can update the app's layout accordingly.
    var scrollBarWidth: Int { get }

    /// Often in UI frameworks (such as Gtk), code is run in a callback
    /// after starting the app, and hence this generic root window creation
    /// API must reflect that. This is always the first method to be called
    /// and is where boilerplate app setup should happen.
    ///
    /// Runs the backend's main run loop. The app will exit when this method
    /// returns. This wall always be the first method called by SwiftCrossUI.
    ///
    /// The callback is where SwiftCrossUI will create windows, render
    /// initial views, start state handlers, etc. The setup action must be
    /// run exactly once. The backend must be fully functional before the
    /// callback is ready.
    ///
    /// It is up to the backend to decide whether the callback runs before or
    /// after the main loop starts. For example, some backends such as the `AppKit`
    /// backend can create windows and widgets before the run loop starts, so it
    /// makes the most sense to run the setup before the main run loop starts (it's
    /// also not possible to run the setup function once the main run loop starts
    /// anyway). On the other side is the `Gtk` backend which must be on the
    /// main loop to create windows and widgets (because otherwise the root
    /// window has not yet been created, which is essential in Gtk), so the
    /// setup function is passed to `Gtk` as a callback to run once the main
    /// run loop starts.
    func runMainLoop(
        _ callback: @escaping () -> Void
    )
    /// Creates a new window. For some backends it may make sense for this
    /// method to return the application's root window the first time its
    /// called, and only create new windows on subsequent invocations.
    ///
    /// The default size is a suggestion; for example some backends may choose
    /// to restore the user's preferred window size from a previous session.
    ///
    /// A window's content size has precendence over the default size. The
    /// window should always be at least the size of its content.
    func createWindow(withDefaultSize defaultSize: SIMD2<Int>?) -> Window
    /// Sets the title of a window.
    func setTitle(ofWindow window: Window, to title: String)
    /// Sets the resizability of a window. Even if resizable, the window
    /// shouldn't be allowed to become smaller than its content.
    func setResizability(ofWindow window: Window, to resizable: Bool)
    /// Sets the root child of a window (replaces the previous child if any).
    func setChild(ofWindow window: Window, to child: Widget)
    /// Gets the size of the given window in pixels.
    func size(ofWindow window: Window) -> SIMD2<Int>
    /// Sets the size of the given window in pixels.
    func setSize(ofWindow window: Window, to newSize: SIMD2<Int>)
    /// Sets the minimum width and height of the window. Prevents the user from making the
    /// window any smaller than the given size.
    func setMinimumSize(ofWindow window: Window, to minimumSize: SIMD2<Int>)
    /// Sets the handler for the window's resizing events. `action` takes the proposed size
    /// of the window and returns the final size for the window (which allows SwiftCrossUI
    /// to implement features such as dynamic minimum window sizes based off the content's
    /// minimum size). Setting the resize handler overrides any previous handler.
    func setResizeHandler(
        ofWindow window: Window,
        to action: @escaping (_ newSize: SIMD2<Int>) -> Void
    )
    /// Shows a window after it has been created or updated (may be unnecessary
    /// for some backends). Predominantly used by window-based ``Scene``
    /// implementations after propagating updates.
    func show(window: Window)
    /// Brings a window to the front if possible. Called when the window
    /// receives an external URL or file to handle from the desktop environment.
    /// May be used in other circumstances eventually.
    func activate(window: Window)

    /// Sets the application's global menu. Some backends may make use of the host
    /// platform's global menu bar (such as macOS's menu bar), and others may render their
    /// own menu bar within the application.
    func setApplicationMenu(_ submenus: [ResolvedMenu.Submenu])

    /// Runs an action in the app's main thread if required to perform UI updates
    /// by the backend. Predominantly used by ``Publisher`` to publish changes to a thread
    /// compatible with dispatching UI updates. Can be synchronous or asynchronous (for now).
    func runInMainThread(action: @escaping () -> Void)

    /// Computes the root environment for an app (e.g. by checking the system's current
    /// theme). May fall back on the provided defaults where reasonable.
    func computeRootEnvironment(defaultEnvironment: EnvironmentValues) -> EnvironmentValues
    /// Sets the handler to be notified when the root environment may have to get
    /// recomputed. This is intended to only be called once. Calling it more than once
    /// may or may not override the previous handler.
    func setRootEnvironmentChangeHandler(to action: @escaping () -> Void)

    /// Sets the handler for URLs directed to the application (e.g. URLs
    /// associated with a custom URL scheme).
    func setIncomingURLHandler(to action: @escaping (URL) -> Void)

    /// Shows a widget after it has been created or updated (may be unnecessary
    /// for some backends). Predominantly used by ``ViewGraphNode`` after
    /// propagating updates.
    func show(widget: Widget)
    /// Adds a short tag to a widget to assist during debugging if the backend supports
    /// such a feature. Some backends may only apply tags under particular conditions
    /// such as when being built in debug mode.
    func tag(widget: Widget, as tag: String)

    // MARK: Containers

    /// Creates a container in which children can be layed out by SwiftCrossUI using exact
    /// pixel positions.
    func createContainer() -> Widget
    /// Removes all children of the given container.
    func removeAllChildren(of container: Widget)
    /// Adds a child to a given container at an exact position.
    func addChild(_ child: Widget, to container: Widget)
    /// Sets the position of the specified child in a container.
    func setPosition(ofChildAt index: Int, in container: Widget, to position: SIMD2<Int>)
    /// Removes a child widget from a container (if the child is a direct child of the container).
    func removeChild(_ child: Widget, from container: Widget)

    /// Creates a rectangular widget with configurable color.
    func createColorableRectangle() -> Widget
    /// Sets the color of a colorable rectangle.
    func setColor(ofColorableRectangle widget: Widget, to color: Color)

    /// Sets the corner radius of a widget (any widget). Should affect the view's border radius
    /// as well.
    func setCornerRadius(of widget: Widget, to radius: Int)

    /// Gets the natural size of a given widget. E.g. the natural size of a button may be the size
    /// of the label (without line wrapping) plus a bit of padding and a border.
    func naturalSize(of widget: Widget) -> SIMD2<Int>
    /// Sets the size of a widget.
    func setSize(of widget: Widget, to size: SIMD2<Int>)

    /// Creates a scrollable single-child container wrapping the given widget.
    func createScrollContainer(for child: Widget) -> Widget
    /// Sets the presence of scroll bars along each axis of a scroll container.
    func setScrollBarPresence(
        ofScrollContainer scrollView: Widget,
        hasVerticalScrollBar: Bool,
        hasHorizontalScrollBar: Bool
    )

    /// Creates a split view containing two children visible side by side.
    ///
    /// If you need to modify the leading and trailing children after creation nest them
    /// inside another container such as a VStack (avoiding update methods makes maintaining
    /// a multitude of backends a bit easier).
    func createSplitView(leadingChild: Widget, trailingChild: Widget) -> Widget
    /// Sets the function to be called when the split view's panes get resized.
    func setResizeHandler(
        ofSplitView splitView: Widget,
        to action: @escaping () -> Void
    )
    /// Gets the width of a split view's sidebar.
    func sidebarWidth(ofSplitView splitView: Widget) -> Int
    /// Sets the minimum and maximum width of a split view's sidebar.
    func setSidebarWidthBounds(
        ofSplitView splitView: Widget,
        minimum minimumWidth: Int,
        maximum maximumWidth: Int
    )

    // MARK: Passive views

    /// Creates a non-editable text view with optional text wrapping. Predominantly used
    /// by ``Text``.`
    func createTextView() -> Widget
    /// Sets the content and wrapping mode of a non-editable text view.
    func updateTextView(_ textView: Widget, content: String, environment: EnvironmentValues)
    /// Gets the size that the given text would have if it were layed out attempting to stay
    /// within the proposed frame (most backends only use the proposed width and ignore the
    /// proposed height). The size returned by this function will be upheld by the layout
    /// system; child views always get the final say on their own size, parents just choose how
    /// the children get layed out.
    ///
    /// If `proposedFrame` isn't supplied, the text should be layed out on a single line
    /// taking up as much width as it needs.
    func size(
        of text: String,
        whenDisplayedIn textView: Widget,
        proposedFrame: SIMD2<Int>?,
        environment: EnvironmentValues
    ) -> SIMD2<Int>

    /// Creates an image view from an image file (specified by path). Predominantly used
    /// by ``Image``.
    func createImageView() -> Widget
    /// Sets the image data to be displayed.
    /// - Parameters:
    ///   - imageView: The image view to update.
    ///   - rgbaData: The pixel data (as rows of pixels concatenated into a flat array).
    ///   - width: The width of the image in pixels (should only be used to interpret `rgbaData`, not
    ///     to influence the size of the image on-screen).
    ///   - height: The height of the image in pixels (should only be used to interpret `rgbaData`, not
    ///     to influence the size of the image on-screen).
    ///   - targetWidth: The width that the image must have on-screen. Guaranteed to match
    ///     the width the widget will be given, so backends that don't have to manually
    ///     scale the underlying pixel data can safely ignore this parameter.
    ///   - targetHeight: the height that the image must have on-screen. Guaranteed to match
    ///     the height the widget will be given, so backends that don't have to manually
    ///     scale the underlying pixel data can safely ignore this parameter.
    ///   - dataHasChanged: If `false`, then `rgbaData` hasn't changed since the last call,
    ///     so backends that don't have to manually resize the image data don't have to do
    ///     anything.
    func updateImageView(
        _ imageView: Widget,
        rgbaData: [UInt8],
        width: Int,
        height: Int,
        targetWidth: Int,
        targetHeight: Int,
        dataHasChanged: Bool
    )

    /// Creates an empty table.
    func createTable() -> Widget
    /// Sets the number of rows of a table. Existing rows outside of the new bounds should
    /// be deleted.
    func setRowCount(ofTable table: Widget, to rows: Int)
    /// Sets the labels of a table's columns. Also sets the number of columns of the table to the
    /// number of labels provided.
    func setColumnLabels(ofTable table: Widget, to labels: [String], environment: EnvironmentValues)
    /// Sets the contents of the table as a flat array of cells in order of and grouped by row. Also
    /// sets the height of each row's content.
    ///
    /// A nested array would have significantly more overhead, especially for large arrays.
    func setCells(ofTable table: Widget, to cells: [Widget], withRowHeights rowHeights: [Int])

    // MARK: Controls

    /// Creates a labelled button with an action triggered on click. Predominantly used
    /// by ``Button``.
    func createButton() -> Widget
    /// Sets a button's label and action. The action replaces any existing actions.
    func updateButton(
        _ button: Widget,
        label: String,
        action: @escaping () -> Void,
        environment: EnvironmentValues
    )

    /// Creates a labelled toggle that is either on or off. Predominantly used by
    /// ``Toggle``.
    func createToggle() -> Widget
    /// Sets the label and change handler of a toggle (replaces any existing change handlers).
    /// The change handler is called whenever the button is toggled on or off.
    func updateToggle(_ toggle: Widget, label: String, onChange: @escaping (Bool) -> Void)
    /// Sets the state of the button to active or not.
    func setState(ofToggle toggle: Widget, to state: Bool)

    /// Creates a switch that is either on or off. Predominantly used by ``Switch``
    func createSwitch() -> Widget
    /// Sets the change handler of a switch (replaces any existing change handlers).
    /// The change handler is called whenever the button is toggled on or off.
    func updateSwitch(_ switchWidget: Widget, onChange: @escaping (Bool) -> Void)
    /// Sets the state of the switch to active or not.
    func setState(ofSwitch switchWidget: Widget, to state: Bool)

    /// Creates a slider for choosing a numerical value from a range. Predominantly used
    /// by ``Slider``.
    func createSlider() -> Widget
    /// Sets the minimum and maximum selectable value of a slider (inclusive), the number of decimal
    /// places displayed by the slider, and the slider's change handler (replaces any existing
    /// change handlers).
    func updateSlider(
        _ slider: Widget,
        minimum: Double,
        maximum: Double,
        decimalPlaces: Int,
        onChange: @escaping (Double) -> Void
    )
    /// Sets the selected value of a slider.
    func setValue(ofSlider slider: Widget, to value: Double)

    /// Creates an editable text field with a placeholder label and change handler. The
    /// change handler is called whenever the displayed value changes. Predominantly
    /// used by ``TextField``.
    func createTextField() -> Widget
    /// Sets the placeholder label and change handler of an editable text field. The new
    /// change handler replaces any existing change handlers, and is called whenever the
    /// displayed value changes. `onSubmit` gets called when the user hits Enter/Return,
    /// or whatever the backend decides counts as submission of the field.
    ///
    /// The backend shouldn't wait until the user finishes typing to call the change handler;
    /// it should allow live access to the value.
    func updateTextField(
        _ textField: Widget,
        placeholder: String,
        environment: EnvironmentValues,
        onChange: @escaping (String) -> Void,
        onSubmit: @escaping () -> Void
    )
    /// Sets the value of an editable text field.
    func setContent(ofTextField textField: Widget, to content: String)
    /// Gets the value of an editable text field.
    func getContent(ofTextField textField: Widget) -> String

    /// Creates a picker for selecting from a finite set of options (e.g. a radio button group,
    /// a drop-down, a picker wheel). Predominantly used by ``Picker``. The change handler is
    /// called whenever a selection is made (even if the same option is picked again).
    func createPicker() -> Widget
    /// Sets the options for a picker to display, along with a change handler for when its
    /// selected option changes. The change handler replaces any existing change handlers and
    /// is called whenever a selection is made (even if the same option is picked again).
    func updatePicker(
        _ picker: Widget,
        options: [String],
        environment: EnvironmentValues,
        onChange: @escaping (Int?) -> Void
    )
    /// Sets the index of the selected option of a picker.
    func setSelectedOption(ofPicker picker: Widget, to selectedOption: Int?)

    /// Creates an indeterminate progress spinner.
    func createProgressSpinner() -> Widget

    /// Creates a progress bar.
    func createProgressBar() -> Widget
    /// Updates a progress bar to reflect the given progress (between 0 and 1), and the
    /// current view environment.
    /// - Parameter progressFraction: If `nil`, then the bar should show an indeterminate
    ///   animation if possible.
    func updateProgressBar(
        _ widget: Widget,
        progressFraction: Double?,
        environment: EnvironmentValues
    )

    /// Creates a popover menu (the sort you often see when right clicking on
    /// apps). The menu won't be visible until you call
    /// ``AppBackend/showPopoverMenu(_:at:relativeTo:closeHandler:)``.
    func createPopoverMenu() -> Menu
    /// Updates a popover menu's content and appearance.
    func updatePopoverMenu(
        _ menu: Menu,
        content: ResolvedMenu,
        environment: EnvironmentValues
    )
    /// Shows the popover menu at a position relative to the given widget.
    func showPopoverMenu(
        _ menu: Menu,
        at position: SIMD2<Int>,
        relativeTo widget: Widget,
        closeHandler handleClose: @escaping () -> Void
    )

    /// Creates an alert object (without showing it yet). Alerts contain a
    /// title, an optional body, and a set of action buttons. They also
    /// prevent users from interacting with the parent window until dimissed.
    func createAlert() -> Alert
    /// Updates the content and appearance of an alert. Can only be called once.
    func updateAlert(
        _ alert: Alert,
        title: String,
        actionLabels: [String],
        environment: EnvironmentValues
    )
    /// Shows an alert as a modal on top of or within the given window.
    /// Users should be unable to interact with the parent window until the
    /// alert gets dismissed. `handleResponse` must get called once an action
    /// button is selected, with its sole argument representing the index of
    /// the action selected (as per the `actionLabels` array). The alert will
    /// have been hidden by the time the response handler gets called.
    ///
    /// Must only get called once for any given alert.
    ///
    /// If `window` is `nil`, the backend can either make the alert a whole
    /// app modal, a standalone window, or a modal for a window of its choosing.
    func showAlert(
        _ alert: Alert,
        window: Window?,
        responseHandler handleResponse: @escaping (Int) -> Void
    )
    /// Dismisses an alert programmatically without invoking the response
    /// handler. Must only be called after
    /// ``showAlert(_:window:responseHandler:)``.
    func dismissAlert(_ alert: Alert, window: Window?)

    /// Presents an 'Open file' dialog to the user for selecting files or
    /// folders.
    ///
    /// If `window` is `nil`, the backend can either make the dialog a whole
    /// app modal, a standalone window, or a modal for a window of its choosing.
    func showOpenDialog(
        fileDialogOptions: FileDialogOptions,
        openDialogOptions: OpenDialogOptions,
        window: Window?,
        resultHandler handleResult: @escaping (DialogResult<[URL]>) -> Void
    )

    /// Presents a 'Save file' dialog to the user for selecting a file save
    /// destination.
    ///
    /// If `window` is `nil`, the backend can either make the dialog a whole
    /// app modal, a standalone window, or a modal for a window of its choosing.
    func showSaveDialog(
        fileDialogOptions: FileDialogOptions,
        saveDialogOptions: SaveDialogOptions,
        window: Window?,
        resultHandler handleResult: @escaping (DialogResult<URL>) -> Void
    )

    /// Wraps a view in a container that can receive click events. Some
    /// backends may not have to wrap the child, in which case they have the
    /// freedom to just return the child as is.
    func createClickTarget(wrapping child: Widget) -> Widget
    /// Update the click target with a new click handler. Replaces the old
    /// click handler.
    func updateClickTarget(
        _ clickTarget: Widget,
        clickHandler handleClick: @escaping () -> Void
    )
}

extension AppBackend {
    public func tag(widget: Widget, as tag: String) {
        // This is only really to assist contributors when debugging backends,
        // so it's safe enough to have a no-op default implementation.
    }
}

extension AppBackend {
    /// Used by placeholder implementations of backend methods.
    private func todo(_ function: String = #function) -> Never {
        print("\(type(of: self)): \(function) not implemented")
        Foundation.exit(1)
    }

    // MARK: Application

    public func setApplicationMenu(_ submenus: [ResolvedMenu.Submenu]) {
        todo()
    }

    public func setIncomingURLHandler(to action: @escaping (URL) -> Void) {
        todo()
    }

    // MARK: Containers

    public func createColorableRectangle() -> Widget {
        todo()
    }

    public func setColor(ofColorableRectangle widget: Widget, to color: Color) {
        todo()
    }

    public func setCornerRadius(of widget: Widget, to radius: Int) {
        todo()
    }

    public func createScrollContainer(for child: Widget) -> Widget {
        todo()
    }

    public func setScrollBarPresence(
        ofScrollContainer scrollView: Widget,
        hasVerticalScrollBar: Bool,
        hasHorizontalScrollBar: Bool
    ) {
        todo()
    }

    public func createSplitView(leadingChild: Widget, trailingChild: Widget) -> Widget {
        todo()
    }

    public func setResizeHandler(
        ofSplitView splitView: Widget,
        to action: @escaping () -> Void
    ) {
        todo()
    }

    public func sidebarWidth(ofSplitView splitView: Widget) -> Int {
        todo()
    }

    public func setSidebarWidthBounds(
        ofSplitView splitView: Widget,
        minimum minimumWidth: Int,
        maximum maximumWidth: Int
    ) {
        todo()
    }

    // MARK: Passive views

    public func createTextView(content: String, shouldWrap: Bool) -> Widget {
        todo()
    }
    public func updateTextView(
        _ textView: Widget,
        content: String,
        environment: EnvironmentValues
    ) {
        todo()
    }
    public func size(
        of text: String,
        whenDisplayedIn textView: Widget,
        proposedFrame: SIMD2<Int>?,
        environment: EnvironmentValues
    ) -> SIMD2<Int> {
        todo()
    }

    public func createImageView() -> Widget {
        todo()
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
        todo()
    }

    public func createTable() -> Widget {
        todo()
    }
    public func setRowCount(ofTable table: Widget, to rows: Int) {
        todo()
    }
    public func setColumnLabels(
        ofTable table: Widget,
        to labels: [String],
        environment: EnvironmentValues
    ) {
        todo()
    }
    public func setCells(
        ofTable table: Widget,
        to cells: [Widget],
        withRowHeights rowHeights: [Int]
    ) {
        todo()
    }

    // MARK: Controls

    public func createButton() -> Widget {
        todo()
    }
    public func updateButton(
        _ button: Widget,
        label: String,
        action: @escaping () -> Void,
        environment: EnvironmentValues
    ) {
        todo()
    }

    public func createToggle() -> Widget {
        todo()
    }
    public func updateToggle(_ toggle: Widget, label: String, onChange: @escaping (Bool) -> Void) {
        todo()
    }
    public func setState(ofToggle toggle: Widget, to state: Bool) {
        todo()
    }

    public func createSwitch() -> Widget {
        todo()
    }
    public func updateSwitch(
        _ switchWidget: Widget, onChange: @escaping (Bool) -> Void
    ) {
        todo()
    }
    public func setState(ofSwitch switchWidget: Widget, to state: Bool) {
        todo()
    }

    public func createSlider() -> Widget {
        todo()
    }
    public func updateSlider(
        _ slider: Widget,
        minimum: Double,
        maximum: Double,
        decimalPlaces: Int,
        onChange: @escaping (Double) -> Void
    ) {
        todo()
    }
    public func setValue(ofSlider slider: Widget, to value: Double) {
        todo()
    }

    public func createTextField() -> Widget {
        todo()
    }
    public func updateTextField(
        _ textField: Widget,
        placeholder: String,
        environment: EnvironmentValues,
        onChange: @escaping (String) -> Void,
        onSubmit: @escaping () -> Void
    ) {
        todo()
    }
    public func setContent(ofTextField textField: Widget, to content: String) {
        todo()
    }
    public func getContent(ofTextField textField: Widget) -> String {
        todo()
    }

    public func createPicker() -> Widget {
        todo()
    }
    public func updatePicker(
        _ picker: Widget,
        options: [String],
        environment: EnvironmentValues,
        onChange: @escaping (Int?) -> Void
    ) {
        todo()
    }
    public func setSelectedOption(ofPicker picker: Widget, to selectedOption: Int?) {
        todo()
    }

    public func createProgressSpinner() -> Widget {
        todo()
    }

    public func createProgressBar() -> Widget {
        todo()
    }
    public func updateProgressBar(
        _ widget: Widget,
        progressFraction: Double?,
        environment: EnvironmentValues
    ) {
        todo()
    }

    public func createPopoverMenu() -> Menu {
        todo()
    }
    public func updatePopoverMenu(
        _ menu: Menu,
        content: ResolvedMenu,
        environment: EnvironmentValues
    ) {
        todo()
    }
    public func showPopoverMenu(
        _ menu: Menu,
        at position: SIMD2<Int>,
        relativeTo widget: Widget,
        closeHandler handleClose: @escaping () -> Void
    ) {
        todo()
    }

    public func createAlert() -> Alert {
        todo()
    }
    public func updateAlert(
        _ alert: Alert,
        title: String,
        actionLabels: [String],
        environment: EnvironmentValues
    ) {
        todo()
    }
    public func showAlert(
        _ alert: Alert,
        window: Window?,
        responseHandler handleResponse: @escaping (Int) -> Void
    ) {
        todo()
    }
    public func dismissAlert(_ alert: Alert, window: Window?) {
        todo()
    }

    public func showOpenDialog(
        fileDialogOptions: FileDialogOptions,
        openDialogOptions: OpenDialogOptions,
        window: Window?,
        resultHandler handleResult: @escaping (DialogResult<[URL]>) -> Void
    ) {
        todo()
    }
    public func showSaveDialog(
        fileDialogOptions: FileDialogOptions,
        saveDialogOptions: SaveDialogOptions,
        window: Window?,
        resultHandler handleResult: @escaping (DialogResult<URL>) -> Void
    ) {
        todo()
    }

    public func createClickTarget(wrapping child: Widget) -> Widget {
        todo()
    }
    public func updateClickTarget(
        _ clickTarget: Widget,
        clickHandler handleClick: @escaping () -> Void
    ) {
        todo()
    }
}
