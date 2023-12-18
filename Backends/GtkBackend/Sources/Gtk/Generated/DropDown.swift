import CGtk

/// `GtkDropDown` is a widget that allows the user to choose an item
/// from a list of options.
///
/// ![An example GtkDropDown](drop-down.png)
///
/// The `GtkDropDown` displays the [selected][property@Gtk.DropDown:selected]
/// choice.
///
/// The options are given to `GtkDropDown` in the form of `GListModel`
/// and how the individual options are represented is determined by
/// a [class@Gtk.ListItemFactory]. The default factory displays simple strings,
/// and adds a checkmark to the selected item in the popup.
///
/// To set your own factory, use [method@Gtk.DropDown.set_factory]. It is
/// possible to use a separate factory for the items in the popup, with
/// [method@Gtk.DropDown.set_list_factory].
///
/// `GtkDropDown` knows how to obtain strings from the items in a
/// [class@Gtk.StringList]; for other models, you have to provide an expression
/// to find the strings via [method@Gtk.DropDown.set_expression].
///
/// `GtkDropDown` can optionally allow search in the popup, which is
/// useful if the list of options is long. To enable the search entry,
/// use [method@Gtk.DropDown.set_enable_search].
///
/// Here is a UI definition example for `GtkDropDown` with a simple model:
///
/// ```xml
/// <object class="GtkDropDown"><property name="model"><object class="GtkStringList"><items><item translatable="yes">Factory</item><item translatable="yes">Home</item><item translatable="yes">Subway</item></items></object></property></object>
/// ```
///
/// To learn more about the list widget framework, see the
/// [overview](section-list-widget.html).
///
/// ## CSS nodes
///
/// `GtkDropDown` has a single CSS node with name dropdown,
/// with the button and popover nodes as children.
///
/// ## Accessibility
///
/// `GtkDropDown` uses the %GTK_ACCESSIBLE_ROLE_COMBO_BOX role.
public class DropDown: Widget {
    /// Creates a new `GtkDropDown` that is populated with
    /// the strings.
    public init(strings: [String]) {
        super.init()
        widgetPointer = gtk_drop_down_new_from_strings(
            strings
                .map({ UnsafePointer($0.unsafeUTF8Copy().baseAddress) })
                .unsafeCopy()
                .baseAddress!)
    }

    override func didMoveToParent() {
        removeSignals()

        super.didMoveToParent()

        addSignal(name: "activate") { [weak self] () in
            guard let self = self else { return }
            self.activate?(self)
        }

        let handler1:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::enable-search", handler: gCallback(handler1)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyEnableSearch?(self)
        }

        let handler2:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::expression", handler: gCallback(handler2)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyExpression?(self)
        }

        let handler3:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::factory", handler: gCallback(handler3)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyFactory?(self)
        }

        let handler4:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::header-factory", handler: gCallback(handler4)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyHeaderFactory?(self)
        }

        let handler5:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::list-factory", handler: gCallback(handler5)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyListFactory?(self)
        }

        let handler6:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::model", handler: gCallback(handler6)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyModel?(self)
        }

        let handler7:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::search-match-mode", handler: gCallback(handler7)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifySearchMatchMode?(self)
        }

        let handler8:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::selected", handler: gCallback(handler8)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifySelected?(self)
        }

        let handler9:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::selected-item", handler: gCallback(handler9)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifySelectedItem?(self)
        }

        let handler10:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::show-arrow", handler: gCallback(handler10)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyShowArrow?(self)
        }
    }

    /// Whether to show a search entry in the popup.
    ///
    /// Note that search requires [property@Gtk.DropDown:expression]
    /// to be set.
    @GObjectProperty(named: "enable-search") public var enableSearch: Bool

    /// Model for the displayed items.
    @GObjectProperty(named: "model") public var model: OpaquePointer?

    /// The position of the selected item.
    ///
    /// If no item is selected, the property has the value
    /// %GTK_INVALID_LIST_POSITION.
    @GObjectProperty(named: "selected") public var selected: Int

    /// Emitted to when the drop down is activated.
    ///
    /// The `::activate` signal on `GtkDropDown` is an action signal and
    /// emitting it causes the drop down to pop up its dropdown.
    public var activate: ((DropDown) -> Void)?

    public var notifyEnableSearch: ((DropDown) -> Void)?

    public var notifyExpression: ((DropDown) -> Void)?

    public var notifyFactory: ((DropDown) -> Void)?

    public var notifyHeaderFactory: ((DropDown) -> Void)?

    public var notifyListFactory: ((DropDown) -> Void)?

    public var notifyModel: ((DropDown) -> Void)?

    public var notifySearchMatchMode: ((DropDown) -> Void)?

    public var notifySelected: ((DropDown) -> Void)?

    public var notifySelectedItem: ((DropDown) -> Void)?

    public var notifyShowArrow: ((DropDown) -> Void)?
}
