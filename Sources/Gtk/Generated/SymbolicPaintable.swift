import CGtk

/// `GtkSymbolicPaintable` is an interface that support symbolic colors in
/// paintables.
///
/// `GdkPaintable`s implementing the interface will have the
/// [vfunc@Gtk.SymbolicPaintable.snapshot_symbolic] function called and
/// have the colors for drawing symbolic icons passed. At least 4 colors are guaranteed
/// to be passed every time.
///
/// These 4 colors are the foreground color, and the colors to use for errors, warnings
/// and success information in that order.
///
/// More colors may be added in the future.
public protocol SymbolicPaintable: GObjectRepresentable {

}
