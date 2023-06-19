import CGtk

/// Swift representation of a Gtk CSS provider
public class CSSProvider {
    var pointer: UnsafeMutablePointer<GtkCssProvider>
    var display: OpaquePointer

    init(
        forDisplay display: OpaquePointer = gdk_display_get_default(),
        priority: UInt32 = UInt32(GTK_STYLE_PROVIDER_PRIORITY_APPLICATION)
    ) {
        pointer = gtk_css_provider_new()
        self.display = display
        gtk_style_context_add_provider_for_display(display, OpaquePointer(pointer), priority)
    }

    deinit {
        gtk_style_context_remove_provider_for_display(display, OpaquePointer(pointer))
    }

    /// Loads data into css_provider.
    ///
    /// This clears any previously loaded information.
    ///
    /// Deprecated since: 4.12
    public func loadCss(from data: String) {
        gtk_css_provider_load_from_data(pointer, data, gssize(data.count))
    }
}
