import CGtk

/// Provides language binding support to `GtkBuilder`.
///
/// The goal of `GtkBuilderScope` is to look up programming-language-specific
/// values for strings that are given in a `GtkBuilder` UI file.
///
/// The primary intended audience is bindings that want to provide deeper
/// integration of `GtkBuilder` into the language.
///
/// A `GtkBuilderScope` instance may be used with multiple `GtkBuilder` objects,
/// even at once.
///
/// By default, GTK will use its own implementation of `GtkBuilderScope`
/// for the C language which can be created via [ctor@Gtk.BuilderCScope.new].
///
/// If you implement `GtkBuilderScope` for a language binding, you
/// may want to (partially) derive from or fall back to a [class@Gtk.BuilderCScope],
/// as that class implements support for automatic lookups from C symbols.
public protocol BuilderScope: GObjectRepresentable {

}
