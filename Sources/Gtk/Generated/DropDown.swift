import CGtk

/// `GtkDropDown` is a widget that allows the user to choose an item
/// from a list of options.
///
/// ![An example GtkDropDown](drop-down.png)
///
/// The `GtkDropDown` displays the selected choice.
///
/// The options are given to `GtkDropDown` in the form of `GListModel`
/// and how the individual options are represented is determined by
/// a [class@Gtk.ListItemFactory]. The default factory displays simple strings.
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
/// ```xml
/// <object class="GtkDropDown"><property name="model"><object class="GtkStringList"><items><item translatable="yes">Factory</item><item translatable="yes">Home</item><item translatable="yes">Subway</item></items></object></property></object>
/// ```
///
/// # CSS nodes
///
/// `GtkDropDown` has a single CSS node with name dropdown,
/// with the button and popover nodes as children.
///
/// # Accessibility
///
/// `GtkDropDown` uses the %GTK_ACCESSIBLE_ROLE_COMBO_BOX role.
public class DropDown: Widget {
    /// Creates a new `GtkDropDown` that is populated with
    /// the strings.
    public init(strings: [String]) {
        super.init()
        widgetPointer = gtk_drop_down_new_from_strings(strings.map { $0.withCString { $0 } })
    }

    override func didMoveToParent() {
        super.didMoveToParent()

        removeSignals()

        addSignal(name: "activate") { [weak self] () in
            guard let self = self else { return }
            self.activate?(self)
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
    @GObjectProperty(named: "selected") public var selected: UInt

    /// Emitted to when the drop down is activated.
    ///
    /// The `::activate` signal on `GtkDropDown` is an action signal and
    /// emitting it causes the drop down to pop up its dropdown.
    public var activate: ((DropDown) -> Void)?
}
