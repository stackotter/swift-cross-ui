import CGtk3

/// The #GtkEditable interface is an interface which should be implemented by
/// text editing widgets, such as #GtkEntry and #GtkSpinButton. It contains functions
/// for generically manipulating an editable widget, a large number of action
/// signals used for key bindings, and several signals that an application can
/// connect to to modify the behavior of a widget.
///
/// As an example of the latter usage, by connecting
/// the following handler to #GtkEditable::insert-text, an application
/// can convert all entry into a widget into uppercase.
///
/// ## Forcing entry to uppercase.
///
/// |[<!-- language="C" -->
/// #include <ctype.h>;
///
/// void
/// insert_text_handler (GtkEditable *editable,
/// const gchar *text,
/// gint         length,
/// gint        *position,
/// gpointer     data)
/// {
/// gchar *result = g_utf8_strup (text, length);
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
/// ]|
public protocol Editable: GObjectRepresentable {

    /// The ::changed signal is emitted at the end of a single
    /// user-visible operation on the contents of the #GtkEditable.
    ///
    /// E.g., a paste operation that replaces the contents of the
    /// selection will cause only one signal emission (even though it
    /// is implemented by first deleting the selection, then inserting
    /// the new content, and may cause multiple ::notify::text signals
    /// to be emitted).
    var changed: ((Self) -> Void)? { get set }

    /// This signal is emitted when text is deleted from
    /// the widget by the user. The default handler for
    /// this signal will normally be responsible for deleting
    /// the text, so by connecting to this signal and then
    /// stopping the signal with g_signal_stop_emission(), it
    /// is possible to modify the range of deleted text, or
    /// prevent it from being deleted entirely. The @start_pos
    /// and @end_pos parameters are interpreted as for
    /// gtk_editable_delete_text().
    var deleteText: ((Self, Int, Int) -> Void)? { get set }

    /// This signal is emitted when text is inserted into
    /// the widget by the user. The default handler for
    /// this signal will normally be responsible for inserting
    /// the text, so by connecting to this signal and then
    /// stopping the signal with g_signal_stop_emission(), it
    /// is possible to modify the inserted text, or prevent
    /// it from being inserted entirely.
    var insertText: ((Self, UnsafePointer<CChar>, Int, gpointer) -> Void)? { get set }
}
