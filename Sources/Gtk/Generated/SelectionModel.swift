import CGtk

/// An interface that adds support for selection to list models.
///
/// This support is then used by widgets using list models to add the ability
/// to select and unselect various items.
///
/// GTK provides default implementations of the most common selection modes such
/// as [class@Gtk.SingleSelection], so you will only need to implement this
/// interface if you want detailed control about how selections should be handled.
///
/// A `GtkSelectionModel` supports a single boolean per item indicating if an item is
/// selected or not. This can be queried via [method@Gtk.SelectionModel.is_selected].
/// When the selected state of one or more items changes, the model will emit the
/// [signal@Gtk.SelectionModel::selection-changed] signal by calling the
/// [method@Gtk.SelectionModel.selection_changed] function. The positions given
/// in that signal may have their selection state changed, though that is not a
/// requirement. If new items added to the model via the
/// [signal@Gio.ListModel::items-changed] signal are selected or not is up to the
/// implementation.
///
/// Note that items added via [signal@Gio.ListModel::items-changed] may already
/// be selected and no [signal@Gtk.SelectionModel::selection-changed] will be
/// emitted for them. So to track which items are selected, it is necessary to
/// listen to both signals.
///
/// Additionally, the interface can expose functionality to select and unselect
/// items. If these functions are implemented, GTK's list widgets will allow users
/// to select and unselect items. However, `GtkSelectionModel`s are free to only
/// implement them partially or not at all. In that case the widgets will not
/// support the unimplemented operations.
///
/// When selecting or unselecting is supported by a model, the return values of
/// the selection functions do *not* indicate if selection or unselection happened.
/// They are only meant to indicate complete failure, like when this mode of
/// selecting is not supported by the model.
///
/// Selections may happen asynchronously, so the only reliable way to find out
/// when an item was selected is to listen to the signals that indicate selection.
public protocol SelectionModel: GObjectRepresentable {

    /// Emitted when the selection state of some of the items in @model changes.
    ///
    /// Note that this signal does not specify the new selection state of the
    /// items, they need to be queried manually. It is also not necessary for
    /// a model to change the selection state of any of the items in the selection
    /// model, though it would be rather useless to emit such a signal.
    var selectionChanged: ((Self, UInt, UInt) -> Void)? { get set }
}
