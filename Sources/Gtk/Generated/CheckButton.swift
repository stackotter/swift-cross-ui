import CGtk

/// Places a label next to an indicator.
///
/// <picture><source srcset="check-button-dark.png" media="(prefers-color-scheme: dark)"><img alt="Example GtkCheckButtons" src="check-button.png"></picture>
///
/// A `GtkCheckButton` is created by calling either [ctor@Gtk.CheckButton.new]
/// or [ctor@Gtk.CheckButton.new_with_label].
///
/// The state of a `GtkCheckButton` can be set specifically using
/// [method@Gtk.CheckButton.set_active], and retrieved using
/// [method@Gtk.CheckButton.get_active].
///
/// # Inconsistent state
///
/// In addition to "on" and "off", check buttons can be an
/// "in between" state that is neither on nor off. This can be used
/// e.g. when the user has selected a range of elements (such as some
/// text or spreadsheet cells) that are affected by a check button,
/// and the current values in that range are inconsistent.
///
/// To set a `GtkCheckButton` to inconsistent state, use
/// [method@Gtk.CheckButton.set_inconsistent].
///
/// # Grouping
///
/// Check buttons can be grouped together, to form mutually exclusive
/// groups - only one of the buttons can be toggled at a time, and toggling
/// another one will switch the currently toggled one off.
///
/// Grouped check buttons use a different indicator, and are commonly referred
/// to as *radio buttons*.
///
/// <picture><source srcset="radio-button-dark.png" media="(prefers-color-scheme: dark)"><img alt="Example GtkRadioButtons" src="radio-button.png"></picture>
///
/// To add a `GtkCheckButton` to a group, use [method@Gtk.CheckButton.set_group].
///
/// When the code must keep track of the state of a group of radio buttons, it
/// is recommended to keep track of such state through a stateful
/// `GAction` with a target for each button. Using the `toggled` signals to keep
/// track of the group changes and state is discouraged.
///
/// # Shortcuts and Gestures
///
/// `GtkCheckButton` supports the following keyboard shortcuts:
///
/// - <kbd>␣</kbd> or <kbd>Enter</kbd> activates the button.
///
/// # CSS nodes
///
/// ```
/// checkbutton[.text-button][.grouped]
/// ├── check
/// ╰── [label]
/// ```
///
/// A `GtkCheckButton` has a main node with name checkbutton. If the
/// [property@Gtk.CheckButton:label] or [property@Gtk.CheckButton:child]
/// properties are set, it contains a child widget. The indicator node
/// is named check when no group is set, and radio if the checkbutton
/// is grouped together with other checkbuttons.
///
/// # Accessibility
///
/// `GtkCheckButton` uses the [enum@Gtk.AccessibleRole.checkbox] role.
open class CheckButton: Widget, Actionable {
    /// Creates a new `GtkCheckButton`.
    public convenience init() {
        self.init(
            gtk_check_button_new()
        )
    }

    /// Creates a new `GtkCheckButton` with the given text.
    public convenience init(label: String) {
        self.init(
            gtk_check_button_new_with_label(label)
        )
    }

    /// Creates a new `GtkCheckButton` with the given text and a mnemonic.
    public convenience init(mnemonic label: String) {
        self.init(
            gtk_check_button_new_with_mnemonic(label)
        )
    }

    override func didMoveToParent() {
        super.didMoveToParent()

        addSignal(name: "activate") { [weak self] () in
            guard let self = self else { return }
            self.activate?(self)
        }

        addSignal(name: "toggled") { [weak self] () in
            guard let self = self else { return }
            self.toggled?(self)
        }

        let handler2:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::active", handler: gCallback(handler2)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyActive?(self, param0)
        }

        let handler3:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::child", handler: gCallback(handler3)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyChild?(self, param0)
        }

        let handler4:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::group", handler: gCallback(handler4)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyGroup?(self, param0)
        }

        let handler5:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::inconsistent", handler: gCallback(handler5)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyInconsistent?(self, param0)
        }

        let handler6:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::label", handler: gCallback(handler6)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyLabel?(self, param0)
        }

        let handler7:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::use-underline", handler: gCallback(handler7)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyUseUnderline?(self, param0)
        }

        let handler8:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::action-name", handler: gCallback(handler8)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyActionName?(self, param0)
        }

        let handler9:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::action-target", handler: gCallback(handler9)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyActionTarget?(self, param0)
        }
    }

    /// If the check button is active.
    ///
    /// Setting `active` to %TRUE will add the `:checked:` state to both
    /// the check button and the indicator CSS node.
    @GObjectProperty(named: "active") public var active: Bool

    /// If the check button is in an “in between” state.
    ///
    /// The inconsistent state only affects visual appearance,
    /// not the semantics of the button.
    @GObjectProperty(named: "inconsistent") public var inconsistent: Bool

    /// Text of the label inside the check button, if it contains a label widget.
    @GObjectProperty(named: "label") public var label: String?

    /// If set, an underline in the text indicates that the following
    /// character is to be used as mnemonic.
    @GObjectProperty(named: "use-underline") public var useUnderline: Bool

    /// The name of the action with which this widget should be associated.
    @GObjectProperty(named: "action-name") public var actionName: String?

    /// Emitted to when the check button is activated.
    ///
    /// The `::activate` signal on `GtkCheckButton` is an action signal and
    /// emitting it causes the button to animate press then release.
    ///
    /// Applications should never connect to this signal, but use the
    /// [signal@Gtk.CheckButton::toggled] signal.
    ///
    /// The default bindings for this signal are all forms of the
    /// <kbd>␣</kbd> and <kbd>Enter</kbd> keys.
    public var activate: ((CheckButton) -> Void)?

    /// Emitted when the buttons's [property@Gtk.CheckButton:active]
    /// property changes.
    public var toggled: ((CheckButton) -> Void)?

    public var notifyActive: ((CheckButton, OpaquePointer) -> Void)?

    public var notifyChild: ((CheckButton, OpaquePointer) -> Void)?

    public var notifyGroup: ((CheckButton, OpaquePointer) -> Void)?

    public var notifyInconsistent: ((CheckButton, OpaquePointer) -> Void)?

    public var notifyLabel: ((CheckButton, OpaquePointer) -> Void)?

    public var notifyUseUnderline: ((CheckButton, OpaquePointer) -> Void)?

    public var notifyActionName: ((CheckButton, OpaquePointer) -> Void)?

    public var notifyActionTarget: ((CheckButton, OpaquePointer) -> Void)?
}
