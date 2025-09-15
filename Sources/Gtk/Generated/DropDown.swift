import CGtk

/// Allows the user to choose an item from a list of options.
///
/// <picture><source srcset="drop-down-dark.png" media="(prefers-color-scheme: dark)"><img alt="An example GtkDropDown" src="drop-down.png"></picture>
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
/// If a `GtkDropDown` is created in this manner, or with
/// [ctor@Gtk.DropDown.new_from_strings], for instance, the object returned from
/// [method@Gtk.DropDown.get_selected_item] will be a [class@Gtk.StringObject].
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
/// `GtkDropDown` uses the [enum@Gtk.AccessibleRole.combo_box] role.
open class DropDown: Widget {
    /// Creates a new `GtkDropDown` that is populated with
    /// the strings.
    public convenience init(strings: [String]) {
        self.init(
            gtk_drop_down_new_from_strings(
                strings
                    .map({ UnsafePointer($0.unsafeUTF8Copy().baseAddress) })
                    .unsafeCopy()
                    .baseAddress!)
        )
    }

    override func didMoveToParent() {
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
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyEnableSearch?(self, param0)
        }

        let handler2:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::expression", handler: gCallback(handler2)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyExpression?(self, param0)
        }

        let handler3:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::factory", handler: gCallback(handler3)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyFactory?(self, param0)
        }

        let handler4:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::header-factory", handler: gCallback(handler4)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyHeaderFactory?(self, param0)
        }

        let handler5:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::list-factory", handler: gCallback(handler5)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyListFactory?(self, param0)
        }

        let handler6:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::model", handler: gCallback(handler6)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyModel?(self, param0)
        }

        let handler7:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::search-match-mode", handler: gCallback(handler7)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifySearchMatchMode?(self, param0)
        }

        let handler8:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::selected", handler: gCallback(handler8)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifySelected?(self, param0)
        }

        let handler9:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::selected-item", handler: gCallback(handler9)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifySelectedItem?(self, param0)
        }

        let handler10:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::show-arrow", handler: gCallback(handler10)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyShowArrow?(self, param0)
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

    public var notifyEnableSearch: ((DropDown, OpaquePointer) -> Void)?

    public var notifyExpression: ((DropDown, OpaquePointer) -> Void)?

    public var notifyFactory: ((DropDown, OpaquePointer) -> Void)?

    public var notifyHeaderFactory: ((DropDown, OpaquePointer) -> Void)?

    public var notifyListFactory: ((DropDown, OpaquePointer) -> Void)?

    public var notifyModel: ((DropDown, OpaquePointer) -> Void)?

    public var notifySearchMatchMode: ((DropDown, OpaquePointer) -> Void)?

    public var notifySelected: ((DropDown, OpaquePointer) -> Void)?

    public var notifySelectedItem: ((DropDown, OpaquePointer) -> Void)?

    public var notifyShowArrow: ((DropDown, OpaquePointer) -> Void)?
}
