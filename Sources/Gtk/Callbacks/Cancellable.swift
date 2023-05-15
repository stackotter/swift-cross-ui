import CGtk

public struct Cancellable {
    var pointer: UnsafeMutablePointer<GCancellable>?

    public init() {
        pointer = g_cancellable_new()
    }

    public func cancel() {
        g_cancellable_cancel(pointer)
    }
}
