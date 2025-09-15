import CGtk3

/// #GtkRecentChooser is an interface that can be implemented by widgets
/// displaying the list of recently used files.  In GTK+, the main objects
/// that implement this interface are #GtkRecentChooserWidget,
/// #GtkRecentChooserDialog and #GtkRecentChooserMenu.
///
/// Recently used files are supported since GTK+ 2.10.
public protocol RecentChooser: GObjectRepresentable {

    var showPrivate: Bool { get set }

    /// This signal is emitted when the user "activates" a recent item
    /// in the recent chooser.  This can happen by double-clicking on an item
    /// in the recently used resources list, or by pressing
    /// `Enter`.
    var itemActivated: ((Self) -> Void)? { get set }

    /// This signal is emitted when there is a change in the set of
    /// selected recently used resources.  This can happen when a user
    /// modifies the selection with the mouse or the keyboard, or when
    /// explicitly calling functions to change the selection.
    var selectionChanged: ((Self) -> Void)? { get set }
}
