import CGtk3

/// The #GtkEventBox widget is a subclass of #GtkBin which also has its
/// own window. It is useful since it allows you to catch events for widgets
/// which do not have their own window.
open class EventBox: Bin {
    /// Creates a new #GtkEventBox.
    public convenience init() {
        self.init(
            gtk_event_box_new()
        )
    }

    override func didMoveToParent() {
        super.didMoveToParent()

        let handler0:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::above-child", handler: gCallback(handler0)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyAboveChild?(self, param0)
        }

        let handler1:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::visible-window", handler: gCallback(handler1)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyVisibleWindow?(self, param0)
        }
    }

    @GObjectProperty(named: "above-child") public var aboveChild: Bool

    @GObjectProperty(named: "visible-window") public var visibleWindow: Bool

    public var notifyAboveChild: ((EventBox, OpaquePointer) -> Void)?

    public var notifyVisibleWindow: ((EventBox, OpaquePointer) -> Void)?
}
