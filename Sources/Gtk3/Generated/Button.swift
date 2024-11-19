import CGtk3

/// The #GtkButton widget is generally used to trigger a callback function that is
/// called when the button is pressed.  The various signals and how to use them
/// are outlined below.
///
/// The #GtkButton widget can hold any valid child widget.  That is, it can hold
/// almost any other standard #GtkWidget.  The most commonly used child is the
/// #GtkLabel.
///
/// # CSS nodes
///
/// GtkButton has a single CSS node with name button. The node will get the
/// style classes .image-button or .text-button, if the content is just an
/// image or label, respectively. It may also receive the .flat style class.
///
/// Other style classes that are commonly used with GtkButton include
/// .suggested-action and .destructive-action. In special cases, buttons
/// can be made round by adding the .circular style class.
///
/// Button-like widgets like #GtkToggleButton, #GtkMenuButton, #GtkVolumeButton,
/// #GtkLockButton, #GtkColorButton, #GtkFontButton or #GtkFileChooserButton use
/// style classes such as .toggle, .popup, .scale, .lock, .color, .font, .file
/// to differentiate themselves from a plain GtkButton.
public class Button: Bin, Activatable {
    /// Creates a new #GtkButton widget. To add a child widget to the button,
    /// use gtk_container_add().
    override public init() {
        super.init()
        widgetPointer = gtk_button_new()
    }

    /// Creates a new button containing an icon from the current icon theme.
    ///
    /// If the icon name isn’t known, a “broken image” icon will be
    /// displayed instead. If the current icon theme is changed, the icon
    /// will be updated appropriately.
    ///
    /// This function is a convenience wrapper around gtk_button_new() and
    /// gtk_button_set_image().
    public init(iconName: String, size: GtkIconSize) {
        super.init()
        widgetPointer = gtk_button_new_from_icon_name(iconName, size)
    }

    /// Creates a #GtkButton widget with a #GtkLabel child containing the given
    /// text.
    public init(label: String) {
        super.init()
        widgetPointer = gtk_button_new_with_label(label)
    }

    /// Creates a new #GtkButton containing a label.
    /// If characters in @label are preceded by an underscore, they are underlined.
    /// If you need a literal underscore character in a label, use “__” (two
    /// underscores). The first underlined character represents a keyboard
    /// accelerator called a mnemonic.
    /// Pressing Alt and that key activates the button.
    public init(mnemonic label: String) {
        super.init()
        widgetPointer = gtk_button_new_with_mnemonic(label)
    }

    override func didMoveToParent() {
        removeSignals()

        super.didMoveToParent()

        addSignal(name: "activate") { [weak self] () in
            guard let self = self else { return }
            self.activate?(self)
        }

        addSignal(name: "clicked") { [weak self] () in
            guard let self = self else { return }
            self.clicked?(self)
        }

        addSignal(name: "enter") { [weak self] () in
            guard let self = self else { return }
            self.enter?(self)
        }

        addSignal(name: "leave") { [weak self] () in
            guard let self = self else { return }
            self.leave?(self)
        }

        addSignal(name: "pressed") { [weak self] () in
            guard let self = self else { return }
            self.pressed?(self)
        }

        addSignal(name: "released") { [weak self] () in
            guard let self = self else { return }
            self.released?(self)
        }

        let handler6:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::always-show-image", handler: gCallback(handler6)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyAlwaysShowImage?(self)
        }

        let handler7:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::image", handler: gCallback(handler7)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyImage?(self)
        }

        let handler8:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::image-position", handler: gCallback(handler8)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyImagePosition?(self)
        }

        let handler9:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::label", handler: gCallback(handler9)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyLabel?(self)
        }

        let handler10:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::relief", handler: gCallback(handler10)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyRelief?(self)
        }

        let handler11:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::use-stock", handler: gCallback(handler11)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyUseStock?(self)
        }

        let handler12:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::use-underline", handler: gCallback(handler12)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyUseUnderline?(self)
        }

        let handler13:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::xalign", handler: gCallback(handler13)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyXalign?(self)
        }

        let handler14:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::yalign", handler: gCallback(handler14)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyYalign?(self)
        }

        let handler15:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::related-action", handler: gCallback(handler15)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyRelatedAction?(self)
        }

        let handler16:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::use-action-appearance", handler: gCallback(handler16)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyUseActionAppearance?(self)
        }
    }

    @GObjectProperty(named: "label") public var label: String

    @GObjectProperty(named: "relief") public var relief: ReliefStyle

    @GObjectProperty(named: "use-stock") public var useStock: Bool

    @GObjectProperty(named: "use-underline") public var useUnderline: Bool

    /// The ::activate signal on GtkButton is an action signal and
    /// emitting it causes the button to animate press then release.
    /// Applications should never connect to this signal, but use the
    /// #GtkButton::clicked signal.
    public var activate: ((Button) -> Void)?

    /// Emitted when the button has been activated (pressed and released).
    public var clicked: ((Button) -> Void)?

    /// Emitted when the pointer enters the button.
    public var enter: ((Button) -> Void)?

    /// Emitted when the pointer leaves the button.
    public var leave: ((Button) -> Void)?

    /// Emitted when the button is pressed.
    public var pressed: ((Button) -> Void)?

    /// Emitted when the button is released.
    public var released: ((Button) -> Void)?

    public var notifyAlwaysShowImage: ((Button) -> Void)?

    public var notifyImage: ((Button) -> Void)?

    public var notifyImagePosition: ((Button) -> Void)?

    public var notifyLabel: ((Button) -> Void)?

    public var notifyRelief: ((Button) -> Void)?

    public var notifyUseStock: ((Button) -> Void)?

    public var notifyUseUnderline: ((Button) -> Void)?

    public var notifyXalign: ((Button) -> Void)?

    public var notifyYalign: ((Button) -> Void)?

    public var notifyRelatedAction: ((Button) -> Void)?

    public var notifyUseActionAppearance: ((Button) -> Void)?
}
