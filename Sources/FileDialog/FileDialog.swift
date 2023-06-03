import CGtk
import Foundation
import Gtk

/// A wrapper for Gtk's file dialog.
public class FileDialog {
    var pointer: OpaquePointer?
    var cancellable: Cancellable?

    public init() {
        pointer = gtk_file_dialog_new()
    }

    public var title: String {
        get {
            String(cString: gtk_file_dialog_get_title(pointer))
        }
        set {
            newValue.withCString { newTitle in
                gtk_file_dialog_set_title(pointer, newTitle)
            }
        }
    }

    public var acceptLabel: String {
        get {
            String(cString: gtk_file_dialog_get_accept_label(pointer))
        }
        set {
            newValue.withCString { newTitle in
                gtk_file_dialog_set_accept_label(pointer, newTitle)
            }
        }
    }

    private class CallbackContext {
        var dialog: FileDialog
        var callback: (Result<URL, Error>) -> Void

        init(dialog: FileDialog, callback: @escaping (Result<URL, Error>) -> Void) {
            self.dialog = dialog
            self.callback = callback
        }
    }

    public func open(_ callback: @escaping (Result<URL, Error>) -> Void) {
        let cancellable = Cancellable()
        let context = CallbackContext(dialog: self, callback: callback)
        gtk_file_dialog_open(
            pointer,
            nil,
            cancellable.pointer,
            {
                (
                    _,
                    result: OpaquePointer?,
                    contextPointer: gpointer?
                ) in
                let unmanaged = Unmanaged<CallbackContext>.fromOpaque(contextPointer!)
                let context = unmanaged.takeUnretainedValue()

                do {
                    context.callback(.success(try context.dialog.openFinish(result)))
                } catch {
                    context.callback(.failure(error))
                }

                unmanaged.release()
            },
            Unmanaged.passRetained(context).toOpaque()
        )
        self.cancellable = cancellable
    }

    private func openFinish(_ result: OpaquePointer?) throws -> URL {
        let file = try withGtkError { error in
            gtk_file_dialog_open_finish(pointer, result, error)
        }
        let path = String(cString: g_file_get_path(file))
        return URL(fileURLWithPath: path)
    }

    public func cancel() {
        self.cancellable?.cancel()
        self.cancellable = nil
    }
}
