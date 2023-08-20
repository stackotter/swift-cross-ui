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

public typealias GtkApplication = Gtk.Application
public typealias GtkBox = Gtk.Box
public typealias GtkStack = Gtk.Stack
public typealias GtkPaned = Gtk.Paned
public typealias GtkModifierBox = Gtk.ModifierBox
public typealias GtkSectionBox = Gtk.SectionBox
public typealias GtkOrientable = Gtk.Orientable
public typealias GtkSize = Gtk.Size
public typealias GtkWidget = Gtk.Widget
public typealias GtkButton = Gtk.Button
public typealias GtkWindow = Gtk.Window
public typealias GtkLabel = Gtk.Label
public typealias GtkEntry = Gtk.Entry
public typealias GtkScale = Gtk.Scale
public typealias GtkImage = Gtk.Image
public typealias GtkViewport = Gtk.Viewport
public typealias GtkScrolledWindow = Gtk.ScrolledWindow
public typealias GtkColor = Gtk.Color
public typealias GtkDropDown = Gtk.DropDown
