import CGtk

/// The `GtkActionable` interface provides a convenient way of associating
/// widgets with actions.
///
/// It primarily consists of two properties: [property@Gtk.Actionable:action-name]
/// and [property@Gtk.Actionable:action-target]. There are also some convenience
/// APIs for setting these properties.
///
/// The action will be looked up in action groups that are found among
/// the widgets ancestors. Most commonly, these will be the actions with
/// the “win.” or “app.” prefix that are associated with the
/// `GtkApplicationWindow` or `GtkApplication`, but other action groups that
/// are added with [method@Gtk.Widget.insert_action_group] will be consulted
/// as well.
public protocol Actionable: GObjectRepresentable {
    /// The name of the action with which this widget should be associated.
    var actionName: String? { get set }

}
