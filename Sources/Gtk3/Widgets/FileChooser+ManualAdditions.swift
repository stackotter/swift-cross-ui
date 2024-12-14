import CGtk3
import Foundation

extension FileChooser {
    public func getFiles() -> GSList {
        GSList(gtk_file_chooser_get_files(OpaquePointer(gobjectPointer)))
    }

    public func setCurrentFolder(_ folder: URL) {
        gtk_file_chooser_set_current_folder(
            OpaquePointer(gobjectPointer),
            folder.path
        )
    }

    public func setCurrentName(_ name: String) {
        gtk_file_chooser_set_current_name(OpaquePointer(gobjectPointer), name)
    }
}
