import CGtk

extension Picture {
    public func setPath(_ path: String) {
        gtk_picture_set_filename(opaquePointer, path)
    }
}
