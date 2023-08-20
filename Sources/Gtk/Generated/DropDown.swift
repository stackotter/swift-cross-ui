import CGtk
import Foundation

extension Collection where Element == UnsafePointer<CChar>? {
    /// Creates an UnsafeMutableBufferPointer with enough space to hold the elements of self.
    public func unsafeCopy() -> UnsafeMutableBufferPointer<Element> {
        let copy = UnsafeMutableBufferPointer<Element>.allocate(
            capacity: count + 1
        )
        _ = copy.initialize(from: self)
        copy[count] = nil
        return copy
    }
}

extension Collection where Element == CChar {
    /// Creates an UnsafeMutableBufferPointer with enough space to hold the elements of self.
    public func unsafeCopy() -> UnsafeMutableBufferPointer<Element> {
        let copy = UnsafeMutableBufferPointer<Element>.allocate(
            capacity: count + 1
        )
        _ = copy.initialize(from: self)
        copy[count] = 0
        return copy
    }
}

extension String {
    /// Create UnsafeMutableBufferPointer holding a null-terminated UTF8 copy of the string
    public func unsafeUTF8Copy() -> UnsafeMutableBufferPointer<CChar> {
        self.utf8CString.unsafeCopy()
    }
}


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
        let pointer = 
                strings
                    .map({ UnsafePointer($0.unsafeUTF8Copy().baseAddress) })
                    .unsafeCopy()
                    .baseAddress
        widgetPointer = gtk_drop_down_new_from_strings(pointer!)
    }

    override func didMoveToParent() {
        super.didMoveToParent()

        removeSignals()

        addSignal(name: "activate") { [weak self] () in
            guard let self = self else { return }
            self.activate?(self)
        }

        let handler:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) ->
                Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::selected", handler: gCallback(handler)) {
            [weak self] (_: OpaquePointer) in
            self?.notifySelected?()
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

    public var notifySelected: (() -> Void)?
}
