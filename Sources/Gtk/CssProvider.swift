import CGtk

public class CssProvider {
    var pointer: UnsafeMutablePointer<GtkCssProvider>

    init() {
        pointer = gtk_css_provider_new()
    }

    public func loadFromData(_ data: String) {
        data.withCString { cString in
            gtk_css_provider_load_from_data(pointer, cString, gssize(data.count))
        }
    }
}
