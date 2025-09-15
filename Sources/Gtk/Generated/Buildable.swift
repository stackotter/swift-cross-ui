import CGtk

/// Allows objects to extend and customize deserialization from ui files.
/// 
/// The `GtkBuildable` interface includes methods for setting names and
/// properties of objects, parsing custom tags and constructing child objects.
/// 
/// It is implemented by all widgets and many of the non-widget objects that are
/// provided by GTK. The main user of this interface is [class@Gtk.Builder].
/// There should be very little need for applications to call any of these
/// functions directly.
/// 
/// An object only needs to implement this interface if it needs to extend the
/// `GtkBuilder` XML format or run any extra routines at deserialization time.
public protocol Buildable: GObjectRepresentable {
    

    
}