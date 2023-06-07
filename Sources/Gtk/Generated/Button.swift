import CGtk

/// The `GtkButton` widget is generally used to trigger a callback function that is
/// called when the button is pressed.
///
/// ![An example GtkButton](button.png)
///
/// The `GtkButton` widget can hold any valid child widget. That is, it can hold
/// almost any other standard `GtkWidget`. The most commonly used child is the
/// `GtkLabel`.
///
/// # CSS nodes
///
/// `GtkButton` has a single CSS node with name button. The node will get the
/// style classes .image-button or .text-button, if the content is just an
/// image or label, respectively. It may also receive the .flat style class.
/// When activating a button via the keyboard, the button will temporarily
/// gain the .keyboard-activating style class.
///
/// Other style classes that are commonly used with `GtkButton` include
/// .suggested-action and .destructive-action. In special cases, buttons
/// can be made round by adding the .circular style class.
///
/// Button-like widgets like [class@Gtk.ToggleButton], [class@Gtk.MenuButton],
/// [class@Gtk.VolumeButton], [class@Gtk.LockButton], [class@Gtk.ColorButton]
/// or [class@Gtk.FontButton] use style classes such as .toggle, .popup, .scale,
/// .lock, .color on the button node to differentiate themselves from a plain
/// `GtkButton`.
///
/// # Accessibility
///
/// `GtkButton` uses the %GTK_ACCESSIBLE_ROLE_BUTTON role.
public class Button: Widget, Actionable {
    /// Creates a new `GtkButton` widget.
    ///
    /// To add a child widget to the button, use [method@Gtk.Button.set_child].
    override public init() {
        super.init()
        widgetPointer = gtk_button_new()
    }

    /// Creates a new button containing an icon from the current icon theme.
    ///
    /// If the icon name isn’t known, a “broken image” icon will be
    /// displayed instead. If the current icon theme is changed, the icon
    /// will be updated appropriately.
    public init(iconName: String) {
        super.init()
        widgetPointer = gtk_button_new_from_icon_name(iconName)
    }

    /// Creates a `GtkButton` widget with a `GtkLabel` child.
    public init(label: String) {
        super.init()
        widgetPointer = gtk_button_new_with_label(label)
    }

    /// Creates a new `GtkButton` containing a label.
    ///
    /// If characters in @label are preceded by an underscore, they are underlined.
    /// If you need a literal underscore character in a label, use “__” (two
    /// underscores). The first underlined character represents a keyboard
    /// accelerator called a mnemonic. Pressing <kbd>Alt</kbd> and that key
    /// activates the button.
    public init(mnemonic label: String) {
        super.init()
        widgetPointer = gtk_button_new_with_mnemonic(label)
    }

    override func didMoveToParent() {
        super.didMoveToParent()

        addSignal(name: "activate") { [weak self] () in
            guard let self = self else { return }
            self.activate?(self)
        }

        addSignal(name: "clicked") { [weak self] () in
            guard let self = self else { return }
            self.clicked?(self)
        }
    }

    /// Whether the button has a frame.
    @GObjectProperty(named: "has-frame") public var hasFrame: Bool

    /// The name of the icon used to automatically populate the button.
    @GObjectProperty(named: "icon-name") public var iconName: String?

    /// Text of the label inside the button, if the button contains a label widget.
    @GObjectProperty(named: "label") public var label: String?

    /// If set, an underline in the text indicates that the following character is
    /// to be used as mnemonic.
    @GObjectProperty(named: "use-underline") public var useUnderline: Bool

    @GObjectProperty(named: "action-name") public var actionName: String?

    /// Emitted to animate press then release.
    ///
    /// This is an action signal. Applications should never connect
    /// to this signal, but use the [signal@Gtk.Button::clicked] signal.
    ///
    /// The default bindings for this signal are all forms of the
    /// <kbd>␣</kbd> and <kbd>Enter</kbd> keys.
    public var activate: ((Button) -> Void)?

    /// Emitted when the button has been activated (pressed and released).
    public var clicked: ((Button) -> Void)?
}
