import CGtk3

/// You may wish to begin by reading the
/// [text widget conceptual overview](TextWidget.html)
/// which gives an overview of all the objects and data
/// types related to the text widget and how they work together.
///
/// # CSS nodes
///
/// |[<!-- language="plain" -->
/// textview.view
/// ├── border.top
/// ├── border.left
/// ├── text
/// │   ╰── [selection]
/// ├── border.right
/// ├── border.bottom
/// ╰── [window.popup]
/// ]|
///
/// GtkTextView has a main css node with name textview and style class .view,
/// and subnodes for each of the border windows, and the main text area,
/// with names border and text, respectively. The border nodes each get
/// one of the style classes .left, .right, .top or .bottom.
///
/// A node representing the selection will appear below the text node.
///
/// If a context menu is opened, the window node will appear as a subnode
/// of the main node.
public class TextView: Container, Scrollable {
    /// Creates a new #GtkTextView. If you don’t call gtk_text_view_set_buffer()
    /// before using the text view, an empty default buffer will be created
    /// for you. Get the buffer with gtk_text_view_get_buffer(). If you want
    /// to specify your own buffer, consider gtk_text_view_new_with_buffer().
    override public init() {
        super.init()
        widgetPointer = gtk_text_view_new()
    }

    /// Creates a new #GtkTextView widget displaying the buffer
    /// @buffer. One buffer can be shared among many widgets.
    /// @buffer may be %NULL to create a default buffer, in which case
    /// this function is equivalent to gtk_text_view_new(). The
    /// text view adds its own reference count to the buffer; it does not
    /// take over an existing reference.
    public init(buffer: UnsafeMutablePointer<GtkTextBuffer>!) {
        super.init()
        widgetPointer = gtk_text_view_new_with_buffer(buffer)
    }

    override func didMoveToParent() {
        removeSignals()

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
            @convention(c) (UnsafeMutableRawPointer, GtkWidget, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<GtkWidget>.run(data, value1)
                }

        addSignal(name: "populate-popup", handler: gCallback(handler10)) {
            [weak self] (_: GtkWidget) in
            guard let self = self else { return }
            self.populatePopup?(self)
        }

        let handler11:
            @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CChar>, UnsafeMutableRawPointer)
                -> Void =
                { _, value1, data in
                    SignalBox1<UnsafePointer<CChar>>.run(data, value1)
                }

        addSignal(name: "preedit-changed", handler: gCallback(handler11)) {
            [weak self] (_: UnsafePointer<CChar>) in
            guard let self = self else { return }
            self.preeditChanged?(self)
        }

        let handler12:
            @convention(c) (UnsafeMutableRawPointer, Bool, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<Bool>.run(data, value1)
                }

        addSignal(name: "select-all", handler: gCallback(handler12)) { [weak self] (_: Bool) in
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

        let handler16:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::accepts-tab", handler: gCallback(handler16)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyAcceptsTab?(self)
        }

        let handler17:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::bottom-margin", handler: gCallback(handler17)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyBottomMargin?(self)
        }

        let handler18:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::buffer", handler: gCallback(handler18)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyBuffer?(self)
        }

        let handler19:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::cursor-visible", handler: gCallback(handler19)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyCursorVisible?(self)
        }

        let handler20:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::editable", handler: gCallback(handler20)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyEditable?(self)
        }

        let handler21:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::im-module", handler: gCallback(handler21)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyImModule?(self)
        }

        let handler22:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::indent", handler: gCallback(handler22)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyIndent?(self)
        }

        let handler23:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::input-hints", handler: gCallback(handler23)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyInputHints?(self)
        }

        let handler24:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::input-purpose", handler: gCallback(handler24)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyInputPurpose?(self)
        }

        let handler25:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::justification", handler: gCallback(handler25)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyJustification?(self)
        }

        let handler26:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::left-margin", handler: gCallback(handler26)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyLeftMargin?(self)
        }

        let handler27:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::monospace", handler: gCallback(handler27)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyMonospace?(self)
        }

        let handler28:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::overwrite", handler: gCallback(handler28)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyOverwrite?(self)
        }

        let handler29:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::pixels-above-lines", handler: gCallback(handler29)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPixelsAboveLines?(self)
        }

        let handler30:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::pixels-below-lines", handler: gCallback(handler30)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPixelsBelowLines?(self)
        }

        let handler31:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::pixels-inside-wrap", handler: gCallback(handler31)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPixelsInsideWrap?(self)
        }

        let handler32:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::populate-all", handler: gCallback(handler32)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPopulateAll?(self)
        }

        let handler33:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::right-margin", handler: gCallback(handler33)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyRightMargin?(self)
        }

        let handler34:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::tabs", handler: gCallback(handler34)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyTabs?(self)
        }

        let handler35:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::top-margin", handler: gCallback(handler35)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyTopMargin?(self)
        }

        let handler36:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::wrap-mode", handler: gCallback(handler36)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyWrapMode?(self)
        }

        let handler37:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::hadjustment", handler: gCallback(handler37)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyHadjustment?(self)
        }

        let handler38:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::hscroll-policy", handler: gCallback(handler38)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyHscrollPolicy?(self)
        }

        let handler39:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::vadjustment", handler: gCallback(handler39)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyVadjustment?(self)
        }

        let handler40:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::vscroll-policy", handler: gCallback(handler40)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyVscrollPolicy?(self)
        }
    }

    @GObjectProperty(named: "accepts-tab") public var acceptsTab: Bool

    @GObjectProperty(named: "cursor-visible") public var cursorVisible: Bool

    @GObjectProperty(named: "editable") public var editable: Bool

    @GObjectProperty(named: "indent") public var indent: Int

    @GObjectProperty(named: "justification") public var justification: Justification

    /// The default left margin for text in the text view.
    /// Tags in the buffer may override the default.
    ///
    /// Note that this property is confusingly named. In CSS terms,
    /// the value set here is padding, and it is applied in addition
    /// to the padding from the theme.
    ///
    /// Don't confuse this property with #GtkWidget:margin-left.
    @GObjectProperty(named: "left-margin") public var leftMargin: Int

    @GObjectProperty(named: "monospace") public var monospace: Bool

    @GObjectProperty(named: "overwrite") public var overwrite: Bool

    @GObjectProperty(named: "pixels-above-lines") public var pixelsAboveLines: Int

    @GObjectProperty(named: "pixels-below-lines") public var pixelsBelowLines: Int

    @GObjectProperty(named: "pixels-inside-wrap") public var pixelsInsideWrap: Int

    /// The default right margin for text in the text view.
    /// Tags in the buffer may override the default.
    ///
    /// Note that this property is confusingly named. In CSS terms,
    /// the value set here is padding, and it is applied in addition
    /// to the padding from the theme.
    ///
    /// Don't confuse this property with #GtkWidget:margin-right.
    @GObjectProperty(named: "right-margin") public var rightMargin: Int

    @GObjectProperty(named: "wrap-mode") public var wrapMode: WrapMode

    /// The ::backspace signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted when the user asks for it.
    ///
    /// The default bindings for this signal are
    /// Backspace and Shift-Backspace.
    public var backspace: ((TextView) -> Void)?

    /// The ::copy-clipboard signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted to copy the selection to the clipboard.
    ///
    /// The default bindings for this signal are
    /// Ctrl-c and Ctrl-Insert.
    public var copyClipboard: ((TextView) -> Void)?

    /// The ::cut-clipboard signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted to cut the selection to the clipboard.
    ///
    /// The default bindings for this signal are
    /// Ctrl-x and Shift-Delete.
    public var cutClipboard: ((TextView) -> Void)?

    /// The ::delete-from-cursor signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted when the user initiates a text deletion.
    ///
    /// If the @type is %GTK_DELETE_CHARS, GTK+ deletes the selection
    /// if there is one, otherwise it deletes the requested number
    /// of characters.
    ///
    /// The default bindings for this signal are
    /// Delete for deleting a character, Ctrl-Delete for
    /// deleting a word and Ctrl-Backspace for deleting a word
    /// backwords.
    public var deleteFromCursor: ((TextView) -> Void)?

    /// The ::extend-selection signal is emitted when the selection needs to be
    /// extended at @location.
    public var extendSelection: ((TextView) -> Void)?

    /// The ::insert-at-cursor signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted when the user initiates the insertion of a
    /// fixed string at the cursor.
    ///
    /// This signal has no default bindings.
    public var insertAtCursor: ((TextView) -> Void)?

    /// The ::insert-emoji signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted to present the Emoji chooser for the @text_view.
    ///
    /// The default bindings for this signal are Ctrl-. and Ctrl-;
    public var insertEmoji: ((TextView) -> Void)?

    /// The ::move-cursor signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted when the user initiates a cursor movement.
    /// If the cursor is not visible in @text_view, this signal causes
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
    /// - PageUp/PageDown keys move vertically by pages
    /// - Ctrl-PageUp/PageDown keys move horizontally by pages
    public var moveCursor: ((TextView) -> Void)?

    /// The ::move-viewport signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which can be bound to key combinations to allow the user
    /// to move the viewport, i.e. change what part of the text view
    /// is visible in a containing scrolled window.
    ///
    /// There are no default bindings for this signal.
    public var moveViewport: ((TextView) -> Void)?

    /// The ::paste-clipboard signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted to paste the contents of the clipboard
    /// into the text view.
    ///
    /// The default bindings for this signal are
    /// Ctrl-v and Shift-Insert.
    public var pasteClipboard: ((TextView) -> Void)?

    /// The ::populate-popup signal gets emitted before showing the
    /// context menu of the text view.
    ///
    /// If you need to add items to the context menu, connect
    /// to this signal and append your items to the @popup, which
    /// will be a #GtkMenu in this case.
    ///
    /// If #GtkTextView:populate-all is %TRUE, this signal will
    /// also be emitted to populate touch popups. In this case,
    /// @popup will be a different container, e.g. a #GtkToolbar.
    ///
    /// The signal handler should not make assumptions about the
    /// type of @widget, but check whether @popup is a #GtkMenu
    /// or #GtkToolbar or another kind of container.
    public var populatePopup: ((TextView) -> Void)?

    /// If an input method is used, the typed text will not immediately
    /// be committed to the buffer. So if you are interested in the text,
    /// connect to this signal.
    ///
    /// This signal is only emitted if the text at the given position
    /// is actually editable.
    public var preeditChanged: ((TextView) -> Void)?

    /// The ::select-all signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted to select or unselect the complete
    /// contents of the text view.
    ///
    /// The default bindings for this signal are Ctrl-a and Ctrl-/
    /// for selecting and Shift-Ctrl-a and Ctrl-\ for unselecting.
    public var selectAll: ((TextView) -> Void)?

    /// The ::set-anchor signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted when the user initiates setting the "anchor"
    /// mark. The "anchor" mark gets placed at the same position as the
    /// "insert" mark.
    ///
    /// This signal has no default bindings.
    public var setAnchor: ((TextView) -> Void)?

    /// The ::toggle-cursor-visible signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted to toggle the #GtkTextView:cursor-visible
    /// property.
    ///
    /// The default binding for this signal is F7.
    public var toggleCursorVisible: ((TextView) -> Void)?

    /// The ::toggle-overwrite signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted to toggle the overwrite mode of the text view.
    ///
    /// The default bindings for this signal is Insert.
    public var toggleOverwrite: ((TextView) -> Void)?

    public var notifyAcceptsTab: ((TextView) -> Void)?

    public var notifyBottomMargin: ((TextView) -> Void)?

    public var notifyBuffer: ((TextView) -> Void)?

    public var notifyCursorVisible: ((TextView) -> Void)?

    public var notifyEditable: ((TextView) -> Void)?

    public var notifyImModule: ((TextView) -> Void)?

    public var notifyIndent: ((TextView) -> Void)?

    public var notifyInputHints: ((TextView) -> Void)?

    public var notifyInputPurpose: ((TextView) -> Void)?

    public var notifyJustification: ((TextView) -> Void)?

    public var notifyLeftMargin: ((TextView) -> Void)?

    public var notifyMonospace: ((TextView) -> Void)?

    public var notifyOverwrite: ((TextView) -> Void)?

    public var notifyPixelsAboveLines: ((TextView) -> Void)?

    public var notifyPixelsBelowLines: ((TextView) -> Void)?

    public var notifyPixelsInsideWrap: ((TextView) -> Void)?

    public var notifyPopulateAll: ((TextView) -> Void)?

    public var notifyRightMargin: ((TextView) -> Void)?

    public var notifyTabs: ((TextView) -> Void)?

    public var notifyTopMargin: ((TextView) -> Void)?

    public var notifyWrapMode: ((TextView) -> Void)?

    public var notifyHadjustment: ((TextView) -> Void)?

    public var notifyHscrollPolicy: ((TextView) -> Void)?

    public var notifyVadjustment: ((TextView) -> Void)?

    public var notifyVscrollPolicy: ((TextView) -> Void)?
}
