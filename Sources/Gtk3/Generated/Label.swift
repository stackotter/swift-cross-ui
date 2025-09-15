import CGtk3

/// The #GtkLabel widget displays a small amount of text. As the name
/// implies, most labels are used to label another widget such as a
/// #GtkButton, a #GtkMenuItem, or a #GtkComboBox.
///
/// # CSS nodes
///
/// |[<!-- language="plain" -->
/// label
/// ├── [selection]
/// ├── [link]
/// ┊
/// ╰── [link]
/// ]|
///
/// GtkLabel has a single CSS node with the name label. A wide variety
/// of style classes may be applied to labels, such as .title, .subtitle,
/// .dim-label, etc. In the #GtkShortcutsWindow, labels are used wth the
/// .keycap style class.
///
/// If the label has a selection, it gets a subnode with name selection.
///
/// If the label has links, there is one subnode per link. These subnodes
/// carry the link or visited state depending on whether they have been
/// visited.
///
/// # GtkLabel as GtkBuildable
///
/// The GtkLabel implementation of the GtkBuildable interface supports a
/// custom `<attributes>` element, which supports any number of `<attribute>`
/// elements. The `<attribute>` element has attributes named “name“, “value“,
/// “start“ and “end“ and allows you to specify #PangoAttribute values for
/// this label.
///
/// An example of a UI definition fragment specifying Pango attributes:
///
/// |[<!-- language="xml" --><object class="GtkLabel"><attributes><attribute name="weight" value="PANGO_WEIGHT_BOLD"/><attribute name="background" value="red" start="5" end="10"/></attributes></object>
/// ]|
///
/// The start and end attributes specify the range of characters to which the
/// Pango attribute applies. If start and end are not specified, the attribute is
/// applied to the whole text. Note that specifying ranges does not make much
/// sense with translatable attributes. Use markup embedded in the translatable
/// content instead.
///
/// # Mnemonics
///
/// Labels may contain “mnemonics”. Mnemonics are
/// underlined characters in the label, used for keyboard navigation.
/// Mnemonics are created by providing a string with an underscore before
/// the mnemonic character, such as `"_File"`, to the
/// functions gtk_label_new_with_mnemonic() or
/// gtk_label_set_text_with_mnemonic().
///
/// Mnemonics automatically activate any activatable widget the label is
/// inside, such as a #GtkButton; if the label is not inside the
/// mnemonic’s target widget, you have to tell the label about the target
/// using gtk_label_set_mnemonic_widget(). Here’s a simple example where
/// the label is inside a button:
///
/// |[<!-- language="C" -->
/// // Pressing Alt+H will activate this button
/// GtkWidget *button = gtk_button_new ();
/// GtkWidget *label = gtk_label_new_with_mnemonic ("_Hello");
/// gtk_container_add (GTK_CONTAINER (button), label);
/// ]|
///
/// There’s a convenience function to create buttons with a mnemonic label
/// already inside:
///
/// |[<!-- language="C" -->
/// // Pressing Alt+H will activate this button
/// GtkWidget *button = gtk_button_new_with_mnemonic ("_Hello");
/// ]|
///
/// To create a mnemonic for a widget alongside the label, such as a
/// #GtkEntry, you have to point the label at the entry with
/// gtk_label_set_mnemonic_widget():
///
/// |[<!-- language="C" -->
/// // Pressing Alt+H will focus the entry
/// GtkWidget *entry = gtk_entry_new ();
/// GtkWidget *label = gtk_label_new_with_mnemonic ("_Hello");
/// gtk_label_set_mnemonic_widget (GTK_LABEL (label), entry);
/// ]|
///
/// # Markup (styled text)
///
/// To make it easy to format text in a label (changing colors,
/// fonts, etc.), label text can be provided in a simple
/// [markup format][PangoMarkupFormat].
///
/// Here’s how to create a label with a small font:
/// |[<!-- language="C" -->
/// GtkWidget *label = gtk_label_new (NULL);
/// gtk_label_set_markup (GTK_LABEL (label), "<small>Small text</small>");
/// ]|
///
/// (See [complete documentation][PangoMarkupFormat] of available
/// tags in the Pango manual.)
///
/// The markup passed to gtk_label_set_markup() must be valid; for example,
/// literal <, > and & characters must be escaped as &lt;, &gt;, and &amp;.
/// If you pass text obtained from the user, file, or a network to
/// gtk_label_set_markup(), you’ll want to escape it with
/// g_markup_escape_text() or g_markup_printf_escaped().
///
/// Markup strings are just a convenient way to set the #PangoAttrList on
/// a label; gtk_label_set_attributes() may be a simpler way to set
/// attributes in some cases. Be careful though; #PangoAttrList tends to
/// cause internationalization problems, unless you’re applying attributes
/// to the entire string (i.e. unless you set the range of each attribute
/// to [0, %G_MAXINT)). The reason is that specifying the start_index and
/// end_index for a #PangoAttribute requires knowledge of the exact string
/// being displayed, so translations will cause problems.
///
/// # Selectable labels
///
/// Labels can be made selectable with gtk_label_set_selectable().
/// Selectable labels allow the user to copy the label contents to
/// the clipboard. Only labels that contain useful-to-copy information
/// — such as error messages — should be made selectable.
///
/// # Text layout # {#label-text-layout}
///
/// A label can contain any number of paragraphs, but will have
/// performance problems if it contains more than a small number.
/// Paragraphs are separated by newlines or other paragraph separators
/// understood by Pango.
///
/// Labels can automatically wrap text if you call
/// gtk_label_set_line_wrap().
///
/// gtk_label_set_justify() sets how the lines in a label align
/// with one another. If you want to set how the label as a whole
/// aligns in its available space, see the #GtkWidget:halign and
/// #GtkWidget:valign properties.
///
/// The #GtkLabel:width-chars and #GtkLabel:max-width-chars properties
/// can be used to control the size allocation of ellipsized or wrapped
/// labels. For ellipsizing labels, if either is specified (and less
/// than the actual text size), it is used as the minimum width, and the actual
/// text size is used as the natural width of the label. For wrapping labels,
/// width-chars is used as the minimum width, if specified, and max-width-chars
/// is used as the natural width. Even if max-width-chars specified, wrapping
/// labels will be rewrapped to use all of the available width.
///
/// Note that the interpretation of #GtkLabel:width-chars and
/// #GtkLabel:max-width-chars has changed a bit with the introduction of
/// [width-for-height geometry management.][geometry-management]
///
/// # Links
///
/// Since 2.18, GTK+ supports markup for clickable hyperlinks in addition
/// to regular Pango markup. The markup for links is borrowed from HTML,
/// using the `<a>` with “href“ and “title“ attributes. GTK+ renders links
/// similar to the way they appear in web browsers, with colored, underlined
/// text. The “title“ attribute is displayed as a tooltip on the link.
///
/// An example looks like this:
///
/// |[<!-- language="C" -->
/// const gchar *text =
/// "Go to the"
/// "<a href=\"http://www.gtk.org title=\"&lt;i&gt;Our&lt;/i&gt; website\">"
/// "GTK+ website</a> for more...";
/// GtkWidget *label = gtk_label_new (NULL);
/// gtk_label_set_markup (GTK_LABEL (label), text);
/// ]|
///
/// It is possible to implement custom handling for links and their tooltips with
/// the #GtkLabel::activate-link signal and the gtk_label_get_current_uri() function.
open class Label: Misc {
    /// Creates a new label with the given text inside it. You can
    /// pass %NULL to get an empty label widget.
    public convenience init(string: String) {
        self.init(
            gtk_label_new(string)
        )
    }

    /// Creates a new #GtkLabel, containing the text in @str.
    ///
    /// If characters in @str are preceded by an underscore, they are
    /// underlined. If you need a literal underscore character in a label, use
    /// '__' (two underscores). The first underlined character represents a
    /// keyboard accelerator called a mnemonic. The mnemonic key can be used
    /// to activate another widget, chosen automatically, or explicitly using
    /// gtk_label_set_mnemonic_widget().
    ///
    /// If gtk_label_set_mnemonic_widget() is not called, then the first
    /// activatable ancestor of the #GtkLabel will be chosen as the mnemonic
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

        addSignal(name: "notify::angle", handler: gCallback(handler4)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyAngle?(self, param0)
        }

        let handler5:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::attributes", handler: gCallback(handler5)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyAttributes?(self, param0)
        }

        let handler6:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::cursor-position", handler: gCallback(handler6)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyCursorPosition?(self, param0)
        }

        let handler7:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::ellipsize", handler: gCallback(handler7)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyEllipsize?(self, param0)
        }

        let handler8:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::justify", handler: gCallback(handler8)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyJustify?(self, param0)
        }

        let handler9:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::label", handler: gCallback(handler9)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyLabel?(self, param0)
        }

        let handler10:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::lines", handler: gCallback(handler10)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyLines?(self, param0)
        }

        let handler11:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::max-width-chars", handler: gCallback(handler11)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyMaxWidthChars?(self, param0)
        }

        let handler12:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::mnemonic-keyval", handler: gCallback(handler12)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyMnemonicKeyval?(self, param0)
        }

        let handler13:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::pattern", handler: gCallback(handler13)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPattern?(self, param0)
        }

        let handler14:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::selectable", handler: gCallback(handler14)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifySelectable?(self, param0)
        }

        let handler15:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::selection-bound", handler: gCallback(handler15)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifySelectionBound?(self, param0)
        }

        let handler16:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::single-line-mode", handler: gCallback(handler16)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifySingleLineMode?(self, param0)
        }

        let handler17:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::track-visited-links", handler: gCallback(handler17)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyTrackVisitedLinks?(self, param0)
        }

        let handler18:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::use-markup", handler: gCallback(handler18)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyUseMarkup?(self, param0)
        }

        let handler19:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::use-underline", handler: gCallback(handler19)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyUseUnderline?(self, param0)
        }

        let handler20:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::width-chars", handler: gCallback(handler20)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyWidthChars?(self, param0)
        }

        let handler21:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::wrap", handler: gCallback(handler21)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyWrap?(self, param0)
        }

        let handler22:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::wrap-mode", handler: gCallback(handler22)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyWrapMode?(self, param0)
        }

        let handler23:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::xalign", handler: gCallback(handler23)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyXalign?(self, param0)
        }

        let handler24:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::yalign", handler: gCallback(handler24)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyYalign?(self, param0)
        }
    }

    @GObjectProperty(named: "justify") public var justify: Justification

    /// The contents of the label.
    ///
    /// If the string contains [Pango XML markup][PangoMarkupFormat], you will
    /// have to set the #GtkLabel:use-markup property to %TRUE in order for the
    /// label to display the markup attributes. See also gtk_label_set_markup()
    /// for a convenience function that sets both this property and the
    /// #GtkLabel:use-markup property at the same time.
    ///
    /// If the string contains underlines acting as mnemonics, you will have to
    /// set the #GtkLabel:use-underline property to %TRUE in order for the label
    /// to display them.
    @GObjectProperty(named: "label") public var label: String

    @GObjectProperty(named: "mnemonic-keyval") public var mnemonicKeyval: UInt

    @GObjectProperty(named: "selectable") public var selectable: Bool

    @GObjectProperty(named: "use-markup") public var useMarkup: Bool

    @GObjectProperty(named: "use-underline") public var useUnderline: Bool

    /// A [keybinding signal][GtkBindingSignal]
    /// which gets emitted when the user activates a link in the label.
    ///
    /// Applications may also emit the signal with g_signal_emit_by_name()
    /// if they need to control activation of URIs programmatically.
    ///
    /// The default bindings for this signal are all forms of the Enter key.
    public var activateCurrentLink: ((Label) -> Void)?

    /// The signal which gets emitted to activate a URI.
    /// Applications may connect to it to override the default behaviour,
    /// which is to call gtk_show_uri_on_window().
    public var activateLink: ((Label, UnsafePointer<CChar>) -> Void)?

    /// The ::copy-clipboard signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted to copy the selection to the clipboard.
    ///
    /// The default binding for this signal is Ctrl-c.
    public var copyClipboard: ((Label) -> Void)?

    /// The ::move-cursor signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted when the user initiates a cursor movement.
    /// If the cursor is not visible in @entry, this signal causes
    /// the viewport to be moved instead.
    ///
    /// Applications should not connect to it, but may emit it with
    /// g_signal_emit_by_name() if they need to control the cursor
    /// programmatically.
    ///
    /// The default bindings for this signal come in two variants,
    /// the variant with the Shift modifier extends the selection,
    /// the variant without the Shift modifer does not.
    /// There are too many key combinations to list them all here.
    /// - Arrow keys move by individual characters/lines
    /// - Ctrl-arrow key combinations move by words/paragraphs
    /// - Home/End keys move to the ends of the buffer
    public var moveCursor: ((Label, GtkMovementStep, Int, Bool) -> Void)?

    public var notifyAngle: ((Label, OpaquePointer) -> Void)?

    public var notifyAttributes: ((Label, OpaquePointer) -> Void)?

    public var notifyCursorPosition: ((Label, OpaquePointer) -> Void)?

    public var notifyEllipsize: ((Label, OpaquePointer) -> Void)?

    public var notifyJustify: ((Label, OpaquePointer) -> Void)?

    public var notifyLabel: ((Label, OpaquePointer) -> Void)?

    public var notifyLines: ((Label, OpaquePointer) -> Void)?

    public var notifyMaxWidthChars: ((Label, OpaquePointer) -> Void)?

    public var notifyMnemonicKeyval: ((Label, OpaquePointer) -> Void)?

    public var notifyPattern: ((Label, OpaquePointer) -> Void)?

    public var notifySelectable: ((Label, OpaquePointer) -> Void)?

    public var notifySelectionBound: ((Label, OpaquePointer) -> Void)?

    public var notifySingleLineMode: ((Label, OpaquePointer) -> Void)?

    public var notifyTrackVisitedLinks: ((Label, OpaquePointer) -> Void)?

    public var notifyUseMarkup: ((Label, OpaquePointer) -> Void)?

    public var notifyUseUnderline: ((Label, OpaquePointer) -> Void)?

    public var notifyWidthChars: ((Label, OpaquePointer) -> Void)?

    public var notifyWrap: ((Label, OpaquePointer) -> Void)?

    public var notifyWrapMode: ((Label, OpaquePointer) -> Void)?

    public var notifyXalign: ((Label, OpaquePointer) -> Void)?

    public var notifyYalign: ((Label, OpaquePointer) -> Void)?
}
