import CGtk3

/// A #GtkWindow can be one of these types. Most things you’d consider a
/// “window” should have type #GTK_WINDOW_TOPLEVEL; windows with this type
/// are managed by the window manager and have a frame by default (call
/// gtk_window_set_decorated() to toggle the frame).  Windows with type
/// #GTK_WINDOW_POPUP are ignored by the window manager; window manager
/// keybindings won’t work on them, the window manager won’t decorate the
/// window with a frame, many GTK+ features that rely on the window
/// manager will not work (e.g. resize grips and
/// maximization/minimization). #GTK_WINDOW_POPUP is used to implement
/// widgets such as #GtkMenu or tooltips that you normally don’t think of
/// as windows per se. Nearly all windows should be #GTK_WINDOW_TOPLEVEL.
/// In particular, do not use #GTK_WINDOW_POPUP just to turn off
/// the window borders; use gtk_window_set_decorated() for that.
public enum WindowType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkWindowType

    /// A regular window, such as a dialog.
    case toplevel
    /// A special window such as a tooltip.
    case popup

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkWindowType) {
        switch gtkEnum {
            case GTK_WINDOW_TOPLEVEL:
                self = .toplevel
            case GTK_WINDOW_POPUP:
                self = .popup
            default:
                fatalError("Unsupported GtkWindowType enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkWindowType {
        switch self {
            case .toplevel:
                return GTK_WINDOW_TOPLEVEL
            case .popup:
                return GTK_WINDOW_POPUP
        }
    }
}
