import CGtk3

/// Swift representation of a Gtk CSS provider
public class CSSProvider {
    var pointer: UnsafeMutablePointer<GtkCssProvider>
    var context: UnsafeMutablePointer<GtkStyleContext>

    init(
        forContext context: UnsafeMutablePointer<GtkStyleContext>,
        priority: UInt32 = UInt32(GTK_STYLE_PROVIDER_PRIORITY_APPLICATION)
    ) {
        pointer = gtk_css_provider_new()
        self.context = context
        g_object_ref(context)
        gtk_style_context_add_provider(context, OpaquePointer(pointer), priority)
    }

    deinit {
        gtk_style_context_remove_provider(context, OpaquePointer(pointer))
        g_object_unref(context)
    }

    /// Loads data into css_provider.
    ///
    /// This clears any previously loaded information.
    public func loadCss(from data: String) {
        var error: UnsafeMutablePointer<GError>? = nil
        gtk_css_provider_load_from_data(pointer, data, gssize(data.count), &error)
    }
}
