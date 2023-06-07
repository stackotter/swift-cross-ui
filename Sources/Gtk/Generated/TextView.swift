import CGtk

/// A widget that displays the contents of a [class@Gtk.TextBuffer].
///
/// ![An example GtkTextview](multiline-text.png)
///
/// You may wish to begin by reading the [conceptual overview](section-text-widget.html),
/// which gives an overview of all the objects and data types related to the
/// text widget and how they work together.
///
/// ## CSS nodes
///
/// ```
/// textview.view
/// ├── border.top
/// ├── border.left
/// ├── text
/// │   ╰── [selection]
/// ├── border.right
/// ├── border.bottom
/// ╰── [window.popup]
/// ```
///
/// `GtkTextView` has a main css node with name textview and style class .view,
/// and subnodes for each of the border windows, and the main text area,
/// with names border and text, respectively. The border nodes each get
/// one of the style classes .left, .right, .top or .bottom.
///
/// A node representing the selection will appear below the text node.
///
/// If a context menu is opened, the window node will appear as a subnode
/// of the main node.
///
/// ## Accessibility
///
/// `GtkTextView` uses the %GTK_ACCESSIBLE_ROLE_TEXT_BOX role.
public class TextView: Widget, Scrollable {
    /// Creates a new `GtkTextView`.
    ///
    /// If you don’t call [method@Gtk.TextView.set_buffer] before using the
    /// text view, an empty default buffer will be created for you. Get the
    /// buffer with [method@Gtk.TextView.get_buffer]. If you want to specify
    /// your own buffer, consider [ctor@Gtk.TextView.new_with_buffer].
    override public init() {
        super.init()
        widgetPointer = gtk_text_view_new()
    }

    /// Creates a new `GtkTextView` widget displaying the buffer @buffer.
    ///
    /// One buffer can be shared among many widgets. @buffer may be %NULL
    /// to create a default buffer, in which case this function is equivalent
    /// to [ctor@Gtk.TextView.new]. The text view adds its own reference count
    /// to the buffer; it does not take over an existing reference.
    public init(buffer: UnsafeMutablePointer<GtkTextBuffer>!) {
        super.init()
        widgetPointer = gtk_text_view_new_with_buffer(buffer)
    }

    override func didMoveToParent() {
        super.didMoveToParent()

        addSignal(name: "backspace") { [weak self] () in
            guard let self = self else { return }
            self.backspace?(self)
        }

        addSignal(name: "copy-clipboard") { [weak self] () in
            guard let self = self else { return }
            self.copyClipboard?(self)
        }

        addSignal(name: "cut-clipboard") { [weak self] () in
            guard let self = self else { return }
            self.cutClipboard?(self)
        }

        let handler3:
            @convention(c) (UnsafeMutableRawPointer, GtkDeleteType, Int, UnsafeMutableRawPointer) ->
                Void =
                { _, value1, value2, data in
                    SignalBox2<GtkDeleteType, Int>.run(data, value1, value2)
                }

        addSignal(name: "delete-from-cursor", handler: gCallback(handler3)) {
            [weak self] (_: GtkDeleteType, _: Int) in
            guard let self = self else { return }
            self.deleteFromCursor?(self)
        }

        let handler4:
            @convention(c) (
                UnsafeMutableRawPointer, GtkTextExtendSelection, GtkTextIter, GtkTextIter,
                GtkTextIter, UnsafeMutableRawPointer
            ) -> Void =
                { _, value1, value2, value3, value4, data in
                    SignalBox4<GtkTextExtendSelection, GtkTextIter, GtkTextIter, GtkTextIter>.run(
                        data, value1, value2, value3, value4)
                }

        addSignal(name: "extend-selection", handler: gCallback(handler4)) {
            [weak self] (_: GtkTextExtendSelection, _: GtkTextIter, _: GtkTextIter, _: GtkTextIter)
            in
            guard let self = self else { return }
            self.extendSelection?(self)
        }

        let handler5:
            @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CChar>, UnsafeMutableRawPointer)
                -> Void =
                { _, value1, data in
                    SignalBox1<UnsafePointer<CChar>>.run(data, value1)
                }

        addSignal(name: "insert-at-cursor", handler: gCallback(handler5)) {
            [weak self] (_: UnsafePointer<CChar>) in
            guard let self = self else { return }
            self.insertAtCursor?(self)
        }

        addSignal(name: "insert-emoji") { [weak self] () in
            guard let self = self else { return }
            self.insertEmoji?(self)
        }

        let handler7:
            @convention(c) (
                UnsafeMutableRawPointer, GtkMovementStep, Int, Bool, UnsafeMutableRawPointer
            ) -> Void =
                { _, value1, value2, value3, data in
                    SignalBox3<GtkMovementStep, Int, Bool>.run(data, value1, value2, value3)
                }

        addSignal(name: "move-cursor", handler: gCallback(handler7)) {
            [weak self] (_: GtkMovementStep, _: Int, _: Bool) in
            guard let self = self else { return }
            self.moveCursor?(self)
        }

        let handler8:
            @convention(c) (UnsafeMutableRawPointer, GtkScrollStep, Int, UnsafeMutableRawPointer) ->
                Void =
                { _, value1, value2, data in
                    SignalBox2<GtkScrollStep, Int>.run(data, value1, value2)
                }

        addSignal(name: "move-viewport", handler: gCallback(handler8)) {
            [weak self] (_: GtkScrollStep, _: Int) in
            guard let self = self else { return }
            self.moveViewport?(self)
        }

        addSignal(name: "paste-clipboard") { [weak self] () in
            guard let self = self else { return }
            self.pasteClipboard?(self)
        }

        let handler10:
            @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CChar>, UnsafeMutableRawPointer)
                -> Void =
                { _, value1, data in
                    SignalBox1<UnsafePointer<CChar>>.run(data, value1)
                }

        addSignal(name: "preedit-changed", handler: gCallback(handler10)) {
            [weak self] (_: UnsafePointer<CChar>) in
            guard let self = self else { return }
            self.preeditChanged?(self)
        }

        let handler11:
            @convention(c) (UnsafeMutableRawPointer, Bool, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<Bool>.run(data, value1)
                }

        addSignal(name: "select-all", handler: gCallback(handler11)) { [weak self] (_: Bool) in
            guard let self = self else { return }
            self.selectAll?(self)
        }

        addSignal(name: "set-anchor") { [weak self] () in
            guard let self = self else { return }
            self.setAnchor?(self)
        }

        addSignal(name: "toggle-cursor-visible") { [weak self] () in
            guard let self = self else { return }
            self.toggleCursorVisible?(self)
        }

        addSignal(name: "toggle-overwrite") { [weak self] () in
            guard let self = self else { return }
            self.toggleOverwrite?(self)
        }
    }

    /// Whether Tab will result in a tab character being entered.
    @GObjectProperty(named: "accepts-tab") public var acceptsTab: Bool

    /// The bottom margin for text in the text view.
    ///
    /// Note that this property is confusingly named. In CSS terms,
    /// the value set here is padding, and it is applied in addition
    /// to the padding from the theme.
    ///
    /// Don't confuse this property with [property@Gtk.Widget:margin-bottom].
    @GObjectProperty(named: "bottom-margin") public var bottomMargin: Int

    /// If the insertion cursor is shown.
    @GObjectProperty(named: "cursor-visible") public var cursorVisible: Bool

    @GObjectProperty(named: "editable") public var editable: Bool

    /// Amount to indent the paragraph, in pixels.
    ///
    /// A negative value of indent will produce a hanging indentation.
    /// That is, the first line will have the full width, and subsequent
    /// lines will be indented by the absolute value of indent.
    @GObjectProperty(named: "indent") public var indent: Int

    /// The purpose of this text field.
    ///
    /// This property can be used by on-screen keyboards and other input
    /// methods to adjust their behaviour.
    @GObjectProperty(named: "input-purpose") public var inputPurpose: InputPurpose

    @GObjectProperty(named: "justification") public var justification: Justification

    /// The default left margin for text in the text view.
    ///
    /// Tags in the buffer may override the default.
    ///
    /// Note that this property is confusingly named. In CSS terms,
    /// the value set here is padding, and it is applied in addition
    /// to the padding from the theme.
    @GObjectProperty(named: "left-margin") public var leftMargin: Int

    /// Whether text should be displayed in a monospace font.
    ///
    /// If %TRUE, set the .monospace style class on the
    /// text view to indicate that a monospace font is desired.
    @GObjectProperty(named: "monospace") public var monospace: Bool

    /// Whether entered text overwrites existing contents.
    @GObjectProperty(named: "overwrite") public var overwrite: Bool

    @GObjectProperty(named: "pixels-above-lines") public var pixelsAboveLines: Int

    @GObjectProperty(named: "pixels-below-lines") public var pixelsBelowLines: Int

    @GObjectProperty(named: "pixels-inside-wrap") public var pixelsInsideWrap: Int

    /// The default right margin for text in the text view.
    ///
    /// Tags in the buffer may override the default.
    ///
    /// Note that this property is confusingly named. In CSS terms,
    /// the value set here is padding, and it is applied in addition
    /// to the padding from the theme.
    @GObjectProperty(named: "right-margin") public var rightMargin: Int

    /// The top margin for text in the text view.
    ///
    /// Note that this property is confusingly named. In CSS terms,
    /// the value set here is padding, and it is applied in addition
    /// to the padding from the theme.
    ///
    /// Don't confuse this property with [property@Gtk.Widget:margin-top].
    @GObjectProperty(named: "top-margin") public var topMargin: Int

    @GObjectProperty(named: "wrap-mode") public var wrapMode: WrapMode

    /// Determines when horizontal scrolling should start.
    @GObjectProperty(named: "hscroll-policy") public var hscrollPolicy: ScrollablePolicy

    /// Determines when vertical scrolling should start.
    @GObjectProperty(named: "vscroll-policy") public var vscrollPolicy: ScrollablePolicy

    /// Gets emitted when the user asks for it.
    ///
    /// The ::backspace signal is a [keybinding signal](class.SignalAction.html).
    ///
    /// The default bindings for this signal are
    /// <kbd>Backspace</kbd> and <kbd>Shift</kbd>+<kbd>Backspace</kbd>.
    public var backspace: ((TextView) -> Void)?

    /// Gets emitted to copy the selection to the clipboard.
    ///
    /// The ::copy-clipboard signal is a [keybinding signal](class.SignalAction.html).
    ///
    /// The default bindings for this signal are
    /// <kbd>Ctrl</kbd>+<kbd>c</kbd> and
    /// <kbd>Ctrl</kbd>+<kbd>Insert</kbd>.
    public var copyClipboard: ((TextView) -> Void)?

    /// Gets emitted to cut the selection to the clipboard.
    ///
    /// The ::cut-clipboard signal is a [keybinding signal](class.SignalAction.html).
    ///
    /// The default bindings for this signal are
    /// <kbd>Ctrl</kbd>+<kbd>x</kbd> and
    /// <kbd>Shift</kbd>+<kbd>Delete</kbd>.
    public var cutClipboard: ((TextView) -> Void)?

    /// Gets emitted when the user initiates a text deletion.
    ///
    /// The ::delete-from-cursor signal is a [keybinding signal](class.SignalAction.html).
    ///
    /// If the @type is %GTK_DELETE_CHARS, GTK deletes the selection
    /// if there is one, otherwise it deletes the requested number
    /// of characters.
    ///
    /// The default bindings for this signal are <kbd>Delete</kbd> for
    /// deleting a character, <kbd>Ctrl</kbd>+<kbd>Delete</kbd> for
    /// deleting a word and <kbd>Ctrl</kbd>+<kbd>Backspace</kbd> for
    /// deleting a word backwards.
    public var deleteFromCursor: ((TextView) -> Void)?

    /// Emitted when the selection needs to be extended at @location.
    public var extendSelection: ((TextView) -> Void)?

    /// Gets emitted when the user initiates the insertion of a
    /// fixed string at the cursor.
    ///
    /// The ::insert-at-cursor signal is a [keybinding signal](class.SignalAction.html).
    ///
    /// This signal has no default bindings.
    public var insertAtCursor: ((TextView) -> Void)?

    /// Gets emitted to present the Emoji chooser for the @text_view.
    ///
    /// The ::insert-emoji signal is a [keybinding signal](class.SignalAction.html).
    ///
    /// The default bindings for this signal are
    /// <kbd>Ctrl</kbd>+<kbd>.</kbd> and
    /// <kbd>Ctrl</kbd>+<kbd>;</kbd>
    public var insertEmoji: ((TextView) -> Void)?

    /// Gets emitted when the user initiates a cursor movement.
    ///
    /// The ::move-cursor signal is a [keybinding signal](class.SignalAction.html).
    /// If the cursor is not visible in @text_view, this signal causes
    /// the viewport to be moved instead.
    ///
    /// Applications should not connect to it, but may emit it with
    /// g_signal_emit_by_name() if they need to control the cursor
    /// programmatically.
    ///
    ///
    /// The default bindings for this signal come in two variants,
    /// the variant with the <kbd>Shift</kbd> modifier extends the
    /// selection, the variant without it does not.
    /// There are too many key combinations to list them all here.
    ///
    /// - <kbd>←</kbd>, <kbd>→</kbd>, <kbd>↑</kbd>, <kbd>↓</kbd>
    /// move by individual characters/lines
    /// - <kbd>Ctrl</kbd>+<kbd>←</kbd>, etc. move by words/paragraphs
    /// - <kbd>Home</kbd> and <kbd>End</kbd> move to the ends of the buffer
    /// - <kbd>PgUp</kbd> and <kbd>PgDn</kbd> move vertically by pages
    /// - <kbd>Ctrl</kbd>+<kbd>PgUp</kbd> and <kbd>Ctrl</kbd>+<kbd>PgDn</kbd>
    /// move horizontally by pages
    public var moveCursor: ((TextView) -> Void)?

    /// Gets emitted to move the viewport.
    ///
    /// The ::move-viewport signal is a [keybinding signal](class.SignalAction.html),
    /// which can be bound to key combinations to allow the user to move the viewport,
    /// i.e. change what part of the text view is visible in a containing scrolled
    /// window.
    ///
    /// There are no default bindings for this signal.
    public var moveViewport: ((TextView) -> Void)?

    /// Gets emitted to paste the contents of the clipboard
    /// into the text view.
    ///
    /// The ::paste-clipboard signal is a [keybinding signal](class.SignalAction.html).
    ///
    /// The default bindings for this signal are
    /// <kbd>Ctrl</kbd>+<kbd>v</kbd> and
    /// <kbd>Shift</kbd>+<kbd>Insert</kbd>.
    public var pasteClipboard: ((TextView) -> Void)?

    /// Emitted when preedit text of the active IM changes.
    ///
    /// If an input method is used, the typed text will not immediately
    /// be committed to the buffer. So if you are interested in the text,
    /// connect to this signal.
    ///
    /// This signal is only emitted if the text at the given position
    /// is actually editable.
    public var preeditChanged: ((TextView) -> Void)?

    /// Gets emitted to select or unselect the complete contents of the text view.
    ///
    /// The ::select-all signal is a [keybinding signal](class.SignalAction.html).
    ///
    /// The default bindings for this signal are
    /// <kbd>Ctrl</kbd>+<kbd>a</kbd> and
    /// <kbd>Ctrl</kbd>+<kbd>/</kbd> for selecting and
    /// <kbd>Shift</kbd>+<kbd>Ctrl</kbd>+<kbd>a</kbd> and
    /// <kbd>Ctrl</kbd>+<kbd>\</kbd> for unselecting.
    public var selectAll: ((TextView) -> Void)?

    /// Gets emitted when the user initiates settings the "anchor" mark.
    ///
    /// The ::set-anchor signal is a [keybinding signal](class.SignalAction.html)
    /// which gets emitted when the user initiates setting the "anchor"
    /// mark. The "anchor" mark gets placed at the same position as the
    /// "insert" mark.
    ///
    /// This signal has no default bindings.
    public var setAnchor: ((TextView) -> Void)?

    /// Gets emitted to toggle the `cursor-visible` property.
    ///
    /// The ::toggle-cursor-visible signal is a
    /// [keybinding signal](class.SignalAction.html).
    ///
    /// The default binding for this signal is <kbd>F7</kbd>.
    public var toggleCursorVisible: ((TextView) -> Void)?

    /// Gets emitted to toggle the overwrite mode of the text view.
    ///
    /// The ::toggle-overwrite signal is a [keybinding signal](class.SignalAction.html).
    ///
    /// The default binding for this signal is <kbd>Insert</kbd>.
    public var toggleOverwrite: ((TextView) -> Void)?
}
