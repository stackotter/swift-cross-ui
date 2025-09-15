import CGtk

/// Shows a "light switch" that has two states: on or off.
///
/// <picture><source srcset="switch-dark.png" media="(prefers-color-scheme: dark)"><img alt="An example GtkSwitch" src="switch.png"></picture>
///
/// The user can control which state should be active by clicking the
/// empty area, or by dragging the slider.
///
/// `GtkSwitch` can also express situations where the underlying state changes
/// with a delay. In this case, the slider position indicates the user's recent
/// change (represented by the [property@Gtk.Switch:active] property), while the
/// trough color indicates the present underlying state (represented by the
/// [property@Gtk.Switch:state] property).
///
/// <picture><source srcset="switch-state-dark.png" media="(prefers-color-scheme: dark)"><img alt="GtkSwitch with delayed state change" src="switch-state.png"></picture>
///
/// See [signal@Gtk.Switch::state-set] for details.
///
/// # Shortcuts and Gestures
///
/// `GtkSwitch` supports pan and drag gestures to move the slider.
///
/// # CSS nodes
///
/// ```
/// switch
/// ├── image
/// ├── image
/// ╰── slider
/// ```
///
/// `GtkSwitch` has four css nodes, the main node with the name switch and
/// subnodes for the slider and the on and off images. Neither of them is
/// using any style classes.
///
/// # Accessibility
///
/// `GtkSwitch` uses the [enum@Gtk.AccessibleRole.switch] role.
open class Switch: Widget, Actionable {
    /// Creates a new `GtkSwitch` widget.
    public convenience init() {
        self.init(
            gtk_switch_new()
        )
    }

    override func didMoveToParent() {
        super.didMoveToParent()

        addSignal(name: "activate") { [weak self] () in
            guard let self = self else { return }
            self.activate?(self)
        }

        let handler1:
            @convention(c) (UnsafeMutableRawPointer, Bool, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<Bool>.run(data, value1)
                }

        addSignal(name: "state-set", handler: gCallback(handler1)) { [weak self] (param0: Bool) in
            guard let self = self else { return }
            self.stateSet?(self, param0)
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

        addSignal(name: "notify::state", handler: gCallback(handler3)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyState?(self, param0)
        }

        let handler4:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::action-name", handler: gCallback(handler4)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyActionName?(self, param0)
        }

        let handler5:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::action-target", handler: gCallback(handler5)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyActionTarget?(self, param0)
        }
    }

    /// Whether the `GtkSwitch` widget is in its on or off state.
    @GObjectProperty(named: "active") public var active: Bool

    /// The backend state that is controlled by the switch.
    ///
    /// Applications should usually set the [property@Gtk.Switch:active] property,
    /// except when indicating a change to the backend state which occurs
    /// separately from the user's interaction.
    ///
    /// See [signal@Gtk.Switch::state-set] for details.
    @GObjectProperty(named: "state") public var state: Bool

    /// The name of the action with which this widget should be associated.
    @GObjectProperty(named: "action-name") public var actionName: String?

    /// Emitted to animate the switch.
    ///
    /// Applications should never connect to this signal,
    /// but use the [property@Gtk.Switch:active] property.
    public var activate: ((Switch) -> Void)?

    /// Emitted to change the underlying state.
    ///
    /// The ::state-set signal is emitted when the user changes the switch
    /// position. The default handler calls [method@Gtk.Switch.set_state] with the
    /// value of @state.
    ///
    /// To implement delayed state change, applications can connect to this
    /// signal, initiate the change of the underlying state, and call
    /// [method@Gtk.Switch.set_state] when the underlying state change is
    /// complete. The signal handler should return %TRUE to prevent the
    /// default handler from running.
    public var stateSet: ((Switch, Bool) -> Void)?

    public var notifyActive: ((Switch, OpaquePointer) -> Void)?

    public var notifyState: ((Switch, OpaquePointer) -> Void)?

    public var notifyActionName: ((Switch, OpaquePointer) -> Void)?

    public var notifyActionTarget: ((Switch, OpaquePointer) -> Void)?
}
