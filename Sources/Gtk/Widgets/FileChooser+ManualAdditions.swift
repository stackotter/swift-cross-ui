import CGtk
import Foundation

extension FileChooser {
    public func getFiles() -> GListModel {
        GListModel(gtk_file_chooser_get_files(OpaquePointer(gobjectPointer)))
    }

    public func setCurrentFolder(_ folder: URL) {
        let file = g_file_new_for_path(folder.path)
        gtk_file_chooser_set_current_folder(
            OpaquePointer(gobjectPointer),
            file,
            nil
        )
    }

    public func setCurrentName(_ name: String) {
        gtk_file_chooser_set_current_name(OpaquePointer(gobjectPointer), name)
    }
}
