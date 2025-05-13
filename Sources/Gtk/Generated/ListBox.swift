import CGtk

/// Shows a vertical list.
///
/// <picture><source srcset="list-box-dark.png" media="(prefers-color-scheme: dark)"><img alt="An example GtkListBox" src="list-box.png"></picture>
///
/// A `GtkListBox` only contains `GtkListBoxRow` children. These rows can
/// by dynamically sorted and filtered, and headers can be added dynamically
/// depending on the row content. It also allows keyboard and mouse navigation
/// and selection like a typical list.
///
/// Using `GtkListBox` is often an alternative to `GtkTreeView`, especially
/// when the list contents has a more complicated layout than what is allowed
/// by a `GtkCellRenderer`, or when the contents is interactive (i.e. has a
/// button in it).
///
/// Although a `GtkListBox` must have only `GtkListBoxRow` children, you can
/// add any kind of widget to it via [method@Gtk.ListBox.prepend],
/// [method@Gtk.ListBox.append] and [method@Gtk.ListBox.insert] and a
/// `GtkListBoxRow` widget will automatically be inserted between the list
/// and the widget.
///
/// `GtkListBoxRows` can be marked as activatable or selectable. If a row is
/// activatable, [signal@Gtk.ListBox::row-activated] will be emitted for it when
/// the user tries to activate it. If it is selectable, the row will be marked
/// as selected when the user tries to select it.
///
/// # GtkListBox as GtkBuildable
///
/// The `GtkListBox` implementation of the `GtkBuildable` interface supports
/// setting a child as the placeholder by specifying “placeholder” as the “type”
/// attribute of a `<child>` element. See [method@Gtk.ListBox.set_placeholder]
/// for info.
///
/// # Shortcuts and Gestures
///
/// The following signals have default keybindings:
///
/// - [signal@Gtk.ListBox::move-cursor]
/// - [signal@Gtk.ListBox::select-all]
/// - [signal@Gtk.ListBox::toggle-cursor-row]
/// - [signal@Gtk.ListBox::unselect-all]
///
/// # CSS nodes
///
/// ```
/// list[.separators][.rich-list][.navigation-sidebar][.boxed-list]
/// ╰── row[.activatable]
/// ```
///
/// `GtkListBox` uses a single CSS node named list. It may carry the .separators
/// style class, when the [property@Gtk.ListBox:show-separators] property is set.
/// Each `GtkListBoxRow` uses a single CSS node named row. The row nodes get the
/// .activatable style class added when appropriate.
///
/// It may also carry the .boxed-list style class. In this case, the list will be
/// automatically surrounded by a frame and have separators.
///
/// The main list node may also carry style classes to select
/// the style of [list presentation](section-list-widget.html#list-styles):
/// .rich-list, .navigation-sidebar or .data-table.
///
/// # Accessibility
///
/// `GtkListBox` uses the [enum@Gtk.AccessibleRole.list] role and `GtkListBoxRow` uses
/// the [enum@Gtk.AccessibleRole.list_item] role.
open class ListBox: Widget {
    /// Creates a new `GtkListBox` container.
    public convenience init() {
        self.init(
            gtk_list_box_new()
        )
    }

    override func didMoveToParent() {
        super.didMoveToParent()

        addSignal(name: "activate-cursor-row") { [weak self] () in
            guard let self = self else { return }
            self.activateCursorRow?(self)
        }

        let handler1:
            @convention(c) (
                UnsafeMutableRawPointer, GtkMovementStep, Int, Bool, Bool, UnsafeMutableRawPointer
            ) -> Void =
                { _, value1, value2, value3, value4, data in
                    SignalBox4<GtkMovementStep, Int, Bool, Bool>.run(
                        data, value1, value2, value3, value4)
                }

        addSignal(name: "move-cursor", handler: gCallback(handler1)) {
            [weak self] (param0: GtkMovementStep, param1: Int, param2: Bool, param3: Bool) in
            guard let self = self else { return }
            self.moveCursor?(self, param0, param1, param2, param3)
        }

        let handler2:
            @convention(c) (
                UnsafeMutableRawPointer, UnsafeMutablePointer<GtkListBoxRow>,
                UnsafeMutableRawPointer
            ) -> Void =
                { _, value1, data in
                    SignalBox1<UnsafeMutablePointer<GtkListBoxRow>>.run(data, value1)
                }

        addSignal(name: "row-activated", handler: gCallback(handler2)) {
            [weak self] (param0: UnsafeMutablePointer<GtkListBoxRow>) in
            guard let self = self else { return }
            self.rowActivated?(self, param0)
        }

        let handler3:
            @convention(c) (
                UnsafeMutableRawPointer, UnsafeMutablePointer<GtkListBoxRow>?,
                UnsafeMutableRawPointer
            ) -> Void =
                { _, value1, data in
                    SignalBox1<UnsafeMutablePointer<GtkListBoxRow>?>.run(data, value1)
                }

        addSignal(name: "row-selected", handler: gCallback(handler3)) {
            [weak self] (param0: UnsafeMutablePointer<GtkListBoxRow>?) in
            guard let self = self else { return }
            self.rowSelected?(self, param0)
        }

        addSignal(name: "selected-rows-changed") { [weak self] () in
            guard let self = self else { return }
            self.selectedRowsChanged?(self)
        }

        addSignal(name: "toggle-cursor-row") { [weak self] () in
            guard let self = self else { return }
            self.toggleCursorRow?(self)
        }

        let handler6:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::accept-unpaired-release", handler: gCallback(handler6)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyAcceptUnpairedRelease?(self, param0)
        }

        let handler7:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::activate-on-single-click", handler: gCallback(handler7)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyActivateOnSingleClick?(self, param0)
        }

        let handler8:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::selection-mode", handler: gCallback(handler8)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifySelectionMode?(self, param0)
        }

        let handler9:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::show-separators", handler: gCallback(handler9)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyShowSeparators?(self, param0)
        }

        let handler10:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::tab-behavior", handler: gCallback(handler10)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyTabBehavior?(self, param0)
        }
    }

    /// Determines whether children can be activated with a single
    /// click, or require a double-click.
    @GObjectProperty(named: "activate-on-single-click") public var activateOnSingleClick: Bool

    /// The selection mode used by the list box.
    @GObjectProperty(named: "selection-mode") public var selectionMode: SelectionMode

    /// Whether to show separators between rows.
    @GObjectProperty(named: "show-separators") public var showSeparators: Bool

    /// Emitted when the cursor row is activated.
    public var activateCursorRow: ((ListBox) -> Void)?

    /// Emitted when the user initiates a cursor movement.
    ///
    /// The default bindings for this signal come in two variants, the variant with
    /// the Shift modifier extends the selection, the variant without the Shift
    /// modifier does not. There are too many key combinations to list them all
    /// here.
    ///
    /// - <kbd>←</kbd>, <kbd>→</kbd>, <kbd>↑</kbd>, <kbd>↓</kbd>
    /// move by individual children
    /// - <kbd>Home</kbd>, <kbd>End</kbd> move to the ends of the box
    /// - <kbd>PgUp</kbd>, <kbd>PgDn</kbd> move vertically by pages
    public var moveCursor: ((ListBox, GtkMovementStep, Int, Bool, Bool) -> Void)?

    /// Emitted when a row has been activated by the user.
    public var rowActivated: ((ListBox, UnsafeMutablePointer<GtkListBoxRow>) -> Void)?

    /// Emitted when a new row is selected, or (with a %NULL @row)
    /// when the selection is cleared.
    ///
    /// When the @box is using %GTK_SELECTION_MULTIPLE, this signal will not
    /// give you the full picture of selection changes, and you should use
    /// the [signal@Gtk.ListBox::selected-rows-changed] signal instead.
    public var rowSelected: ((ListBox, UnsafeMutablePointer<GtkListBoxRow>?) -> Void)?

    /// Emitted when the set of selected rows changes.
    public var selectedRowsChanged: ((ListBox) -> Void)?

    /// Emitted when the cursor row is toggled.
    ///
    /// The default bindings for this signal is <kbd>Ctrl</kbd>+<kbd>␣</kbd>.
    public var toggleCursorRow: ((ListBox) -> Void)?

    public var notifyAcceptUnpairedRelease: ((ListBox, OpaquePointer) -> Void)?

    public var notifyActivateOnSingleClick: ((ListBox, OpaquePointer) -> Void)?

    public var notifySelectionMode: ((ListBox, OpaquePointer) -> Void)?

    public var notifyShowSeparators: ((ListBox, OpaquePointer) -> Void)?

    public var notifyTabBehavior: ((ListBox, OpaquePointer) -> Void)?
}
