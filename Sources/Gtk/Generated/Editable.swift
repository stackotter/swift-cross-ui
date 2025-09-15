import CGtk

/// Interface for single-line text editing widgets.
///
/// Typical examples of editable widgets are [class@Gtk.Entry] and
/// [class@Gtk.SpinButton]. It contains functions for generically manipulating
/// an editable widget, a large number of action signals used for key bindings,
/// and several signals that an application can connect to modify the behavior
/// of a widget.
///
/// As an example of the latter usage, by connecting the following handler to
/// [signal@Gtk.Editable::insert-text], an application can convert all entry
/// into a widget into uppercase.
///
/// ## Forcing entry to uppercase.
///
/// ```c
/// #include <ctype.h>
///
/// void
/// insert_text_handler (GtkEditable *editable,
/// const char  *text,
/// int          length,
/// int         *position,
/// gpointer     data)
/// {
/// char *result = g_utf8_strup (text, length);
///
/// g_signal_handlers_block_by_func (editable,
/// (gpointer) insert_text_handler, data);
/// gtk_editable_insert_text (editable, result, length, position);
/// g_signal_handlers_unblock_by_func (editable,
/// (gpointer) insert_text_handler, data);
///
/// g_signal_stop_emission_by_name (editable, "insert_text");
///
/// g_free (result);
/// }
/// ```
///
/// ## Implementing GtkEditable
///
/// The most likely scenario for implementing `GtkEditable` on your own widget
/// is that you will embed a `GtkText` inside a complex widget, and want to
/// delegate the editable functionality to that text widget. `GtkEditable`
/// provides some utility functions to make this easy.
///
/// In your class_init function, call [func@Gtk.Editable.install_properties],
/// passing the first available property ID:
///
/// ```c
/// static void
/// my_class_init (MyClass *class)
/// {
/// ...
/// g_object_class_install_properties (object_class, NUM_PROPERTIES, props);
/// gtk_editable_install_properties (object_clas, NUM_PROPERTIES);
/// ...
/// }
/// ```
///
/// In your interface_init function for the `GtkEditable` interface, provide
/// an implementation for the get_delegate vfunc that returns your text widget:
///
/// ```c
/// GtkEditable *
/// get_editable_delegate (GtkEditable *editable)
/// {
/// return GTK_EDITABLE (MY_WIDGET (editable)->text_widget);
/// }
///
/// static void
/// my_editable_init (GtkEditableInterface *iface)
/// {
/// iface->get_delegate = get_editable_delegate;
/// }
/// ```
///
/// You don't need to provide any other vfuncs. The default implementations
/// work by forwarding to the delegate that the GtkEditableInterface.get_delegate()
/// vfunc returns.
///
/// In your instance_init function, create your text widget, and then call
/// [method@Gtk.Editable.init_delegate]:
///
/// ```c
/// static void
/// my_widget_init (MyWidget *self)
/// {
/// ...
/// self->text_widget = gtk_text_new ();
/// gtk_editable_init_delegate (GTK_EDITABLE (self));
/// ...
/// }
/// ```
///
/// In your dispose function, call [method@Gtk.Editable.finish_delegate] before
/// destroying your text widget:
///
/// ```c
/// static void
/// my_widget_dispose (GObject *object)
/// {
/// ...
/// gtk_editable_finish_delegate (GTK_EDITABLE (self));
/// g_clear_pointer (&self->text_widget, gtk_widget_unparent);
/// ...
/// }
/// ```
///
/// Finally, use [func@Gtk.Editable.delegate_set_property] in your `set_property`
/// function (and similar for `get_property`), to set the editable properties:
///
/// ```c
/// ...
/// if (gtk_editable_delegate_set_property (object, prop_id, value, pspec))
/// return;
///
/// switch (prop_id)
/// ...
/// ```
///
/// It is important to note that if you create a `GtkEditable` that uses
/// a delegate, the low level [signal@Gtk.Editable::insert-text] and
/// [signal@Gtk.Editable::delete-text] signals will be propagated from the
/// "wrapper" editable to the delegate, but they will not be propagated from
/// the delegate to the "wrapper" editable, as they would cause an infinite
/// recursion. If you wish to connect to the [signal@Gtk.Editable::insert-text]
/// and [signal@Gtk.Editable::delete-text] signals, you will need to connect
/// to them on the delegate obtained via [method@Gtk.Editable.get_delegate].
public protocol Editable: GObjectRepresentable {
    /// The current position of the insertion cursor in chars.
    var cursorPosition: Int { get set }

    /// Whether the entry contents can be edited.
    var editable: Bool { get set }

    /// If undo/redo should be enabled for the editable.
    var enableUndo: Bool { get set }

    /// The desired maximum width of the entry, in characters.
    var maxWidthChars: Int { get set }

    /// The contents of the entry.
    var text: String { get set }

    /// Number of characters to leave space for in the entry.
    var widthChars: Int { get set }

    /// The horizontal alignment, from 0 (left) to 1 (right).
    ///
    /// Reversed for RTL layouts.
    var xalign: Float { get set }

    /// Emitted at the end of a single user-visible operation on the
    /// contents.
    ///
    /// E.g., a paste operation that replaces the contents of the
    /// selection will cause only one signal emission (even though it
    /// is implemented by first deleting the selection, then inserting
    /// the new content, and may cause multiple ::notify::text signals
    /// to be emitted).
    var changed: ((Self) -> Void)? { get set }

    /// Emitted when text is deleted from the widget by the user.
    ///
    /// The default handler for this signal will normally be responsible for
    /// deleting the text, so by connecting to this signal and then stopping
    /// the signal with g_signal_stop_emission(), it is possible to modify the
    /// range of deleted text, or prevent it from being deleted entirely.
    ///
    /// The @start_pos and @end_pos parameters are interpreted as for
    /// [method@Gtk.Editable.delete_text].
    var deleteText: ((Self, Int, Int) -> Void)? { get set }

    /// Emitted when text is inserted into the widget by the user.
    ///
    /// The default handler for this signal will normally be responsible
    /// for inserting the text, so by connecting to this signal and then
    /// stopping the signal with g_signal_stop_emission(), it is possible
    /// to modify the inserted text, or prevent it from being inserted entirely.
    var insertText: ((Self, UnsafePointer<CChar>, Int, gpointer) -> Void)? { get set }
}
