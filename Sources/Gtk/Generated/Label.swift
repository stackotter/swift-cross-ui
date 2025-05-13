import CGtk

/// Displays a small amount of text.
///
/// Most labels are used to label another widget (such as an [class@Entry]).
///
/// <picture><source srcset="label-dark.png" media="(prefers-color-scheme: dark)"><img alt="An example GtkLabel" src="label.png"></picture>
///
/// ## Shortcuts and Gestures
///
/// `GtkLabel` supports the following keyboard shortcuts, when the cursor is
/// visible:
///
/// - <kbd>Shift</kbd>+<kbd>F10</kbd> or <kbd>Menu</kbd> opens the context menu.
/// - <kbd>Ctrl</kbd>+<kbd>A</kbd> or <kbd>Ctrl</kbd>+<kbd>&sol;</kbd>
/// selects all.
/// - <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>A</kbd> or
/// <kbd>Ctrl</kbd>+<kbd>&bsol;</kbd> unselects all.
///
/// Additionally, the following signals have default keybindings:
///
/// - [signal@Gtk.Label::activate-current-link]
/// - [signal@Gtk.Label::copy-clipboard]
/// - [signal@Gtk.Label::move-cursor]
///
/// ## Actions
///
/// `GtkLabel` defines a set of built-in actions:
///
/// - `clipboard.copy` copies the text to the clipboard.
/// - `clipboard.cut` doesn't do anything, since text in labels can't be deleted.
/// - `clipboard.paste` doesn't do anything, since text in labels can't be
/// edited.
/// - `link.open` opens the link, when activated on a link inside the label.
/// - `link.copy` copies the link to the clipboard, when activated on a link
/// inside the label.
/// - `menu.popup` opens the context menu.
/// - `selection.delete` doesn't do anything, since text in labels can't be
/// deleted.
/// - `selection.select-all` selects all of the text, if the label allows
/// selection.
///
/// ## CSS nodes
///
/// ```
/// label
/// ├── [selection]
/// ├── [link]
/// ┊
/// ╰── [link]
/// ```
///
/// `GtkLabel` has a single CSS node with the name label. A wide variety
/// of style classes may be applied to labels, such as .title, .subtitle,
/// .dim-label, etc. In the `GtkShortcutsWindow`, labels are used with the
/// .keycap style class.
///
/// If the label has a selection, it gets a subnode with name selection.
///
/// If the label has links, there is one subnode per link. These subnodes
/// carry the link or visited state depending on whether they have been
/// visited. In this case, label node also gets a .link style class.
///
/// ## GtkLabel as GtkBuildable
///
/// The GtkLabel implementation of the GtkBuildable interface supports a
/// custom `<attributes>` element, which supports any number of `<attribute>`
/// elements. The `<attribute>` element has attributes named “name“, “value“,
/// “start“ and “end“ and allows you to specify [struct@Pango.Attribute]
/// values for this label.
///
/// An example of a UI definition fragment specifying Pango attributes:
///
/// ```xml
/// <object class="GtkLabel"><attributes><attribute name="weight" value="PANGO_WEIGHT_BOLD"/><attribute name="background" value="red" start="5" end="10"/></attributes></object>
/// ```
///
/// The start and end attributes specify the range of characters to which the
/// Pango attribute applies. If start and end are not specified, the attribute is
/// applied to the whole text. Note that specifying ranges does not make much
/// sense with translatable attributes. Use markup embedded in the translatable
/// content instead.
///
/// ## Accessibility
///
/// `GtkLabel` uses the [enum@Gtk.AccessibleRole.label] role.
///
/// ## Mnemonics
///
/// Labels may contain “mnemonics”. Mnemonics are underlined characters in the
/// label, used for keyboard navigation. Mnemonics are created by providing a
/// string with an underscore before the mnemonic character, such as `"_File"`,
/// to the functions [ctor@Gtk.Label.new_with_mnemonic] or
/// [method@Gtk.Label.set_text_with_mnemonic].
///
/// Mnemonics automatically activate any activatable widget the label is
/// inside, such as a [class@Gtk.Button]; if the label is not inside the
/// mnemonic’s target widget, you have to tell the label about the target
/// using [method@Gtk.Label.set_mnemonic_widget].
///
/// Here’s a simple example where the label is inside a button:
///
/// ```c
/// // Pressing Alt+H will activate this button
/// GtkWidget *button = gtk_button_new ();
/// GtkWidget *label = gtk_label_new_with_mnemonic ("_Hello");
/// gtk_button_set_child (GTK_BUTTON (button), label);
/// ```
///
/// There’s a convenience function to create buttons with a mnemonic label
/// already inside:
///
/// ```c
/// // Pressing Alt+H will activate this button
/// GtkWidget *button = gtk_button_new_with_mnemonic ("_Hello");
/// ```
///
/// To create a mnemonic for a widget alongside the label, such as a
/// [class@Gtk.Entry], you have to point the label at the entry with
/// [method@Gtk.Label.set_mnemonic_widget]:
///
/// ```c
/// // Pressing Alt+H will focus the entry
/// GtkWidget *entry = gtk_entry_new ();
/// GtkWidget *label = gtk_label_new_with_mnemonic ("_Hello");
/// gtk_label_set_mnemonic_widget (GTK_LABEL (label), entry);
/// ```
///
/// ## Markup (styled text)
///
/// To make it easy to format text in a label (changing colors, fonts, etc.),
/// label text can be provided in a simple markup format:
///
/// Here’s how to create a label with a small font:
/// ```c
/// GtkWidget *label = gtk_label_new (NULL);
/// gtk_label_set_markup (GTK_LABEL (label), "<small>Small text</small>");
/// ```
///
/// (See the Pango manual for complete documentation] of available
/// tags, [func@Pango.parse_markup])
///
/// The markup passed to [method@Gtk.Label.set_markup] must be valid XML; for example,
/// literal `<`, `>` and `&` characters must be escaped as `&lt;`, `&gt;`, and `&amp;`.
/// If you pass text obtained from the user, file, or a network to
/// [method@Gtk.Label.set_markup], you’ll want to escape it with
/// [func@GLib.markup_escape_text] or [func@GLib.markup_printf_escaped].
///
/// Markup strings are just a convenient way to set the [struct@Pango.AttrList]
/// on a label; [method@Gtk.Label.set_attributes] may be a simpler way to set
/// attributes in some cases. Be careful though; [struct@Pango.AttrList] tends
/// to cause internationalization problems, unless you’re applying attributes
/// to the entire string (i.e. unless you set the range of each attribute
/// to [0, `G_MAXINT`)). The reason is that specifying the `start_index` and
/// `end_index` for a [struct@Pango.Attribute] requires knowledge of the exact
/// string being displayed, so translations will cause problems.
///
/// ## Selectable labels
///
/// Labels can be made selectable with [method@Gtk.Label.set_selectable].
/// Selectable labels allow the user to copy the label contents to the
/// clipboard. Only labels that contain useful-to-copy information — such
/// as error messages — should be made selectable.
///
/// ## Text layout
///
/// A label can contain any number of paragraphs, but will have
/// performance problems if it contains more than a small number.
/// Paragraphs are separated by newlines or other paragraph separators
/// understood by Pango.
///
/// Labels can automatically wrap text if you call [method@Gtk.Label.set_wrap].
///
/// [method@Gtk.Label.set_justify] sets how the lines in a label align
/// with one another. If you want to set how the label as a whole aligns
/// in its available space, see the [property@Gtk.Widget:halign] and
/// [property@Gtk.Widget:valign] properties.
///
/// The [property@Gtk.Label:width-chars] and [property@Gtk.Label:max-width-chars]
/// properties can be used to control the size allocation of ellipsized or
/// wrapped labels. For ellipsizing labels, if either is specified (and less
/// than the actual text size), it is used as the minimum width, and the actual
/// text size is used as the natural width of the label. For wrapping labels,
/// width-chars is used as the minimum width, if specified, and max-width-chars
/// is used as the natural width. Even if max-width-chars specified, wrapping
/// labels will be rewrapped to use all of the available width.
///
/// ## Links
///
/// GTK supports markup for clickable hyperlinks in addition to regular Pango
/// markup. The markup for links is borrowed from HTML, using the `<a>` tag
/// with “href“, “title“ and “class“ attributes. GTK renders links similar to
/// the way they appear in web browsers, with colored, underlined text. The
/// “title“ attribute is displayed as a tooltip on the link. The “class“
/// attribute is used as style class on the CSS node for the link.
///
/// An example of inline links looks like this:
///
/// ```c
/// const char *text =
/// "Go to the "
/// "<a href=\"https://www.gtk.org\" title=\"&lt;i&gt;Our&lt;/i&gt; website\">"
/// "GTK website</a> for more...";
/// GtkWidget *label = gtk_label_new (NULL);
/// gtk_label_set_markup (GTK_LABEL (label), text);
/// ```
///
/// It is possible to implement custom handling for links and their tooltips
/// with the [signal@Gtk.Label::activate-link] signal and the
/// [method@Gtk.Label.get_current_uri] function.
open class Label: Widget {
    /// Creates a new label with the given text inside it.
    ///
    /// You can pass `NULL` to get an empty label widget.
    public convenience init(string: String) {
        self.init(
            gtk_label_new(string)
        )
    }

    /// Creates a new label with the given text inside it, and a mnemonic.
    ///
    /// If characters in @str are preceded by an underscore, they are
    /// underlined. If you need a literal underscore character in a label, use
    /// '__' (two underscores). The first underlined character represents a
    /// keyboard accelerator called a mnemonic. The mnemonic key can be used
    /// to activate another widget, chosen automatically, or explicitly using
    /// [method@Gtk.Label.set_mnemonic_widget].
    ///
    /// If [method@Gtk.Label.set_mnemonic_widget] is not called, then the first
    /// activatable ancestor of the label will be chosen as the mnemonic
    /// widget. For instance, if the label is inside a button or menu item,
    /// the button or menu item will automatically become the mnemonic widget
    /// and be activated by the mnemonic.
    public convenience init(mnemonic string: String) {
        self.init(
            gtk_label_new_with_mnemonic(string)
        )
    }

    override func didMoveToParent() {
        super.didMoveToParent()

        addSignal(name: "activate-current-link") { [weak self] () in
            guard let self = self else { return }
            self.activateCurrentLink?(self)
        }

        let handler1:
            @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CChar>, UnsafeMutableRawPointer)
                -> Void =
                { _, value1, data in
                    SignalBox1<UnsafePointer<CChar>>.run(data, value1)
                }

        addSignal(name: "activate-link", handler: gCallback(handler1)) {
            [weak self] (param0: UnsafePointer<CChar>) in
            guard let self = self else { return }
            self.activateLink?(self, param0)
        }

        addSignal(name: "copy-clipboard") { [weak self] () in
            guard let self = self else { return }
            self.copyClipboard?(self)
        }

        let handler3:
            @convention(c) (
                UnsafeMutableRawPointer, GtkMovementStep, Int, Bool, UnsafeMutableRawPointer
            ) -> Void =
                { _, value1, value2, value3, data in
                    SignalBox3<GtkMovementStep, Int, Bool>.run(data, value1, value2, value3)
                }

        addSignal(name: "move-cursor", handler: gCallback(handler3)) {
            [weak self] (param0: GtkMovementStep, param1: Int, param2: Bool) in
            guard let self = self else { return }
            self.moveCursor?(self, param0, param1, param2)
        }

        let handler4:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::attributes", handler: gCallback(handler4)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyAttributes?(self, param0)
        }

        let handler5:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::ellipsize", handler: gCallback(handler5)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyEllipsize?(self, param0)
        }

        let handler6:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::extra-menu", handler: gCallback(handler6)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyExtraMenu?(self, param0)
        }

        let handler7:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::justify", handler: gCallback(handler7)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyJustify?(self, param0)
        }

        let handler8:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::label", handler: gCallback(handler8)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyLabel?(self, param0)
        }

        let handler9:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::lines", handler: gCallback(handler9)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyLines?(self, param0)
        }

        let handler10:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::max-width-chars", handler: gCallback(handler10)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyMaxWidthChars?(self, param0)
        }

        let handler11:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::mnemonic-keyval", handler: gCallback(handler11)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyMnemonicKeyval?(self, param0)
        }

        let handler12:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::natural-wrap-mode", handler: gCallback(handler12)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyNaturalWrapMode?(self, param0)
        }

        let handler13:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::selectable", handler: gCallback(handler13)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifySelectable?(self, param0)
        }

        let handler14:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::single-line-mode", handler: gCallback(handler14)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifySingleLineMode?(self, param0)
        }

        let handler15:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::tabs", handler: gCallback(handler15)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyTabs?(self, param0)
        }

        let handler16:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::use-markup", handler: gCallback(handler16)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyUseMarkup?(self, param0)
        }

        let handler17:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::use-underline", handler: gCallback(handler17)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyUseUnderline?(self, param0)
        }

        let handler18:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::width-chars", handler: gCallback(handler18)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyWidthChars?(self, param0)
        }

        let handler19:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::wrap", handler: gCallback(handler19)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyWrap?(self, param0)
        }

        let handler20:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::wrap-mode", handler: gCallback(handler20)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyWrapMode?(self, param0)
        }

        let handler21:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::xalign", handler: gCallback(handler21)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyXalign?(self, param0)
        }

        let handler22:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::yalign", handler: gCallback(handler22)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyYalign?(self, param0)
        }
    }

    /// The alignment of the lines in the text of the label, relative to each other.
    ///
    /// This does *not* affect the alignment of the label within its allocation.
    /// See [property@Gtk.Label:xalign] for that.
    @GObjectProperty(named: "justify") public var justify: Justification

    /// The contents of the label.
    ///
    /// If the string contains Pango markup (see [func@Pango.parse_markup]),
    /// you will have to set the [property@Gtk.Label:use-markup] property to
    /// true in order for the label to display the markup attributes. See also
    /// [method@Gtk.Label.set_markup] for a convenience function that sets both
    /// this property and the [property@Gtk.Label:use-markup] property at the
    /// same time.
    ///
    /// If the string contains underlines acting as mnemonics, you will have to
    /// set the [property@Gtk.Label:use-underline] property to true in order
    /// for the label to display them.
    @GObjectProperty(named: "label") public var label: String

    /// The number of lines to which an ellipsized, wrapping label
    /// should display before it gets ellipsized. This both prevents the label
    /// from ellipsizing before this many lines are displayed, and limits the
    /// height request of the label to this many lines.
    ///
    /// ::: warning
    /// Setting this property has unintuitive and unfortunate consequences
    /// for the minimum _width_ of the label. Specifically, if the height
    /// of the label is such that it fits a smaller number of lines than
    /// the value of this property, the label can not be ellipsized at all,
    /// which means it must be wide enough to fit all the text fully.
    ///
    /// This property has no effect if the label is not wrapping or ellipsized.
    ///
    /// Set this property to -1 if you don't want to limit the number of lines.
    @GObjectProperty(named: "lines") public var lines: Int

    /// The desired maximum width of the label, in characters.
    ///
    /// If this property is set to -1, the width will be calculated automatically.
    ///
    /// See the section on [text layout](class.Label.html#text-layout) for details
    /// of how [property@Gtk.Label:width-chars] and [property@Gtk.Label:max-width-chars]
    /// determine the width of ellipsized and wrapped labels.
    @GObjectProperty(named: "max-width-chars") public var maxWidthChars: Int

    /// The mnemonic accelerator key for the label.
    @GObjectProperty(named: "mnemonic-keyval") public var mnemonicKeyval: UInt

    /// Whether the label text can be selected with the mouse.
    @GObjectProperty(named: "selectable") public var selectable: Bool

    /// Whether the label is in single line mode.
    ///
    /// In single line mode, the height of the label does not depend on the
    /// actual text, it is always set to ascent + descent of the font. This
    /// can be an advantage in situations where resizing the label because
    /// of text changes would be distracting, e.g. in a statusbar.
    @GObjectProperty(named: "single-line-mode") public var singleLineMode: Bool

    /// True if the text of the label includes Pango markup.
    ///
    /// See [func@Pango.parse_markup].
    @GObjectProperty(named: "use-markup") public var useMarkup: Bool

    /// True if the text of the label indicates a mnemonic with an `_`
    /// before the mnemonic character.
    @GObjectProperty(named: "use-underline") public var useUnderline: Bool

    /// The desired width of the label, in characters.
    ///
    /// If this property is set to -1, the width will be calculated automatically.
    ///
    /// See the section on [text layout](class.Label.html#text-layout) for details
    /// of how [property@Gtk.Label:width-chars] and [property@Gtk.Label:max-width-chars]
    /// determine the width of ellipsized and wrapped labels.
    @GObjectProperty(named: "width-chars") public var widthChars: Int

    /// True if the label text will wrap if it gets too wide.
    @GObjectProperty(named: "wrap") public var wrap: Bool

    /// The horizontal alignment of the label text inside its size allocation.
    ///
    /// Compare this to [property@Gtk.Widget:halign], which determines how the
    /// labels size allocation is positioned in the space available for the label.
    @GObjectProperty(named: "xalign") public var xalign: Float

    /// The vertical alignment of the label text inside its size allocation.
    ///
    /// Compare this to [property@Gtk.Widget:valign], which determines how the
    /// labels size allocation is positioned in the space available for the label.
    @GObjectProperty(named: "yalign") public var yalign: Float

    /// Gets emitted when the user activates a link in the label.
    ///
    /// The `::activate-current-link` is a [keybinding signal](class.SignalAction.html).
    ///
    /// Applications may also emit the signal with g_signal_emit_by_name()
    /// if they need to control activation of URIs programmatically.
    ///
    /// The default bindings for this signal are all forms of the <kbd>Enter</kbd> key.
    public var activateCurrentLink: ((Label) -> Void)?

    /// Gets emitted to activate a URI.
    ///
    /// Applications may connect to it to override the default behaviour,
    /// which is to call [method@Gtk.FileLauncher.launch].
    public var activateLink: ((Label, UnsafePointer<CChar>) -> Void)?

    /// Gets emitted to copy the selection to the clipboard.
    ///
    /// The `::copy-clipboard` signal is a [keybinding signal](class.SignalAction.html).
    ///
    /// The default binding for this signal is <kbd>Ctrl</kbd>+<kbd>c</kbd>.
    public var copyClipboard: ((Label) -> Void)?

    /// Gets emitted when the user initiates a cursor movement.
    ///
    /// The `::move-cursor` signal is a [keybinding signal](class.SignalAction.html).
    /// If the cursor is not visible in @entry, this signal causes the viewport to
    /// be moved instead.
    ///
    /// Applications should not connect to it, but may emit it with
    /// [func@GObject.signal_emit_by_name] if they need to control
    /// the cursor programmatically.
    ///
    /// The default bindings for this signal come in two variants, the
    /// variant with the <kbd>Shift</kbd> modifier extends the selection,
    /// the variant without the <kbd>Shift</kbd> modifier does not.
    /// There are too many key combinations to list them all here.
    ///
    /// - <kbd>←</kbd>, <kbd>→</kbd>, <kbd>↑</kbd>, <kbd>↓</kbd>
    /// move by individual characters/lines
    /// - <kbd>Ctrl</kbd>+<kbd>←</kbd>, etc. move by words/paragraphs
    /// - <kbd>Home</kbd> and <kbd>End</kbd> move to the ends of the buffer
    public var moveCursor: ((Label, GtkMovementStep, Int, Bool) -> Void)?

    public var notifyAttributes: ((Label, OpaquePointer) -> Void)?

    public var notifyEllipsize: ((Label, OpaquePointer) -> Void)?

    public var notifyExtraMenu: ((Label, OpaquePointer) -> Void)?

    public var notifyJustify: ((Label, OpaquePointer) -> Void)?

    public var notifyLabel: ((Label, OpaquePointer) -> Void)?

    public var notifyLines: ((Label, OpaquePointer) -> Void)?

    public var notifyMaxWidthChars: ((Label, OpaquePointer) -> Void)?

    public var notifyMnemonicKeyval: ((Label, OpaquePointer) -> Void)?

    public var notifyNaturalWrapMode: ((Label, OpaquePointer) -> Void)?

    public var notifySelectable: ((Label, OpaquePointer) -> Void)?

    public var notifySingleLineMode: ((Label, OpaquePointer) -> Void)?

    public var notifyTabs: ((Label, OpaquePointer) -> Void)?

    public var notifyUseMarkup: ((Label, OpaquePointer) -> Void)?

    public var notifyUseUnderline: ((Label, OpaquePointer) -> Void)?

    public var notifyWidthChars: ((Label, OpaquePointer) -> Void)?

    public var notifyWrap: ((Label, OpaquePointer) -> Void)?

    public var notifyWrapMode: ((Label, OpaquePointer) -> Void)?

    public var notifyXalign: ((Label, OpaquePointer) -> Void)?

    public var notifyYalign: ((Label, OpaquePointer) -> Void)?
}
