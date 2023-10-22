import Foundation

// TODO: Find a way to get rid of this if possible. Required for getting onto the correct main thread from `Publisher`
/// The currently selected backend. Used by ``Publisher`` which is otherwise
/// unaware of the current backend.
var currentBackend: (any AppBackend)!

/// A backend that can be used to run an app (e.g. Gtk or Qt).
///
/// Default placeholder implementations are available for all methods except
/// for ``Widget/run(_:_:)`` and ``Widget/runInMainThread(action:)``. These
/// implementations will fatally crash when called and are simply intended
/// to allow incremental implementation of backends, not a production-ready
/// fallback for views that cannot be represented by a given backend.
///
/// If you need to modify the children of a widget after creation but there
/// aren't update methods available, this is an intentional limitation to
/// reduce the complexity of maintaining a multitude of backends -- nest
/// another container, such as a VStack, inside the container to allow you
/// to change its children on demand.
public protocol AppBackend {
    associatedtype Widget

    init(appIdentifier: String)

    func run<AppRoot: App>(
        _ app: AppRoot,
        _ setViewGraph: @escaping (ViewGraph<AppRoot>) -> Void
    ) where AppRoot.Backend == Self

    /// Runs an action in the app's main thread if required to perform UI updates
    /// by the backend. Predominantly used by ``Publisher`` to publish changes to a thread
    /// compatible with dispatching UI updates.
    func runInMainThread(action: @escaping () -> Void)

    /// Shows a widget after it got created or updated (may be unnecessary for some backends).
    /// Predominantly used by ``ViewGraphNode`` after propagating updates.
    func show(_ widget: Widget)

    /// Creates a vertical container with the specified spacing between children.
    /// Predominantly used by ``VStack``.`
    func createVStack(spacing: Int) -> Widget
    /// Adds a child to the end of a vertical container.
    func addChild(_ child: Widget, toVStack container: Widget)
    /// Sets the spacing between children of a vertical container.
    func setSpacing(ofVStack widget: Widget, to spacing: Int)

    /// Creates a horizontal container with the specified spacing between children.
    /// Predominantly used by ``HStack``.`
    func createHStack(spacing: Int) -> Widget
    /// Adds a child to the end of a horizontal container.
    func addChild(_ child: Widget, toHStack container: Widget)
    /// Sets the spacing between children of a horizontal container.
    func setSpacing(ofHStack widget: Widget, to spacing: Int)

    /// Creates a container which takes on the orientation of its parent (preferring to be
    /// vertical if it doesn't have any oriented parents). Sometimes referred to as
    /// layout-transparent in SwiftCrossUI code. Predominantly used by the variadic views
    /// and ``ViewGraphNodeChildren`` implementations (to avoid partaking in layout).
    func createPassthroughVStack(spacing: Int) -> Widget
    /// Adds a child to a layout-transparent container.
    func addChild(_ child: Widget, toPassthroughVStack container: Widget)
    /// Updates the orientation of a layout-transparent container to match its nearest
    /// oriented parent (preferring to be vertical if it doesn't have any oriented
    /// parents). Called after any change that could potentially affect parent orientations.
    func updatePassthroughVStack(_ vStack: Widget)

    /// Creates a single-child container suitable for ``EitherView``.
    func createEitherContainer(initiallyContaining child: Widget?) -> Widget
    /// Sets the single child of an either container.
    func setChild(ofEitherContainer container: Widget, to widget: Widget?)

    /// Creates a single-child container with configurable padding. Predominantly used
    /// to implement the ``View/padding(_:)`` and ``View/padding(_:_:)`` modifiers.
    func createPaddingContainer(for child: Widget) -> Widget
    /// Gets the single child of a padding container.
    func getChild(ofPaddingContainer container: Widget) -> Widget
    /// Sets the padding of a padding container.
    func setPadding(
        ofPaddingContainer container: Widget,
        top: Int,
        bottom: Int,
        leading: Int,
        trailing: Int
    )

    /// Creates a scrollable single-child container wrapping the given widget.
    func createScrollContainer(for child: Widget) -> Widget

    /// Creates a labelled button with an action triggered on click. Predominantly used
    /// by ``Button``.
    func createButton(label: String, action: @escaping () -> Void) -> Widget
    /// Sets a button's label.
    func setLabel(ofButton button: Widget, to label: String)
    /// Sets a button's action (triggered on click). Replaces any existing actions.
    func setAction(ofButton button: Widget, to action: @escaping () -> Void)

    /// Creates a non-editable text view with optional text wrapping. Predominantly used
    /// by ``Text``.`
    func createTextView(content: String, shouldWrap: Bool) -> Widget
    /// Sets the content of a non-editable text view.
    func setContent(ofTextView textView: Widget, to content: String)
    /// Sets whether to wrap the text content of a non-editable text view or not.
    func setWrap(ofTextView textView: Widget, to shouldWrap: Bool)

    /// Creates an image view from an image file (specified by path). Predominantly used
    /// by ``Image``.
    func createImageView(filePath: String) -> Widget
    /// Sets the path of the image file being displayed by an image view.
    func setFilePath(ofImageView imageView: Widget, to filePath: String)

    /// Creates contentless spacer that can expand along either axis or both.
    func createSpacer(
        expandHorizontally: Bool, expandVertically: Bool
    ) -> Widget
    /// Sets whether a spacer should expand along the horizontal axis.
    func setExpandHorizontally(ofSpacer spacer: Widget, to expandHorizontally: Bool)
    /// Sets whether a spacer should expand along the vertical axis.
    func setExpandVertically(ofSpacer spacer: Widget, to expandVertically: Bool)

    /// Gets the orientation of a widget's first oriented parent (if any).
    func getInheritedOrientation(of widget: Widget) -> InheritedOrientation?

    /// Creates a slider for choosing a numerical value from a range with a limit
    /// on the number of decimal places displayed and a change handler. Predominantly used
    /// by ``Slider``.
    func createSlider(
        minimum: Double,
        maximum: Double,
        value: Double,
        decimalPlaces: Int,
        onChange: @escaping (Double) -> Void
    ) -> Widget
    /// Sets the minimum selectable value of a slider (inclusive).
    func setMinimum(ofSlider slider: Widget, to minimum: Double)
    /// Sets the maximum selectable value of a slider (inclusive).
    func setMaximum(ofSlider slider: Widget, to maximum: Double)
    /// Sets the selected value of a slider.
    func setValue(ofSlider slider: Widget, to value: Double)
    /// Sets the number of decimal places displayed by a slider.
    func setDecimalPlaces(ofSlider slider: Widget, to decimalPlaces: Int)
    /// Sets the change handler of a slider (replaces any existing change handlers).
    func setOnChange(ofSlider slider: Widget, to onChange: @escaping (Double) -> Void)

    /// Creates an editable text field with a placeholder label and change handler. The
    /// change handler is called whenever the displayed value changes. Predominantly
    /// used by ``TextField``.
    func createTextField(
        content: String, placeholder: String, onChange: @escaping (String) -> Void
    ) -> Widget
    /// Sets the value of an editable text field.
    func setContent(ofTextField textField: Widget, to content: String)
    /// Sets the placeholder label of an editable text field.
    func setPlaceholder(ofTextField textField: Widget, to placeholder: String)
    /// Sets the change handler of an editable text field (replace any existing change
    /// handlers). The change handler is called whenever the displayed value changes.
    /// The backend shouldn't wait until the user finishes typing to call the change handler;
    /// it should allow live access to the value.
    func setOnChange(ofTextField textField: Widget, to onChange: @escaping (String) -> Void)
    /// Gets the value of an editable text field.
    func getContent(ofTextField textField: Widget) -> String

    /// Creates a view with a (theoretically) unlimited number of children. Should inherit the
    /// orientation of its nearest oriented parent.
    func createListView() -> Widget
    /// Adds a child to the end of a list view.
    func addChild(_ child: Widget, toListView listView: Widget)
    /// Removes a child from wherever it is in a list view (if it exists).
    func removeChild(_ child: Widget, fromListView listView: Widget)
    /// Updates the list view's orientation to match that of its nearest oriented parent.
    func updateListView(_ listView: Widget)

    /// Creates a container that can (theoretically) have an unlimited number of children
    /// while only displaying one child at a time (selected using ``Backend/setVisibleChild``).
    func createOneOfContainer() -> Widget
    /// Adds a child to a one-of container.
    func addChild(_ child: Widget, toOneOfContainer container: Widget)
    /// Removes a child from a one-of container.
    func removeChild(_ child: Widget, fromOneOfContainer container: Widget)
    /// Sets the visible child of a one-of container.
    func setVisibleChild(ofOneOfContainer container: Widget, to child: Widget)

    /// Creates a split view containing two children visible side by side.
    ///
    /// If you need to modify the leading and trailing children after creation nest them
    /// inside another container such as a VStack (avoiding update methods makes maintaining
    /// a multitude of backends a bit easier).
    func createSplitView(leadingChild: Widget, trailingChild: Widget) -> Widget

    /// Creates a picker for selecting from a finite set of options (e.g. a radio button group,
    /// a drop-down, a picker wheel). Predominantly used by ``Picker``. The change handler is
    /// called whenever a selection is made (even if the same option is picked again).
    func createPicker(
        options: [String], selectedOption: Int?, onChange: @escaping (Int?) -> Void
    ) -> Widget
    /// Sets the options for a picker to display.
    func setOptions(ofPicker picker: Widget, to options: [String])
    /// Sets the index of the selected option of a picker.
    func setSelectedOption(ofPicker picker: Widget, to selectedOption: Int?)
    /// Sets the change handler of a picker (replaces any existing change handlers). The change
    /// handler is called whenever a selection is made (even if the same option is picked again).
    func setOnChange(ofPicker picker: Widget, to onChange: @escaping (Int?) -> Void)

    /// Creates a single-child container which can have size constraints. Predominantly used to
    /// implement the ``View/frame(minWidth:maxWidth:)`` modifier.
    func createFrameContainer(for child: Widget, minWidth: Int, minHeight: Int) -> Widget
    /// Sets the minimum width of a frame container.
    func setMinWidth(ofFrameContainer container: Widget, to minWidth: Int)
    /// Sets the minimum height of a frame container.
    func setMinHeight(ofFrameContainer container: Widget, to minHeight: Int)

    /// Creates a single-child container which can control the foreground text color of its
    /// child. Predominantly used to implement the ``View/foregroundColor(_:)`` modifier.
    func createForegroundColorContainer(for child: Widget, color: Color) -> Widget
    /// Sets the foreground color of a foreground color container.
    func setForegroundColor(ofForegroundColorContainer container: Widget, to color: Color)

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
}

/// The layout orientation inherited by a widget from its nearest oriented parent.
public enum InheritedOrientation {
    /// The layout orientation used by the likes of ``VStack`` (the default for most containers).
    case vertical
    /// The layout orientation used by the likes of ``HStack``.
    case horizontal
}

/// The position of a cell in a table (with row and column numbers starting from 0).
public struct CellPosition {
    /// The row number starting from 0.
    public var row: Int
    /// The column number starting from 0.
    public var column: Int

    /// Creates a cell position from a row and column number (starting from 0).
    public init(_ row: Int, _ column: Int) {
        self.row = row
        self.column = column
    }
}

extension AppBackend {
    /// A helper to add multiple children to a vertical container at once.
    public func addChildren(_ children: [Widget], toVStack container: Widget) {
        for child in children {
            addChild(child, toVStack: container)
        }
    }

    /// A helper to add multiple type-erased children to a vertical container at once.
    /// Will crash if any of the widgets are for a different backend.
    public func addChildren(_ children: [AnyWidget], toVStack container: Widget) {
        for child in children {
            addChild(child.into(), toVStack: container)
        }
    }

    /// A helper to add multiple children to a horizontal container at once.
    public func addChildren(_ children: [Widget], toHStack container: Widget) {
        for child in children {
            addChild(child, toHStack: container)
        }
    }

    /// A helper to add multiple type-erased children to a horizontal container at once.
    /// Will crash if any of the widgets are for a different backend.
    public func addChildren(_ children: [AnyWidget], toHStack container: Widget) {
        for child in children {
            addChild(child.into(), toHStack: container)
        }
    }

    /// A helper to add multiple children to a layout-transparent container at once.
    public func addChildren(_ children: [Widget], toPassthroughVStack container: Widget) {
        for child in children {
            addChild(child, toPassthroughVStack: container)
        }
    }

    /// A helper to add multiple type-erased children to a layout-transparent container
    /// at once. Will crash if any of the widgets are for a different backend.
    public func addChildren(_ children: [AnyWidget], toPassthroughVStack container: Widget) {
        for child in children {
            addChild(child.into(), toPassthroughVStack: container)
        }
    }
}

extension AppBackend {
    /// Used by placeholder implementations of backend methods.
    private func todo(_ message: String) -> Never {
        print("\(type(of: self)): message")
        Foundation.exit(1)
    }

    public func show(_ widget: Widget) {
        todo("show not implemented")
    }

    public func createVStack(spacing: Int) -> Widget {
        todo("createVStack not implemented")
    }
    public func addChild(_ child: Widget, toVStack container: Widget) {
        todo("addChild not implemented")
    }
    public func setSpacing(ofVStack widget: Widget, to spacing: Int) {
        todo("setSpacing not implemented")
    }

    public func createHStack(spacing: Int) -> Widget {
        todo("createHStack not implemented")
    }
    public func addChild(_ child: Widget, toHStack container: Widget) {
        todo("addChild not implemented")
    }
    public func setSpacing(ofHStack widget: Widget, to spacing: Int) {
        todo("setSpacing not implemented")
    }

    public func createPassthroughVStack(spacing: Int) -> Widget {
        todo("createPassthroughVStack not implemented")
    }
    public func addChild(_ child: Widget, toPassthroughVStack container: Widget) {
        todo("addChild not implemented")
    }
    public func updatePassthroughVStack(_ vStack: Widget) {
        todo("updatePassthroughVStack not implemented")
    }

    public func createEitherContainer(initiallyContaining child: Widget?) -> Widget {
        todo("createEitherContainer not implemented")
    }
    public func setChild(ofEitherContainer container: Widget, to widget: Widget?) {
        todo("setChild not implemented")
    }

    public func createPaddingContainer(for child: Widget) -> Widget {
        todo("createPaddingContainer not implemented")
    }
    public func getChild(ofPaddingContainer container: Widget) -> Widget {
        todo("getChild not implemented")
    }
    public func setPadding(
        ofPaddingContainer container: Widget,
        top: Int,
        bottom: Int,
        leading: Int,
        trailing: Int
    ) {
        todo("setPadding not implemented")
    }

    public func createScrollContainer(for child: Widget) -> Widget {
        todo("createScrollContainer not implemented")
    }

    public func createButton(label: String, action: @escaping () -> Void) -> Widget {
        todo("createButton not implemented")
    }
    public func setLabel(ofButton button: Widget, to label: String) {
        todo("setLabel not implemented")
    }
    public func setAction(ofButton button: Widget, to action: @escaping () -> Void) {
        todo("setAction not implemented")
    }

    public func createTextView(content: String, shouldWrap: Bool) -> Widget {
        todo("createTextView not implemented")
    }
    public func setContent(ofTextView textView: Widget, to content: String) {
        todo("setContent not implemented")
    }
    public func setWrap(ofTextView textView: Widget, to shouldWrap: Bool) {
        todo("setWrap not implemented")
    }

    public func createImageView(filePath: String) -> Widget {
        todo("createImageView not implemented")
    }
    public func setFilePath(ofImageView imageView: Widget, to filePath: String) {
        todo("setFilePath not implemented")
    }

    public func createSpacer(
        expandHorizontally: Bool, expandVertically: Bool
    ) -> Widget {
        todo("Widget  not implemented")
    }
    public func setExpandHorizontally(ofSpacer spacer: Widget, to expandHorizontally: Bool) {
        todo("setExpandHorizontally not implemented")
    }
    public func setExpandVertically(ofSpacer spacer: Widget, to expandVertically: Bool) {
        todo("setExpandVertically not implemented")
    }

    public func getInheritedOrientation(of widget: Widget) -> InheritedOrientation? {
        todo("getInheritedOrientation not implemented")
    }

    public func createSlider(
        minimum: Double,
        maximum: Double,
        value: Double,
        decimalPlaces: Int,
        onChange: @escaping (Double) -> Void
    ) -> Widget {
        todo("createSlider not implemented")
    }
    public func setMinimum(ofSlider slider: Widget, to minimum: Double) {
        todo("setMinimum not implemented")
    }
    public func setMaximum(ofSlider slider: Widget, to maximum: Double) {
        todo("setMaximum not implemented")
    }
    public func setValue(ofSlider slider: Widget, to value: Double) {
        todo("setValue not implemented")
    }
    public func setDecimalPlaces(ofSlider slider: Widget, to decimalPlaces: Int) {
        todo("setDecimalPlaces not implemented")
    }
    public func setOnChange(ofSlider slider: Widget, to onChange: @escaping (Double) -> Void) {
        todo("setOnChange not implemented")
    }

    public func createTextField(
        content: String, placeholder: String, onChange: @escaping (String) -> Void
    ) -> Widget {
        todo("createTextField not implemented")
    }
    public func setContent(ofTextField textField: Widget, to content: String) {
        todo("setContent not implemented")
    }
    public func setPlaceholder(ofTextField textField: Widget, to placeholder: String) {
        todo("setPlaceholder not implemented")
    }
    public func setOnChange(ofTextField textField: Widget, to onChange: @escaping (String) -> Void)
    {
        todo("setOnChange not implemented")
    }
    public func getContent(ofTextField textField: Widget) -> String {
        todo("getContent not implemented")
    }

    public func createListView() -> Widget {
        todo("createListView not implemented")
    }
    public func addChild(_ child: Widget, toListView listView: Widget) {
        todo("addChild not implemented")
    }
    public func removeChild(_ child: Widget, fromListView listView: Widget) {
        todo("removeChild not implemented")
    }

    // TODO: Perhaps all views should have this just in-case backends need to add additional logic?
    public func updateListView(_ listView: Widget) {
        todo("updateListView not implemented")
    }

    public func createOneOfContainer() -> Widget {
        todo("createOneOfContainer not implemented")
    }
    public func addChild(_ child: Widget, toOneOfContainer container: Widget) {
        todo("addChild not implemented")
    }
    public func removeChild(_ child: Widget, fromOneOfContainer container: Widget) {
        todo("removeChild not implemented")
    }
    public func setVisibleChild(ofOneOfContainer container: Widget, to child: Widget) {
        todo("setVisibleChild not implemented")
    }

    public func createSplitView(leadingChild: Widget, trailingChild: Widget) -> Widget {
        todo("createSplitView not implemented")
    }

    public func createPicker(
        options: [String], selectedOption: Int?, onChange: @escaping (Int?) -> Void
    ) -> Widget {
        todo("createPicker not implemented")
    }
    public func setOptions(ofPicker picker: Widget, to options: [String]) {
        todo("setOptions not implemented")
    }
    public func setSelectedOption(ofPicker picker: Widget, to selectedOption: Int?) {
        todo("setSelectedOption not implemented")
    }
    public func setOnChange(ofPicker picker: Widget, to onChange: @escaping (Int?) -> Void) {
        todo("setOnChange not implemented")
    }

    public func createFrameContainer(for child: Widget, minWidth: Int, minHeight: Int) -> Widget {
        todo("createFrameContainer not implemented")
    }
    public func setMinWidth(ofFrameContainer container: Widget, to minWidth: Int) {
        todo("setMinWidth not implemented")
    }
    public func setMinHeight(ofFrameContainer container: Widget, to minHeight: Int) {
        todo("setMinHeight not implemented")
    }

    public func createForegroundColorContainer(for child: Widget, color: Color) -> Widget {
        todo("createForegroundColorContainer not implemented")
    }
    public func setForegroundColor(ofForegroundColorContainer container: Widget, to color: Color) {
        todo("setForegroundColor not implemented")
    }

    public func createTable(rows: Int, columns: Int) -> Widget {
        todo("createTable not implemented")
    }
    public func setRowCount(ofTable table: Widget, to rows: Int) {
        todo("setRowCount not implemented")
    }
    public func setColumnCount(ofTable table: Widget, to columns: Int) {
        todo("setColumnCount not implemented")
    }
    public func setCell(at position: CellPosition, inTable table: Widget, to widget: Widget) {
        todo("setCell not implemented")
    }
}
