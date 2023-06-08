import CGtk

extension Image {
    public func setPath(_ path: String) {
        gtk_image_set_from_file(opaquePointer, path)
    }
}
