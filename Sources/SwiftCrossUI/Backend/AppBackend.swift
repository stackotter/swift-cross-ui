import Foundation

// TODO: Find a way to get rid of this if possible. Required for getting onto the correct main thread from `Publisher`
/// The currently selected backend. Used by ``Publisher`` which is otherwise
/// unaware of the current backend.
var currentBackend: (any AppBackend)!

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

    init(appIdentifier: String)

    /// Often in UI frameworks (such as Gtk), code is run in a callback
    /// after starting the app, and hence this generic root window creation
    /// API must reflect that. This is always the first method to be called
    /// and is where boilerplate app setup should happen.

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
    func createWindow(withDefaultSize defaultSize: Size?) -> Window
    /// Sets the title of a window.
    func setTitle(ofWindow window: Window, to title: String)
    /// Sets the resizability of a window. Even if resizable, the window
    /// shouldn't be allowed to become smaller than its content.
    func setResizability(ofWindow window: Window, to resizable: Bool)
    /// Sets the root child of a window (replaces the previous child if any).
    func setChild(ofWindow window: Window, to child: Widget)
    /// Shows a window after it has been created or updated (may be unnecessary
    /// for some backends). Predominantly used by window-based ``Scene``
    /// implementations after propagating updates.
    func show(window: Window)

    /// Runs an action in the app's main thread if required to perform UI updates
    /// by the backend. Predominantly used by ``Publisher`` to publish changes to a thread
    /// compatible with dispatching UI updates.
    func runInMainThread(action: @escaping () -> Void)

    /// Shows a widget after it has been created or updated (may be unnecessary
    /// for some backends). Predominantly used by ``ViewGraphNode`` after
    /// propagating updates.
    func show(widget: Widget)

    // MARK: Containers

    /// Creates a vertical container. Predominantly used by ``VStack``.`
    func createVStack() -> Widget
    /// Sets the children of a VStack. Will be called once and only once per VStack.
    func setChildren(_ children: [Widget], ofVStack container: Widget)
    /// Sets the spacing between children of a vertical container.
    func setSpacing(ofVStack widget: Widget, to spacing: Int)

    /// Creates a horizontal container. Predominantly used by ``HStack``.`
    func createHStack() -> Widget
    /// Sets the children of a VStack. Will be called once and only once per HStack.
    func setChildren(_ children: [Widget], ofHStack container: Widget)
    /// Sets the spacing between children of a horizontal container.
    func setSpacing(ofHStack widget: Widget, to spacing: Int)

    /// Creates a single-child container. Predominantly used to implement ``EitherView``.
    func createSingleChildContainer() -> Widget
    /// Sets the child of a single-child container. Only called once the container has been
    /// added to the widget hierarchy.
    func setChild(ofSingleChildContainer container: Widget, to widget: Widget?)

    /// Creates a view with a (theoretically) unlimited number of children, which inherits the
    /// orientation of its nearest oriented parent. Should be vertical if it doesn't have any
    /// oriented parents. Often used as a layout-transparent container (e.g. by
    /// ``ViewGraphNodeChildren`` implementations which use it to avoid partaking in layout).
    /// Also used by to implement ``ForEach``.
    func createLayoutTransparentStack() -> Widget
    /// Adds a child to the end of a layout-transparent stack.
    func addChild(_ child: Widget, toLayoutTransparentStack container: Widget)
    /// Removes a child from a layout-transparent stack. Does nothing if the child doesn't exist.
    func removeChild(_ child: Widget, fromLayoutTransparentStack container: Widget)
    /// Updates a layout-transparent stack's orientation to match that of its nearest oriented
    /// parent.
    func updateLayoutTransparentStack(_ container: Widget)

    /// Creates a scrollable single-child container wrapping the given widget.
    func createScrollContainer(for child: Widget) -> Widget

    /// Creates a container that can (theoretically) have an unlimited number of children
    /// while only displaying one child at a time (selected using ``Backend/setVisibleChild``).
    /// Differs from ``AppBackend/createSingleChildContainer()`` because it allows
    /// transitions to be displayed when switching between children (unlike the single child
    /// container which only ever has the current widget as its child meaning that it can't
    /// do transitions).
    func createOneOfContainer() -> Widget
    /// Adds a child to a one-of container.
    func addChild(_ child: Widget, toOneOfContainer container: Widget)
    /// Removes a child from a one-of container.
    func removeChild(_ child: Widget, fromOneOfContainer container: Widget)
    /// Sets the visible child of a one-of container. Uses a widget reference instead of an
    /// index since the visible child should remain the same even if the visible child's
    /// index changes (e.g. due to a child being removed from before the visible child).
    func setVisibleChild(ofOneOfContainer container: Widget, to child: Widget)

    /// Creates a split view containing two children visible side by side.
    ///
    /// If you need to modify the leading and trailing children after creation nest them
    /// inside another container such as a VStack (avoiding update methods makes maintaining
    /// a multitude of backends a bit easier).
    func createSplitView(leadingChild: Widget, trailingChild: Widget) -> Widget

    // MARK: Layout

    /// Creates a contentless spacer that can expand along either axis (or both). The spacer
    /// can have a minimum size to ensure that it takes up at least a cetain amount of space.
    func createSpacer() -> Widget
    /// Sets whether a spacer should expand along the horizontal and vertical axes, along
    /// with a minimum size to use along expanding axes.
    func updateSpacer(
        _ spacer: Widget,
        expandHorizontally: Bool,
        expandVertically: Bool,
        minSize: Int
    )

    /// Gets the orientation of a widget's first oriented parent (if any).
    func getInheritedOrientation(of widget: Widget) -> InheritedOrientation?

    // MARK: Passive views

    /// Creates a non-editable text view with optional text wrapping. Predominantly used
    /// by ``Text``.`
    func createTextView() -> Widget
    /// Sets the content and wrapping mode of a non-editable text view. If `shouldWrap`
    /// is `false`, text shouldn't be wrapped onto multiple lines.
    func updateTextView(_ textView: Widget, content: String, shouldWrap: Bool)

    /// Creates an image view from an image file (specified by path). Predominantly used
    /// by ``Image``.
    func createImageView(filePath: String) -> Widget
    /// Sets the path of the image file being displayed by an image view.
    func updateImageView(_ imageView: Widget, filePath: String)

    /// Creates a table with an initial number of rows and columns.
    func createTable(rows: Int, columns: Int) -> Widget
    /// Sets the number of rows of a table. Existing rows outside of the new bounds should
    /// be deleted.
    func setRowCount(ofTable table: Widget, to rows: Int)
    /// Sets the number of columns of a table. Existing columns outside of the new bounds
    /// should be deleted.
    func setColumnCount(ofTable table: Widget, to columns: Int)
    /// Sets the contents of the table cell at the given position in a table.
    func setCell(at position: CellPosition, inTable table: Widget, to widget: Widget)

    // MARK: Controls

    /// Creates a labelled button with an action triggered on click. Predominantly used
    /// by ``Button``.
    func createButton() -> Widget
    /// Sets a button's label and action. The action replaces any existing actions..
    func updateButton(_ button: Widget, label: String, action: @escaping () -> Void)

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
    /// displayed value changes.
    ///
    /// The backend shouldn't wait until the user finishes typing to call the change handler;
    /// it should allow live access to the value.
    func updateTextField(
        _ textField: Widget, placeholder: String, onChange: @escaping (String) -> Void
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
    func updatePicker(_ picker: Widget, options: [String], onChange: @escaping (Int?) -> Void)
    /// Sets the index of the selected option of a picker.
    func setSelectedOption(ofPicker picker: Widget, to selectedOption: Int?)

    // MARK: Modifiers

    /// Creates a single-child container which can have size constraints. Used to
    /// implement the ``View/frame(minWidth:maxWidth:)`` modifier.
    func createFrameContainer(for child: Widget) -> Widget
    /// Sets the minimum width and minimum height of a frame container.
    func updateFrameContainer(_ container: Widget, minWidth: Int, minHeight: Int)

    /// Creates a single-child container with configurable padding. Used
    /// to implement the ``View/padding(_:)`` and ``View/padding(_:_:)`` modifiers.
    func createPaddingContainer(for child: Widget) -> Widget
    /// Sets the padding of a padding container.
    func setPadding(
        ofPaddingContainer container: Widget,
        top: Int,
        bottom: Int,
        leading: Int,
        trailing: Int
    )

    /// Creates a single-child container which can control the styles of its child.
    /// Used to implement style modifiers; i.e. ``View/foregroundColor(_:)``.
    func createStyleContainer(for child: Widget) -> Widget
    /// Sets the foreground color of a foreground color container.
    func setForegroundColor(ofStyleContainer container: Widget, to color: Color)
}

extension AppBackend {
    /// A helper to add multiple type-erased children to a vertical container at once.
    /// Will crash if any of the widgets are for a different backend. Should be called
    /// once and only once per VStack.
    public func setChildren(_ children: [AnyWidget], ofVStack container: Widget) {
        setChildren(
            children.map { child -> Widget in child.into() },
            ofVStack: container
        )
    }

    /// A helper to add multiple type-erased children to a horizontal container at once.
    /// Will crash if any of the widgets are for a different backend. Should be called
    /// once and only once per HStack.
    public func setChildren(_ children: [AnyWidget], ofHStack container: Widget) {
        setChildren(
            children.map { child -> Widget in child.into() },
            ofHStack: container
        )
    }

    /// A helper to add multiple children to a layout-transparent container at once.
    public func addChildren(_ children: [Widget], toLayoutTransparentStack container: Widget) {
        for child in children {
            addChild(child, toLayoutTransparentStack: container)
        }
    }

    /// A helper to add multiple type-erased children to a layout-transparent container
    /// at once. Will crash if any of the widgets are for a different backend.
    public func addChildren(_ children: [AnyWidget], toLayoutTransparentStack container: Widget) {
        addChildren(
            children.map { child -> Widget in child.into() },
            toLayoutTransparentStack: container
        )
    }
}

extension AppBackend {
    /// Used by placeholder implementations of backend methods.
    private func todo(_ function: String = #function) -> Never {
        print("\(type(of: self)): \(function) not implemented")
        Foundation.exit(1)
    }

    // MARK: Containers

    public func createVStack() -> Widget {
        todo()
    }
    public func setChildren(_ children: [Widget], ofVStack container: Widget) {
        todo()
    }
    public func setSpacing(ofVStack widget: Widget, to spacing: Int) {
        todo()
    }

    public func createHStack() -> Widget {
        todo()
    }
    public func setChildren(_ children: [Widget], ofHStack container: Widget) {
        todo()
    }
    public func setSpacing(ofHStack widget: Widget, to spacing: Int) {
        todo()
    }

    public func createSingleChildContainer() -> Widget {
        todo()
    }
    public func setChild(ofSingleChildContainer container: Widget, to widget: Widget?) {
        todo()
    }

    public func createLayoutTransparentStack() -> Widget {
        todo()
    }
    public func addChild(_ child: Widget, toLayoutTransparentStack container: Widget) {
        todo()
    }
    public func removeChild(_ child: Widget, fromLayoutTransparentStack container: Widget) {
        todo()
    }
    public func updateLayoutTransparentStack(_ container: Widget) {
        todo()
    }

    public func createScrollContainer(for child: Widget) -> Widget {
        todo()
    }

    public func createOneOfContainer() -> Widget {
        todo()
    }
    public func addChild(_ child: Widget, toOneOfContainer container: Widget) {
        todo()
    }
    public func removeChild(_ child: Widget, fromOneOfContainer container: Widget) {
        todo()
    }
    public func setVisibleChild(ofOneOfContainer container: Widget, to child: Widget) {
        todo()
    }

    public func createSplitView(leadingChild: Widget, trailingChild: Widget) -> Widget {
        todo()
    }

    // MARK: Layout

    public func createSpacer() -> Widget {
        todo()
    }
    public func updateSpacer(
        _ spacer: Widget, expandHorizontally: Bool, expandVertically: Bool, minSize: Int
    ) {
        todo()
    }

    public func getInheritedOrientation(of widget: Widget) -> InheritedOrientation? {
        todo()
    }

    // MARK: Passive views

    public func createTextView(content: String, shouldWrap: Bool) -> Widget {
        todo()
    }
    public func updateTextView(_ textView: Widget, content: String, shouldWrap: Bool) {
        todo()
    }

    public func createImageView(filePath: String) -> Widget {
        todo()
    }
    public func updateImageView(_ imageView: Widget, filePath: String) {
        todo()
    }

    public func createTable(rows: Int, columns: Int) -> Widget {
        todo()
    }
    public func setRowCount(ofTable table: Widget, to rows: Int) {
        todo()
    }
    public func setColumnCount(ofTable table: Widget, to columns: Int) {
        todo()
    }
    public func setCell(at position: CellPosition, inTable table: Widget, to widget: Widget) {
        todo()
    }

    // MARK: Controls

    public func createButton() -> Widget {
        todo()
    }
    public func updateButton(_ button: Widget, label: String, action: @escaping () -> Void) {
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
        _ slider: Widget, minimum: Double, maximum: Double, decimalPlaces: Int,
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
        _ textField: Widget, placeholder: String, onChange: @escaping (String) -> Void
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
        _ picker: Widget, options: [String], onChange: @escaping (Int?) -> Void
    ) {
        todo()
    }
    public func setSelectedOption(ofPicker picker: Widget, to selectedOption: Int?) {
        todo()
    }

    // MARK: Modifiers

    public func createFrameContainer(for child: Widget) -> Widget {
        todo()
    }
    public func updateFrameContainer(_ container: Widget, minWidth: Int, minHeight: Int) {
        todo()
    }

    public func createPaddingContainer(for child: Widget) -> Widget {
        todo()
    }
    public func setPadding(
        ofPaddingContainer container: Widget,
        top: Int,
        bottom: Int,
        leading: Int,
        trailing: Int
    ) {
        todo()
    }

    public func createStyleContainer(for child: Widget) -> Widget {
        todo()
    }
    public func setForegroundColor(ofStyleContainer container: Widget, to color: Color) {
        todo()
    }
}
