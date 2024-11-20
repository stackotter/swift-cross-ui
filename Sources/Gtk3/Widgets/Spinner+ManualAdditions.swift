import CGtk3

extension Spinner {
    public func start() {
        gtk_spinner_start(castedPointer())
    }

    public func stop() {
        gtk_spinner_stop(castedPointer())
    }
}
