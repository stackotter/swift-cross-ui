import CGtk

/// An interface for widgets that can act as the root of a widget hierarchy.
///
/// The root widget takes care of providing the connection to the windowing
/// system and manages layout, drawing and event delivery for its widget
/// hierarchy.
///
/// The obvious example of a `GtkRoot` is `GtkWindow`.
///
/// To get the display to which a `GtkRoot` belongs, use
/// [method@Gtk.Root.get_display].
///
/// `GtkRoot` also maintains the location of keyboard focus inside its widget
/// hierarchy, with [method@Gtk.Root.set_focus] and [method@Gtk.Root.get_focus].
public protocol Root: GObjectRepresentable {

}
