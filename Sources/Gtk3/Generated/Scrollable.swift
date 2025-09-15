import CGtk3

/// #GtkScrollable is an interface that is implemented by widgets with native
/// scrolling ability.
///
/// To implement this interface you should override the
/// #GtkScrollable:hadjustment and #GtkScrollable:vadjustment properties.
///
/// ## Creating a scrollable widget
///
/// All scrollable widgets should do the following.
///
/// - When a parent widget sets the scrollable child widget’s adjustments,
/// the widget should populate the adjustments’
/// #GtkAdjustment:lower, #GtkAdjustment:upper,
/// #GtkAdjustment:step-increment, #GtkAdjustment:page-increment and
/// #GtkAdjustment:page-size properties and connect to the
/// #GtkAdjustment::value-changed signal.
///
/// - Because its preferred size is the size for a fully expanded widget,
/// the scrollable widget must be able to cope with underallocations.
/// This means that it must accept any value passed to its
/// #GtkWidgetClass.size_allocate() function.
///
/// - When the parent allocates space to the scrollable child widget,
/// the widget should update the adjustments’ properties with new values.
///
/// - When any of the adjustments emits the #GtkAdjustment::value-changed signal,
/// the scrollable widget should scroll its contents.
public protocol Scrollable: GObjectRepresentable {

}
