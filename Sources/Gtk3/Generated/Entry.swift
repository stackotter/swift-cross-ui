import CGtk3

/// The #GtkEntry widget is a single line text entry
/// widget. A fairly large set of key bindings are supported
/// by default. If the entered text is longer than the allocation
/// of the widget, the widget will scroll so that the cursor
/// position is visible.
///
/// When using an entry for passwords and other sensitive information,
/// it can be put into “password mode” using gtk_entry_set_visibility().
/// In this mode, entered text is displayed using a “invisible” character.
/// By default, GTK+ picks the best invisible character that is available
/// in the current font, but it can be changed with
/// gtk_entry_set_invisible_char(). Since 2.16, GTK+ displays a warning
/// when Caps Lock or input methods might interfere with entering text in
/// a password entry. The warning can be turned off with the
/// #GtkEntry:caps-lock-warning property.
///
/// Since 2.16, GtkEntry has the ability to display progress or activity
/// information behind the text. To make an entry display such information,
/// use gtk_entry_set_progress_fraction() or gtk_entry_set_progress_pulse_step().
///
/// Additionally, GtkEntry can show icons at either side of the entry. These
/// icons can be activatable by clicking, can be set up as drag source and
/// can have tooltips. To add an icon, use gtk_entry_set_icon_from_gicon() or
/// one of the various other functions that set an icon from a stock id, an
/// icon name or a pixbuf. To trigger an action when the user clicks an icon,
/// connect to the #GtkEntry::icon-press signal. To allow DND operations
/// from an icon, use gtk_entry_set_icon_drag_source(). To set a tooltip on
/// an icon, use gtk_entry_set_icon_tooltip_text() or the corresponding function
/// for markup.
///
/// Note that functionality or information that is only available by clicking
/// on an icon in an entry may not be accessible at all to users which are not
/// able to use a mouse or other pointing device. It is therefore recommended
/// that any such functionality should also be available by other means, e.g.
/// via the context menu of the entry.
///
/// # CSS nodes
///
/// |[<!-- language="plain" -->
/// entry[.read-only][.flat][.warning][.error]
/// ├── image.left
/// ├── image.right
/// ├── undershoot.left
/// ├── undershoot.right
/// ├── [selection]
/// ├── [progress[.pulse]]
/// ╰── [window.popup]
/// ]|
///
/// GtkEntry has a main node with the name entry. Depending on the properties
/// of the entry, the style classes .read-only and .flat may appear. The style
/// classes .warning and .error may also be used with entries.
///
/// When the entry shows icons, it adds subnodes with the name image and the
/// style class .left or .right, depending on where the icon appears.
///
/// When the entry has a selection, it adds a subnode with the name selection.
///
/// When the entry shows progress, it adds a subnode with the name progress.
/// The node has the style class .pulse when the shown progress is pulsing.
///
/// The CSS node for a context menu is added as a subnode below entry as well.
///
/// The undershoot nodes are used to draw the underflow indication when content
/// is scrolled out of view. These nodes get the .left and .right style classes
/// added depending on where the indication is drawn.
///
/// When touch is used and touch selection handles are shown, they are using
/// CSS nodes with name cursor-handle. They get the .top or .bottom style class
/// depending on where they are shown in relation to the selection. If there is
/// just a single handle for the text cursor, it gets the style class
/// .insertion-cursor.
open class Entry: Widget, CellEditable, Editable {
    /// Creates a new entry.
    public convenience init() {
        self.init(
            gtk_entry_new()
        )
    }

    /// Creates a new entry with the specified text buffer.
    public convenience init(buffer: UnsafeMutablePointer<GtkEntryBuffer>!) {
        self.init(
            gtk_entry_new_with_buffer(buffer)
        )
    }

    override func didMoveToParent() {
        super.didMoveToParent()

        addSignal(name: "activate") { [weak self] () in
            guard let self = self else { return }
            self.activate?(self)
        }

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

        let handler4:
            @convention(c) (UnsafeMutableRawPointer, GtkDeleteType, Int, UnsafeMutableRawPointer) ->
                Void =
                { _, value1, value2, data in
                    SignalBox2<GtkDeleteType, Int>.run(data, value1, value2)
                }

        addSignal(name: "delete-from-cursor", handler: gCallback(handler4)) {
            [weak self] (param0: GtkDeleteType, param1: Int) in
            guard let self = self else { return }
            self.deleteFromCursor?(self, param0, param1)
        }

        let handler5:
            @convention(c) (
                UnsafeMutableRawPointer, GtkEntryIconPosition, GdkEvent, UnsafeMutableRawPointer
            ) -> Void =
                { _, value1, value2, data in
                    SignalBox2<GtkEntryIconPosition, GdkEvent>.run(data, value1, value2)
                }

        addSignal(name: "icon-press", handler: gCallback(handler5)) {
            [weak self] (param0: GtkEntryIconPosition, param1: GdkEvent) in
            guard let self = self else { return }
            self.iconPress?(self, param0, param1)
        }

        let handler6:
            @convention(c) (
                UnsafeMutableRawPointer, GtkEntryIconPosition, GdkEvent, UnsafeMutableRawPointer
            ) -> Void =
                { _, value1, value2, data in
                    SignalBox2<GtkEntryIconPosition, GdkEvent>.run(data, value1, value2)
                }

        addSignal(name: "icon-release", handler: gCallback(handler6)) {
            [weak self] (param0: GtkEntryIconPosition, param1: GdkEvent) in
            guard let self = self else { return }
            self.iconRelease?(self, param0, param1)
        }

        let handler7:
            @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CChar>, UnsafeMutableRawPointer)
                -> Void =
                { _, value1, data in
                    SignalBox1<UnsafePointer<CChar>>.run(data, value1)
                }

        addSignal(name: "insert-at-cursor", handler: gCallback(handler7)) {
            [weak self] (param0: UnsafePointer<CChar>) in
            guard let self = self else { return }
            self.insertAtCursor?(self, param0)
        }

        addSignal(name: "insert-emoji") { [weak self] () in
            guard let self = self else { return }
            self.insertEmoji?(self)
        }

        let handler9:
            @convention(c) (
                UnsafeMutableRawPointer, GtkMovementStep, Int, Bool, UnsafeMutableRawPointer
            ) -> Void =
                { _, value1, value2, value3, data in
                    SignalBox3<GtkMovementStep, Int, Bool>.run(data, value1, value2, value3)
                }

        addSignal(name: "move-cursor", handler: gCallback(handler9)) {
            [weak self] (param0: GtkMovementStep, param1: Int, param2: Bool) in
            guard let self = self else { return }
            self.moveCursor?(self, param0, param1, param2)
        }

        addSignal(name: "paste-clipboard") { [weak self] () in
            guard let self = self else { return }
            self.pasteClipboard?(self)
        }

        let handler11:
            @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CChar>, UnsafeMutableRawPointer)
                -> Void =
                { _, value1, data in
                    SignalBox1<UnsafePointer<CChar>>.run(data, value1)
                }

        addSignal(name: "preedit-changed", handler: gCallback(handler11)) {
            [weak self] (param0: UnsafePointer<CChar>) in
            guard let self = self else { return }
            self.preeditChanged?(self, param0)
        }

        addSignal(name: "toggle-overwrite") { [weak self] () in
            guard let self = self else { return }
            self.toggleOverwrite?(self)
        }

        addSignal(name: "editing-done") { [weak self] () in
            guard let self = self else { return }
            self.editingDone?(self)
        }

        addSignal(name: "remove-widget") { [weak self] () in
            guard let self = self else { return }
            self.removeWidget?(self)
        }

        addSignal(name: "changed") { [weak self] () in
            guard let self = self else { return }
            self.changed?(self)
        }

        let handler16:
            @convention(c) (UnsafeMutableRawPointer, Int, Int, UnsafeMutableRawPointer) -> Void =
                { _, value1, value2, data in
                    SignalBox2<Int, Int>.run(data, value1, value2)
                }

        addSignal(name: "delete-text", handler: gCallback(handler16)) {
            [weak self] (param0: Int, param1: Int) in
            guard let self = self else { return }
            self.deleteText?(self, param0, param1)
        }

        let handler17:
            @convention(c) (
                UnsafeMutableRawPointer, UnsafePointer<CChar>, Int, gpointer,
                UnsafeMutableRawPointer
            ) -> Void =
                { _, value1, value2, value3, data in
                    SignalBox3<UnsafePointer<CChar>, Int, gpointer>.run(
                        data, value1, value2, value3)
                }

        addSignal(name: "insert-text", handler: gCallback(handler17)) {
            [weak self] (param0: UnsafePointer<CChar>, param1: Int, param2: gpointer) in
            guard let self = self else { return }
            self.insertText?(self, param0, param1, param2)
        }

        let handler18:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::activates-default", handler: gCallback(handler18)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyActivatesDefault?(self, param0)
        }

        let handler19:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::attributes", handler: gCallback(handler19)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyAttributes?(self, param0)
        }

        let handler20:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::buffer", handler: gCallback(handler20)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyBuffer?(self, param0)
        }

        let handler21:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::caps-lock-warning", handler: gCallback(handler21)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyCapsLockWarning?(self, param0)
        }

        let handler22:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::completion", handler: gCallback(handler22)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyCompletion?(self, param0)
        }

        let handler23:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::cursor-position", handler: gCallback(handler23)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyCursorPosition?(self, param0)
        }

        let handler24:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::editable", handler: gCallback(handler24)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyEditable?(self, param0)
        }

        let handler25:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::enable-emoji-completion", handler: gCallback(handler25)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyEnableEmojiCompletion?(self, param0)
        }

        let handler26:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::has-frame", handler: gCallback(handler26)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyHasFrame?(self, param0)
        }

        let handler27:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::im-module", handler: gCallback(handler27)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyImModule?(self, param0)
        }

        let handler28:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::inner-border", handler: gCallback(handler28)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyInnerBorder?(self, param0)
        }

        let handler29:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::input-hints", handler: gCallback(handler29)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyInputHints?(self, param0)
        }

        let handler30:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::input-purpose", handler: gCallback(handler30)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyInputPurpose?(self, param0)
        }

        let handler31:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::invisible-char", handler: gCallback(handler31)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyInvisibleCharacter?(self, param0)
        }

        let handler32:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::invisible-char-set", handler: gCallback(handler32)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyInvisibleCharacterSet?(self, param0)
        }

        let handler33:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::max-length", handler: gCallback(handler33)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyMaxLength?(self, param0)
        }

        let handler34:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::max-width-chars", handler: gCallback(handler34)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyMaxWidthChars?(self, param0)
        }

        let handler35:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::overwrite-mode", handler: gCallback(handler35)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyOverwriteMode?(self, param0)
        }

        let handler36:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::placeholder-text", handler: gCallback(handler36)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPlaceholderText?(self, param0)
        }

        let handler37:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::populate-all", handler: gCallback(handler37)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPopulateAll?(self, param0)
        }

        let handler38:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-activatable", handler: gCallback(handler38)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconActivatable?(self, param0)
        }

        let handler39:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-gicon", handler: gCallback(handler39)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconGicon?(self, param0)
        }

        let handler40:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-name", handler: gCallback(handler40)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconName?(self, param0)
        }

        let handler41:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-pixbuf", handler: gCallback(handler41)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconPixbuf?(self, param0)
        }

        let handler42:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-sensitive", handler: gCallback(handler42)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconSensitive?(self, param0)
        }

        let handler43:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-stock", handler: gCallback(handler43)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconStock?(self, param0)
        }

        let handler44:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-storage-type", handler: gCallback(handler44)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconStorageType?(self, param0)
        }

        let handler45:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-tooltip-markup", handler: gCallback(handler45)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconTooltipMarkup?(self, param0)
        }

        let handler46:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-tooltip-text", handler: gCallback(handler46)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconTooltipText?(self, param0)
        }

        let handler47:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::progress-fraction", handler: gCallback(handler47)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyProgressFraction?(self, param0)
        }

        let handler48:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::progress-pulse-step", handler: gCallback(handler48)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyProgressPulseStep?(self, param0)
        }

        let handler49:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::scroll-offset", handler: gCallback(handler49)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyScrollOffset?(self, param0)
        }

        let handler50:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-activatable", handler: gCallback(handler50)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconActivatable?(self, param0)
        }

        let handler51:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-gicon", handler: gCallback(handler51)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconGicon?(self, param0)
        }

        let handler52:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-name", handler: gCallback(handler52)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconName?(self, param0)
        }

        let handler53:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-pixbuf", handler: gCallback(handler53)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconPixbuf?(self, param0)
        }

        let handler54:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-sensitive", handler: gCallback(handler54)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconSensitive?(self, param0)
        }

        let handler55:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-stock", handler: gCallback(handler55)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconStock?(self, param0)
        }

        let handler56:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-storage-type", handler: gCallback(handler56)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconStorageType?(self, param0)
        }

        let handler57:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-tooltip-markup", handler: gCallback(handler57)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconTooltipMarkup?(self, param0)
        }

        let handler58:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-tooltip-text", handler: gCallback(handler58)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconTooltipText?(self, param0)
        }

        let handler59:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::selection-bound", handler: gCallback(handler59)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifySelectionBound?(self, param0)
        }

        let handler60:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::shadow-type", handler: gCallback(handler60)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyShadowType?(self, param0)
        }

        let handler61:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::show-emoji-icon", handler: gCallback(handler61)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyShowEmojiIcon?(self, param0)
        }

        let handler62:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::tabs", handler: gCallback(handler62)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyTabs?(self, param0)
        }

        let handler63:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::text", handler: gCallback(handler63)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyText?(self, param0)
        }

        let handler64:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::text-length", handler: gCallback(handler64)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyTextLength?(self, param0)
        }

        let handler65:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::truncate-multiline", handler: gCallback(handler65)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyTruncateMultiline?(self, param0)
        }

        let handler66:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::visibility", handler: gCallback(handler66)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyVisibility?(self, param0)
        }

        let handler67:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::width-chars", handler: gCallback(handler67)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyWidthChars?(self, param0)
        }

        let handler68:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::xalign", handler: gCallback(handler68)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyXalign?(self, param0)
        }

        let handler69:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::editing-canceled", handler: gCallback(handler69)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyEditingCanceled?(self, param0)
        }
    }

    @GObjectProperty(named: "activates-default") public var activatesDefault: Bool

    @GObjectProperty(named: "has-frame") public var hasFrame: Bool

    @GObjectProperty(named: "max-length") public var maxLength: Int

    /// The text that will be displayed in the #GtkEntry when it is empty
    /// and unfocused.
    @GObjectProperty(named: "placeholder-text") public var placeholderText: String

    @GObjectProperty(named: "text") public var text: String

    @GObjectProperty(named: "visibility") public var visibility: Bool

    @GObjectProperty(named: "width-chars") public var widthChars: Int

    /// The ::activate signal is emitted when the user hits
    /// the Enter key.
    ///
    /// While this signal is used as a
    /// [keybinding signal][GtkBindingSignal],
    /// it is also commonly used by applications to intercept
    /// activation of entries.
    ///
    /// The default bindings for this signal are all forms of the Enter key.
    public var activate: ((Entry) -> Void)?

    /// The ::backspace signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted when the user asks for it.
    ///
    /// The default bindings for this signal are
    /// Backspace and Shift-Backspace.
    public var backspace: ((Entry) -> Void)?

    /// The ::copy-clipboard signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted to copy the selection to the clipboard.
    ///
    /// The default bindings for this signal are
    /// Ctrl-c and Ctrl-Insert.
    public var copyClipboard: ((Entry) -> Void)?

    /// The ::cut-clipboard signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted to cut the selection to the clipboard.
    ///
    /// The default bindings for this signal are
    /// Ctrl-x and Shift-Delete.
    public var cutClipboard: ((Entry) -> Void)?

    /// The ::delete-from-cursor signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted when the user initiates a text deletion.
    ///
    /// If the @type is %GTK_DELETE_CHARS, GTK+ deletes the selection
    /// if there is one, otherwise it deletes the requested number
    /// of characters.
    ///
    /// The default bindings for this signal are
    /// Delete for deleting a character and Ctrl-Delete for
    /// deleting a word.
    public var deleteFromCursor: ((Entry, GtkDeleteType, Int) -> Void)?

    /// The ::icon-press signal is emitted when an activatable icon
    /// is clicked.
    public var iconPress: ((Entry, GtkEntryIconPosition, GdkEvent) -> Void)?

    /// The ::icon-release signal is emitted on the button release from a
    /// mouse click over an activatable icon.
    public var iconRelease: ((Entry, GtkEntryIconPosition, GdkEvent) -> Void)?

    /// The ::insert-at-cursor signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted when the user initiates the insertion of a
    /// fixed string at the cursor.
    ///
    /// This signal has no default bindings.
    public var insertAtCursor: ((Entry, UnsafePointer<CChar>) -> Void)?

    /// The ::insert-emoji signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted to present the Emoji chooser for the @entry.
    ///
    /// The default bindings for this signal are Ctrl-. and Ctrl-;
    public var insertEmoji: ((Entry) -> Void)?

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
    public var moveCursor: ((Entry, GtkMovementStep, Int, Bool) -> Void)?

    /// The ::paste-clipboard signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted to paste the contents of the clipboard
    /// into the text view.
    ///
    /// The default bindings for this signal are
    /// Ctrl-v and Shift-Insert.
    public var pasteClipboard: ((Entry) -> Void)?

    /// If an input method is used, the typed text will not immediately
    /// be committed to the buffer. So if you are interested in the text,
    /// connect to this signal.
    public var preeditChanged: ((Entry, UnsafePointer<CChar>) -> Void)?

    /// The ::toggle-overwrite signal is a
    /// [keybinding signal][GtkBindingSignal]
    /// which gets emitted to toggle the overwrite mode of the entry.
    ///
    /// The default bindings for this signal is Insert.
    public var toggleOverwrite: ((Entry) -> Void)?

    /// This signal is a sign for the cell renderer to update its
    /// value from the @cell_editable.
    ///
    /// Implementations of #GtkCellEditable are responsible for
    /// emitting this signal when they are done editing, e.g.
    /// #GtkEntry emits this signal when the user presses Enter. Typical things to
    /// do in a handler for ::editing-done are to capture the edited value,
    /// disconnect the @cell_editable from signals on the #GtkCellRenderer, etc.
    ///
    /// gtk_cell_editable_editing_done() is a convenience method
    /// for emitting #GtkCellEditable::editing-done.
    public var editingDone: ((Entry) -> Void)?

    /// This signal is meant to indicate that the cell is finished
    /// editing, and the @cell_editable widget is being removed and may
    /// subsequently be destroyed.
    ///
    /// Implementations of #GtkCellEditable are responsible for
    /// emitting this signal when they are done editing. It must
    /// be emitted after the #GtkCellEditable::editing-done signal,
    /// to give the cell renderer a chance to update the cell's value
    /// before the widget is removed.
    ///
    /// gtk_cell_editable_remove_widget() is a convenience method
    /// for emitting #GtkCellEditable::remove-widget.
    public var removeWidget: ((Entry) -> Void)?

    /// The ::changed signal is emitted at the end of a single
    /// user-visible operation on the contents of the #GtkEditable.
    ///
    /// E.g., a paste operation that replaces the contents of the
    /// selection will cause only one signal emission (even though it
    /// is implemented by first deleting the selection, then inserting
    /// the new content, and may cause multiple ::notify::text signals
    /// to be emitted).
    public var changed: ((Entry) -> Void)?

    /// This signal is emitted when text is deleted from
    /// the widget by the user. The default handler for
    /// this signal will normally be responsible for deleting
    /// the text, so by connecting to this signal and then
    /// stopping the signal with g_signal_stop_emission(), it
    /// is possible to modify the range of deleted text, or
    /// prevent it from being deleted entirely. The @start_pos
    /// and @end_pos parameters are interpreted as for
    /// gtk_editable_delete_text().
    public var deleteText: ((Entry, Int, Int) -> Void)?

    /// This signal is emitted when text is inserted into
    /// the widget by the user. The default handler for
    /// this signal will normally be responsible for inserting
    /// the text, so by connecting to this signal and then
    /// stopping the signal with g_signal_stop_emission(), it
    /// is possible to modify the inserted text, or prevent
    /// it from being inserted entirely.
    public var insertText: ((Entry, UnsafePointer<CChar>, Int, gpointer) -> Void)?

    public var notifyActivatesDefault: ((Entry, OpaquePointer) -> Void)?

    public var notifyAttributes: ((Entry, OpaquePointer) -> Void)?

    public var notifyBuffer: ((Entry, OpaquePointer) -> Void)?

    public var notifyCapsLockWarning: ((Entry, OpaquePointer) -> Void)?

    public var notifyCompletion: ((Entry, OpaquePointer) -> Void)?

    public var notifyCursorPosition: ((Entry, OpaquePointer) -> Void)?

    public var notifyEditable: ((Entry, OpaquePointer) -> Void)?

    public var notifyEnableEmojiCompletion: ((Entry, OpaquePointer) -> Void)?

    public var notifyHasFrame: ((Entry, OpaquePointer) -> Void)?

    public var notifyImModule: ((Entry, OpaquePointer) -> Void)?

    public var notifyInnerBorder: ((Entry, OpaquePointer) -> Void)?

    public var notifyInputHints: ((Entry, OpaquePointer) -> Void)?

    public var notifyInputPurpose: ((Entry, OpaquePointer) -> Void)?

    public var notifyInvisibleCharacter: ((Entry, OpaquePointer) -> Void)?

    public var notifyInvisibleCharacterSet: ((Entry, OpaquePointer) -> Void)?

    public var notifyMaxLength: ((Entry, OpaquePointer) -> Void)?

    public var notifyMaxWidthChars: ((Entry, OpaquePointer) -> Void)?

    public var notifyOverwriteMode: ((Entry, OpaquePointer) -> Void)?

    public var notifyPlaceholderText: ((Entry, OpaquePointer) -> Void)?

    public var notifyPopulateAll: ((Entry, OpaquePointer) -> Void)?

    public var notifyPrimaryIconActivatable: ((Entry, OpaquePointer) -> Void)?

    public var notifyPrimaryIconGicon: ((Entry, OpaquePointer) -> Void)?

    public var notifyPrimaryIconName: ((Entry, OpaquePointer) -> Void)?

    public var notifyPrimaryIconPixbuf: ((Entry, OpaquePointer) -> Void)?

    public var notifyPrimaryIconSensitive: ((Entry, OpaquePointer) -> Void)?

    public var notifyPrimaryIconStock: ((Entry, OpaquePointer) -> Void)?

    public var notifyPrimaryIconStorageType: ((Entry, OpaquePointer) -> Void)?

    public var notifyPrimaryIconTooltipMarkup: ((Entry, OpaquePointer) -> Void)?

    public var notifyPrimaryIconTooltipText: ((Entry, OpaquePointer) -> Void)?

    public var notifyProgressFraction: ((Entry, OpaquePointer) -> Void)?

    public var notifyProgressPulseStep: ((Entry, OpaquePointer) -> Void)?

    public var notifyScrollOffset: ((Entry, OpaquePointer) -> Void)?

    public var notifySecondaryIconActivatable: ((Entry, OpaquePointer) -> Void)?

    public var notifySecondaryIconGicon: ((Entry, OpaquePointer) -> Void)?

    public var notifySecondaryIconName: ((Entry, OpaquePointer) -> Void)?

    public var notifySecondaryIconPixbuf: ((Entry, OpaquePointer) -> Void)?

    public var notifySecondaryIconSensitive: ((Entry, OpaquePointer) -> Void)?

    public var notifySecondaryIconStock: ((Entry, OpaquePointer) -> Void)?

    public var notifySecondaryIconStorageType: ((Entry, OpaquePointer) -> Void)?

    public var notifySecondaryIconTooltipMarkup: ((Entry, OpaquePointer) -> Void)?

    public var notifySecondaryIconTooltipText: ((Entry, OpaquePointer) -> Void)?

    public var notifySelectionBound: ((Entry, OpaquePointer) -> Void)?

    public var notifyShadowType: ((Entry, OpaquePointer) -> Void)?

    public var notifyShowEmojiIcon: ((Entry, OpaquePointer) -> Void)?

    public var notifyTabs: ((Entry, OpaquePointer) -> Void)?

    public var notifyText: ((Entry, OpaquePointer) -> Void)?

    public var notifyTextLength: ((Entry, OpaquePointer) -> Void)?

    public var notifyTruncateMultiline: ((Entry, OpaquePointer) -> Void)?

    public var notifyVisibility: ((Entry, OpaquePointer) -> Void)?

    public var notifyWidthChars: ((Entry, OpaquePointer) -> Void)?

    public var notifyXalign: ((Entry, OpaquePointer) -> Void)?

    public var notifyEditingCanceled: ((Entry, OpaquePointer) -> Void)?
}
