import CGtk

/// An interface for widgets with native scrolling ability.
///
/// To implement this interface you should override the
/// [property@Gtk.Scrollable:hadjustment] and
/// [property@Gtk.Scrollable:vadjustment] properties.
///
/// ## Creating a scrollable widget
///
/// All scrollable widgets should do the following.
///
/// - When a parent widget sets the scrollable child widget’s adjustments,
/// the widget should connect to the [signal@Gtk.Adjustment::value-changed]
/// signal. The child widget should then populate the adjustments’ properties
/// as soon as possible, which usually means queueing an allocation right away
/// and populating the properties in the [vfunc@Gtk.Widget.size_allocate]
/// implementation.
///
/// - Because its preferred size is the size for a fully expanded widget,
/// the scrollable widget must be able to cope with underallocations.
/// This means that it must accept any value passed to its
/// [vfunc@Gtk.Widget.size_allocate] implementation.
///
/// - When the parent allocates space to the scrollable child widget,
/// the widget must ensure the adjustments’ property values are correct and up
/// to date, for example using [method@Gtk.Adjustment.configure].
///
/// - When any of the adjustments emits the [signal@Gtk.Adjustment::value-changed]
/// signal, the scrollable widget should scroll its contents.
public protocol Scrollable: GObjectRepresentable {
    /// Determines when horizontal scrolling should start.
    var hscrollPolicy: ScrollablePolicy { get set }

    /// Determines when vertical scrolling should start.
    var vscrollPolicy: ScrollablePolicy { get set }

}
