import CGtk

extension Picture {
    public func setPath(_ path: String) {
        gtk_picture_set_filename(opaquePointer, path)
    }

    public func setPaintable(_ paintable: OpaquePointer) {
        gtk_picture_set_paintable(opaquePointer, paintable)
    }
}
