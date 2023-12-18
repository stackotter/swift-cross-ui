import CGtk

/// `GtkEntry` is a single line text entry widget.
///
/// ![An example GtkEntry](entry.png)
///
/// A fairly large set of key bindings are supported by default. If the
/// entered text is longer than the allocation of the widget, the widget
/// will scroll so that the cursor position is visible.
///
/// When using an entry for passwords and other sensitive information, it
/// can be put into “password mode” using [method@Gtk.Entry.set_visibility].
/// In this mode, entered text is displayed using a “invisible” character.
/// By default, GTK picks the best invisible character that is available
/// in the current font, but it can be changed with
/// [method@Gtk.Entry.set_invisible_char].
///
/// `GtkEntry` has the ability to display progress or activity
/// information behind the text. To make an entry display such information,
/// use [method@Gtk.Entry.set_progress_fraction] or
/// [method@Gtk.Entry.set_progress_pulse_step].
///
/// Additionally, `GtkEntry` can show icons at either side of the entry.
/// These icons can be activatable by clicking, can be set up as drag source
/// and can have tooltips. To add an icon, use
/// [method@Gtk.Entry.set_icon_from_gicon] or one of the various other functions
/// that set an icon from an icon name or a paintable. To trigger an action when
/// the user clicks an icon, connect to the [signal@Gtk.Entry::icon-press] signal.
/// To allow DND operations from an icon, use
/// [method@Gtk.Entry.set_icon_drag_source]. To set a tooltip on an icon, use
/// [method@Gtk.Entry.set_icon_tooltip_text] or the corresponding function
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
/// ```
/// entry[.flat][.warning][.error]
/// ├── text[.readonly]
/// ├── image.left
/// ├── image.right
/// ╰── [progress[.pulse]]
/// ```
///
/// `GtkEntry` has a main node with the name entry. Depending on the properties
/// of the entry, the style classes .read-only and .flat may appear. The style
/// classes .warning and .error may also be used with entries.
///
/// When the entry shows icons, it adds subnodes with the name image and the
/// style class .left or .right, depending on where the icon appears.
///
/// When the entry shows progress, it adds a subnode with the name progress.
/// The node has the style class .pulse when the shown progress is pulsing.
///
/// For all the subnodes added to the text node in various situations,
/// see [class@Gtk.Text].
///
/// # GtkEntry as GtkBuildable
///
/// The `GtkEntry` implementation of the `GtkBuildable` interface supports a
/// custom `<attributes>` element, which supports any number of `<attribute>`
/// elements. The `<attribute>` element has attributes named “name“, “value“,
/// “start“ and “end“ and allows you to specify `PangoAttribute` values for
/// this label.
///
/// An example of a UI definition fragment specifying Pango attributes:
/// ```xml
/// <object class="GtkEntry"><attributes><attribute name="weight" value="PANGO_WEIGHT_BOLD"/><attribute name="background" value="red" start="5" end="10"/></attributes></object>
/// ```
///
/// The start and end attributes specify the range of characters to which the
/// Pango attribute applies. If start and end are not specified, the attribute
/// is applied to the whole text. Note that specifying ranges does not make much
/// sense with translatable attributes. Use markup embedded in the translatable
/// content instead.
///
/// # Accessibility
///
/// `GtkEntry` uses the %GTK_ACCESSIBLE_ROLE_TEXT_BOX role.
public class Entry: Widget, CellEditable, Editable {
    /// Creates a new entry.
    override public init() {
        super.init()
        widgetPointer = gtk_entry_new()
    }

    /// Creates a new entry with the specified text buffer.
    public init(buffer: UnsafeMutablePointer<GtkEntryBuffer>!) {
        super.init()
        widgetPointer = gtk_entry_new_with_buffer(buffer)
    }

    override func didMoveToParent() {
        removeSignals()

        super.didMoveToParent()

        addSignal(name: "activate") { [weak self] () in
            guard let self = self else { return }
            self.activate?(self)
        }

        let handler1:
            @convention(c) (UnsafeMutableRawPointer, GtkEntryIconPosition, UnsafeMutableRawPointer)
                -> Void =
                { _, value1, data in
                    SignalBox1<GtkEntryIconPosition>.run(data, value1)
                }

        addSignal(name: "icon-press", handler: gCallback(handler1)) {
            [weak self] (_: GtkEntryIconPosition) in
            guard let self = self else { return }
            self.iconPress?(self)
        }

        let handler2:
            @convention(c) (UnsafeMutableRawPointer, GtkEntryIconPosition, UnsafeMutableRawPointer)
                -> Void =
                { _, value1, data in
                    SignalBox1<GtkEntryIconPosition>.run(data, value1)
                }

        addSignal(name: "icon-release", handler: gCallback(handler2)) {
            [weak self] (_: GtkEntryIconPosition) in
            guard let self = self else { return }
            self.iconRelease?(self)
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

        let handler6:
            @convention(c) (UnsafeMutableRawPointer, Int, Int, UnsafeMutableRawPointer) -> Void =
                { _, value1, value2, data in
                    SignalBox2<Int, Int>.run(data, value1, value2)
                }

        addSignal(name: "delete-text", handler: gCallback(handler6)) {
            [weak self] (_: Int, _: Int) in
            guard let self = self else { return }
            self.deleteText?(self)
        }

        let handler7:
            @convention(c) (
                UnsafeMutableRawPointer, UnsafePointer<CChar>, Int, gpointer,
                UnsafeMutableRawPointer
            ) -> Void =
                { _, value1, value2, value3, data in
                    SignalBox3<UnsafePointer<CChar>, Int, gpointer>.run(
                        data, value1, value2, value3)
                }

        addSignal(name: "insert-text", handler: gCallback(handler7)) {
            [weak self] (_: UnsafePointer<CChar>, _: Int, _: gpointer) in
            guard let self = self else { return }
            self.insertText?(self)
        }

        let handler8:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::activates-default", handler: gCallback(handler8)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyActivatesDefault?(self)
        }

        let handler9:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::attributes", handler: gCallback(handler9)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyAttributes?(self)
        }

        let handler10:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::buffer", handler: gCallback(handler10)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyBuffer?(self)
        }

        let handler11:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::completion", handler: gCallback(handler11)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyCompletion?(self)
        }

        let handler12:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::enable-emoji-completion", handler: gCallback(handler12)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyEnableEmojiCompletion?(self)
        }

        let handler13:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::extra-menu", handler: gCallback(handler13)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyExtraMenu?(self)
        }

        let handler14:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::has-frame", handler: gCallback(handler14)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyHasFrame?(self)
        }

        let handler15:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::im-module", handler: gCallback(handler15)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyImModule?(self)
        }

        let handler16:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::input-hints", handler: gCallback(handler16)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyInputHints?(self)
        }

        let handler17:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::input-purpose", handler: gCallback(handler17)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyInputPurpose?(self)
        }

        let handler18:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::invisible-char", handler: gCallback(handler18)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyInvisibleCharacter?(self)
        }

        let handler19:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::invisible-char-set", handler: gCallback(handler19)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyInvisibleCharacterSet?(self)
        }

        let handler20:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::max-length", handler: gCallback(handler20)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyMaxLength?(self)
        }

        let handler21:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::overwrite-mode", handler: gCallback(handler21)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyOverwriteMode?(self)
        }

        let handler22:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::placeholder-text", handler: gCallback(handler22)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPlaceholderText?(self)
        }

        let handler23:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-activatable", handler: gCallback(handler23)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconActivatable?(self)
        }

        let handler24:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-gicon", handler: gCallback(handler24)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconGicon?(self)
        }

        let handler25:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-name", handler: gCallback(handler25)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconName?(self)
        }

        let handler26:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-paintable", handler: gCallback(handler26)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconPaintable?(self)
        }

        let handler27:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-sensitive", handler: gCallback(handler27)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconSensitive?(self)
        }

        let handler28:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-storage-type", handler: gCallback(handler28)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconStorageType?(self)
        }

        let handler29:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-tooltip-markup", handler: gCallback(handler29)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconTooltipMarkup?(self)
        }

        let handler30:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::primary-icon-tooltip-text", handler: gCallback(handler30)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPrimaryIconTooltipText?(self)
        }

        let handler31:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::progress-fraction", handler: gCallback(handler31)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyProgressFraction?(self)
        }

        let handler32:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::progress-pulse-step", handler: gCallback(handler32)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyProgressPulseStep?(self)
        }

        let handler33:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::scroll-offset", handler: gCallback(handler33)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyScrollOffset?(self)
        }

        let handler34:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-activatable", handler: gCallback(handler34)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconActivatable?(self)
        }

        let handler35:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-gicon", handler: gCallback(handler35)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconGicon?(self)
        }

        let handler36:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-name", handler: gCallback(handler36)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconName?(self)
        }

        let handler37:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-paintable", handler: gCallback(handler37)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconPaintable?(self)
        }

        let handler38:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-sensitive", handler: gCallback(handler38)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconSensitive?(self)
        }

        let handler39:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-storage-type", handler: gCallback(handler39)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconStorageType?(self)
        }

        let handler40:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-tooltip-markup", handler: gCallback(handler40)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconTooltipMarkup?(self)
        }

        let handler41:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::secondary-icon-tooltip-text", handler: gCallback(handler41)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifySecondaryIconTooltipText?(self)
        }

        let handler42:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::show-emoji-icon", handler: gCallback(handler42)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyShowEmojiIcon?(self)
        }

        let handler43:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::tabs", handler: gCallback(handler43)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyTabs?(self)
        }

        let handler44:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::text-length", handler: gCallback(handler44)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyTextLength?(self)
        }

        let handler45:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::truncate-multiline", handler: gCallback(handler45)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyTruncateMultiline?(self)
        }

        let handler46:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::visibility", handler: gCallback(handler46)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyVisibility?(self)
        }

        let handler47:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::editing-canceled", handler: gCallback(handler47)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyEditingCanceled?(self)
        }

        let handler48:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::cursor-position", handler: gCallback(handler48)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyCursorPosition?(self)
        }

        let handler49:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::editable", handler: gCallback(handler49)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyEditable?(self)
        }

        let handler50:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::enable-undo", handler: gCallback(handler50)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyEnableUndo?(self)
        }

        let handler51:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::max-width-chars", handler: gCallback(handler51)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyMaxWidthChars?(self)
        }

        let handler52:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::selection-bound", handler: gCallback(handler52)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifySelectionBound?(self)
        }

        let handler53:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::text", handler: gCallback(handler53)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyText?(self)
        }

        let handler54:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::width-chars", handler: gCallback(handler54)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyWidthChars?(self)
        }

        let handler55:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::xalign", handler: gCallback(handler55)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyXalign?(self)
        }
    }

    /// Whether to activate the default widget when Enter is pressed.
    @GObjectProperty(named: "activates-default") public var activatesDefault: Bool

    /// Whether the entry should draw a frame.
    @GObjectProperty(named: "has-frame") public var hasFrame: Bool

    /// The purpose of this text field.
    ///
    /// This property can be used by on-screen keyboards and other input
    /// methods to adjust their behaviour.
    ///
    /// Note that setting the purpose to %GTK_INPUT_PURPOSE_PASSWORD or
    /// %GTK_INPUT_PURPOSE_PIN is independent from setting
    /// [property@Gtk.Entry:visibility].
    @GObjectProperty(named: "input-purpose") public var inputPurpose: InputPurpose

    /// The character to use when masking entry contents (“password mode”).
    @GObjectProperty(named: "invisible-char") public var invisibleCharacter: UInt

    /// Maximum number of characters for this entry.
    @GObjectProperty(named: "max-length") public var maxLength: Int

    /// If text is overwritten when typing in the `GtkEntry`.
    @GObjectProperty(named: "overwrite-mode") public var overwriteMode: Bool

    /// The text that will be displayed in the `GtkEntry` when it is empty
    /// and unfocused.
    @GObjectProperty(named: "placeholder-text") public var placeholderText: String?

    /// The current fraction of the task that's been completed.
    @GObjectProperty(named: "progress-fraction") public var progressFraction: Double

    /// The fraction of total entry width to move the progress
    /// bouncing block for each pulse.
    ///
    /// See [method@Gtk.Entry.progress_pulse].
    @GObjectProperty(named: "progress-pulse-step") public var progressPulseStep: Double

    /// The length of the text in the `GtkEntry`.
    @GObjectProperty(named: "text-length") public var textLength: UInt

    /// Whether the entry should show the “invisible char” instead of the
    /// actual text (“password mode”).
    @GObjectProperty(named: "visibility") public var visibility: Bool

    /// Whether the entry contents can be edited.
    @GObjectProperty(named: "editable") public var editable: Bool

    /// If undo/redo should be enabled for the editable.
    @GObjectProperty(named: "enable-undo") public var enableUndo: Bool

    /// The desired maximum width of the entry, in characters.
    @GObjectProperty(named: "max-width-chars") public var maxWidthChars: Int

    /// The contents of the entry.
    @GObjectProperty(named: "text") public var text: String

    /// Number of characters to leave space for in the entry.
    @GObjectProperty(named: "width-chars") public var widthChars: Int

    /// Emitted when the entry is activated.
    ///
    /// The keybindings for this signal are all forms of the Enter key.
    public var activate: ((Entry) -> Void)?

    /// Emitted when an activatable icon is clicked.
    public var iconPress: ((Entry) -> Void)?

    /// Emitted on the button release from a mouse click
    /// over an activatable icon.
    public var iconRelease: ((Entry) -> Void)?

    /// This signal is a sign for the cell renderer to update its
    /// value from the @cell_editable.
    ///
    /// Implementations of `GtkCellEditable` are responsible for
    /// emitting this signal when they are done editing, e.g.
    /// `GtkEntry` emits this signal when the user presses Enter. Typical things to
    /// do in a handler for ::editing-done are to capture the edited value,
    /// disconnect the @cell_editable from signals on the `GtkCellRenderer`, etc.
    ///
    /// gtk_cell_editable_editing_done() is a convenience method
    /// for emitting `GtkCellEditable::editing-done`.
    public var editingDone: ((Entry) -> Void)?

    /// This signal is meant to indicate that the cell is finished
    /// editing, and the @cell_editable widget is being removed and may
    /// subsequently be destroyed.
    ///
    /// Implementations of `GtkCellEditable` are responsible for
    /// emitting this signal when they are done editing. It must
    /// be emitted after the `GtkCellEditable::editing-done` signal,
    /// to give the cell renderer a chance to update the cell's value
    /// before the widget is removed.
    ///
    /// gtk_cell_editable_remove_widget() is a convenience method
    /// for emitting `GtkCellEditable::remove-widget`.
    public var removeWidget: ((Entry) -> Void)?

    /// Emitted at the end of a single user-visible operation on the
    /// contents.
    ///
    /// E.g., a paste operation that replaces the contents of the
    /// selection will cause only one signal emission (even though it
    /// is implemented by first deleting the selection, then inserting
    /// the new content, and may cause multiple ::notify::text signals
    /// to be emitted).
    public var changed: ((Entry) -> Void)?

    /// Emitted when text is deleted from the widget by the user.
    ///
    /// The default handler for this signal will normally be responsible for
    /// deleting the text, so by connecting to this signal and then stopping
    /// the signal with g_signal_stop_emission(), it is possible to modify the
    /// range of deleted text, or prevent it from being deleted entirely.
    ///
    /// The @start_pos and @end_pos parameters are interpreted as for
    /// [method@Gtk.Editable.delete_text].
    public var deleteText: ((Entry) -> Void)?

    /// Emitted when text is inserted into the widget by the user.
    ///
    /// The default handler for this signal will normally be responsible
    /// for inserting the text, so by connecting to this signal and then
    /// stopping the signal with g_signal_stop_emission(), it is possible
    /// to modify the inserted text, or prevent it from being inserted entirely.
    public var insertText: ((Entry) -> Void)?

    public var notifyActivatesDefault: ((Entry) -> Void)?

    public var notifyAttributes: ((Entry) -> Void)?

    public var notifyBuffer: ((Entry) -> Void)?

    public var notifyCompletion: ((Entry) -> Void)?

    public var notifyEnableEmojiCompletion: ((Entry) -> Void)?

    public var notifyExtraMenu: ((Entry) -> Void)?

    public var notifyHasFrame: ((Entry) -> Void)?

    public var notifyImModule: ((Entry) -> Void)?

    public var notifyInputHints: ((Entry) -> Void)?

    public var notifyInputPurpose: ((Entry) -> Void)?

    public var notifyInvisibleCharacter: ((Entry) -> Void)?

    public var notifyInvisibleCharacterSet: ((Entry) -> Void)?

    public var notifyMaxLength: ((Entry) -> Void)?

    public var notifyOverwriteMode: ((Entry) -> Void)?

    public var notifyPlaceholderText: ((Entry) -> Void)?

    public var notifyPrimaryIconActivatable: ((Entry) -> Void)?

    public var notifyPrimaryIconGicon: ((Entry) -> Void)?

    public var notifyPrimaryIconName: ((Entry) -> Void)?

    public var notifyPrimaryIconPaintable: ((Entry) -> Void)?

    public var notifyPrimaryIconSensitive: ((Entry) -> Void)?

    public var notifyPrimaryIconStorageType: ((Entry) -> Void)?

    public var notifyPrimaryIconTooltipMarkup: ((Entry) -> Void)?

    public var notifyPrimaryIconTooltipText: ((Entry) -> Void)?

    public var notifyProgressFraction: ((Entry) -> Void)?

    public var notifyProgressPulseStep: ((Entry) -> Void)?

    public var notifyScrollOffset: ((Entry) -> Void)?

    public var notifySecondaryIconActivatable: ((Entry) -> Void)?

    public var notifySecondaryIconGicon: ((Entry) -> Void)?

    public var notifySecondaryIconName: ((Entry) -> Void)?

    public var notifySecondaryIconPaintable: ((Entry) -> Void)?

    public var notifySecondaryIconSensitive: ((Entry) -> Void)?

    public var notifySecondaryIconStorageType: ((Entry) -> Void)?

    public var notifySecondaryIconTooltipMarkup: ((Entry) -> Void)?

    public var notifySecondaryIconTooltipText: ((Entry) -> Void)?

    public var notifyShowEmojiIcon: ((Entry) -> Void)?

    public var notifyTabs: ((Entry) -> Void)?

    public var notifyTextLength: ((Entry) -> Void)?

    public var notifyTruncateMultiline: ((Entry) -> Void)?

    public var notifyVisibility: ((Entry) -> Void)?

    public var notifyEditingCanceled: ((Entry) -> Void)?

    public var notifyCursorPosition: ((Entry) -> Void)?

    public var notifyEditable: ((Entry) -> Void)?

    public var notifyEnableUndo: ((Entry) -> Void)?

    public var notifyMaxWidthChars: ((Entry) -> Void)?

    public var notifySelectionBound: ((Entry) -> Void)?

    public var notifyText: ((Entry) -> Void)?

    public var notifyWidthChars: ((Entry) -> Void)?

    public var notifyXalign: ((Entry) -> Void)?
}
