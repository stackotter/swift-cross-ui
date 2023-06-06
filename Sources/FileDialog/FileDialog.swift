import CGtk
import Foundation
import Gtk

/// A wrapper for Gtk's file dialog.
public class FileDialog: GObjectRepresentable {
    var pointer: OpaquePointer?
    var cancellable: Cancellable?

    public var gobjectPointer: UnsafeMutablePointer<GObject> {
        return UnsafeMutablePointer<GObject>(pointer!)
    }

    public init() {
        pointer = gtk_file_dialog_new()
    }

    @GObjectProperty(named: "title") public var title: String?

    @GObjectProperty(named: "accept-label") public var acceptLabel: String?

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
