import CGtk

/// An interface for widgets that have their own [class@Gdk.Surface].
/// 
/// The obvious example of a `GtkNative` is `GtkWindow`.
/// 
/// Every widget that is not itself a `GtkNative` is contained in one,
/// and you can get it with [method@Gtk.Widget.get_native].
/// 
/// To get the surface of a `GtkNative`, use [method@Gtk.Native.get_surface].
/// It is also possible to find the `GtkNative` to which a surface
/// belongs, with [func@Gtk.Native.get_for_surface].
/// 
/// In addition to a [class@Gdk.Surface], a `GtkNative` also provides
/// a [class@Gsk.Renderer] for rendering on that surface. To get the
/// renderer, use [method@Gtk.Native.get_renderer].
public protocol Native: GObjectRepresentable {
    

    
}