import CGtk3

extension Image {
    public func setPath(_ path: String) {
        gtk_image_set_from_file(castedPointer(), path)
    }

    public func setPixbuf(_ pixbuf: Pixbuf) {
        gtk_image_set_from_pixbuf(castedPointer(), pixbuf.pointer)
    }

    public func setCairoSurface(_ surface: CairoSurface) {
        gtk_image_set_from_surface(castedPointer(), surface.pointer)
    }
}
