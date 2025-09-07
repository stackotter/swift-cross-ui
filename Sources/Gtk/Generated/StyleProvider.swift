import CGtk

/// An interface for style information used by [class@Gtk.StyleContext].
///
/// See [method@Gtk.StyleContext.add_provider] and
/// [func@Gtk.StyleContext.add_provider_for_display] for
/// adding `GtkStyleProviders`.
///
/// GTK uses the `GtkStyleProvider` implementation for CSS in
/// [class@Gtk.CssProvider].
public protocol StyleProvider: GObjectRepresentable {

    var gtkPrivateChanged: ((Self) -> Void)? { get set }
}
