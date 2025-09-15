import CGtk3

/// A #GtkCheckButton places a discrete #GtkToggleButton next to a widget,
/// (usually a #GtkLabel). See the section on #GtkToggleButton widgets for
/// more information about toggle/check buttons.
///
/// The important signal ( #GtkToggleButton::toggled ) is also inherited from
/// #GtkToggleButton.
///
/// # CSS nodes
///
/// |[<!-- language="plain" -->
/// checkbutton
/// ├── check
/// ╰── <child>
/// ]|
///
/// A GtkCheckButton with indicator (see gtk_toggle_button_set_mode()) has a
/// main CSS node with name checkbutton and a subnode with name check.
///
/// |[<!-- language="plain" -->
/// button.check
/// ├── check
/// ╰── <child>
/// ]|
///
/// A GtkCheckButton without indicator changes the name of its main node
/// to button and adds a .check style class to it. The subnode is invisible
/// in this case.
open class CheckButton: ToggleButton {
    /// Creates a new #GtkCheckButton.
    public convenience init() {
        self.init(
            gtk_check_button_new()
        )
    }

    /// Creates a new #GtkCheckButton with a #GtkLabel to the right of it.
    public convenience init(label: String) {
        self.init(
            gtk_check_button_new_with_label(label)
        )
    }

    /// Creates a new #GtkCheckButton containing a label. The label
    /// will be created using gtk_label_new_with_mnemonic(), so underscores
    /// in @label indicate the mnemonic for the check button.
    public convenience init(mnemonic label: String) {
        self.init(
            gtk_check_button_new_with_mnemonic(label)
        )
    }

}
