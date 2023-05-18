import Gtk

#if canImport(FileDialog)
    import FileDialog

    public typealias GtkFileDialog = FileDialog
#else
    @available(*, unavailable, message: "File dialog requires Gtk 4.10")
    public class GtkFileDialog {
        public init() {}
    }
#endif

public typealias GtkBox = Gtk.Box
public typealias GtkStack = Gtk.Stack
public typealias GtkPaned = Gtk.Paned
public typealias GtkSingleChildBox = Gtk.SingleChildBox
public typealias GtkWidget = Gtk.Widget
public typealias GtkButton = Gtk.Button
public typealias GtkWindow = Gtk.Window
public typealias GtkLabel = Gtk.Label
public typealias GtkEntry = Gtk.Entry
public typealias GtkScale = Gtk.Scale
public typealias GtkImage = Gtk.Image
public typealias GtkViewport = Gtk.Viewport
public typealias GtkScrolledWindow = Gtk.ScrolledWindow

typealias GtkApplication = Gtk.Application
typealias GtkSize = Gtk.Size
typealias GtkOrientable = Gtk.Orientable
typealias GtkColor = Gtk.Color
typealias GtkAlign = Gtk.Align
