import CGtk

/// An interface for describing UI elements for Assistive Technologies.
///
/// Every accessible implementation has:
///
/// - a “role”, represented by a value of the [enum@Gtk.AccessibleRole] enumeration
/// - “attributes”, represented by a set of [enum@Gtk.AccessibleState],
/// [enum@Gtk.AccessibleProperty] and [enum@Gtk.AccessibleRelation] values
///
/// The role cannot be changed after instantiating a `GtkAccessible`
/// implementation.
///
/// The attributes are updated every time a UI element's state changes in
/// a way that should be reflected by assistive technologies. For instance,
/// if a `GtkWidget` visibility changes, the %GTK_ACCESSIBLE_STATE_HIDDEN
/// state will also change to reflect the [property@Gtk.Widget:visible] property.
///
/// Every accessible implementation is part of a tree of accessible objects.
/// Normally, this tree corresponds to the widget tree, but can be customized
/// by reimplementing the [vfunc@Gtk.Accessible.get_accessible_parent],
/// [vfunc@Gtk.Accessible.get_first_accessible_child] and
/// [vfunc@Gtk.Accessible.get_next_accessible_sibling] virtual functions.
///
/// Note that you can not create a top-level accessible object as of now,
/// which means that you must always have a parent accessible object.
///
/// Also note that when an accessible object does not correspond to a widget,
/// and it has children, whose implementation you don't control,
/// it is necessary to ensure the correct shape of the a11y tree
/// by calling [method@Gtk.Accessible.set_accessible_parent] and
/// updating the sibling by [method@Gtk.Accessible.update_next_accessible_sibling].
public protocol Accessible: GObjectRepresentable {
    /// The accessible role of the given `GtkAccessible` implementation.
    ///
    /// The accessible role cannot be changed once set.
    var accessibleRole: AccessibleRole { get set }

}
