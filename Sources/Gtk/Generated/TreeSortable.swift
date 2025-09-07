import CGtk

/// The interface for sortable models used by GtkTreeView
///
/// `GtkTreeSortable` is an interface to be implemented by tree models which
/// support sorting. The `GtkTreeView` uses the methods provided by this interface
/// to sort the model.
public protocol TreeSortable: GObjectRepresentable {

    /// The ::sort-column-changed signal is emitted when the sort column
    /// or sort order of @sortable is changed. The signal is emitted before
    /// the contents of @sortable are resorted.
    var sortColumnChanged: ((Self) -> Void)? { get set }
}
