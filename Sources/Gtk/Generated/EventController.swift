import CGtk

/// The base class for event controllers.
///
/// These are ancillary objects associated to widgets, which react
/// to `GdkEvents`, and possibly trigger actions as a consequence.
///
/// Event controllers are added to a widget with
/// [method@Gtk.Widget.add_controller]. It is rarely necessary to
/// explicitly remove a controller with [method@Gtk.Widget.remove_controller].
///
/// See the chapter on [input handling](input-handling.html) for
/// an overview of the basic concepts, such as the capture and bubble
/// phases of event propagation.
open class EventController: GObject {

    public override func registerSignals() {
        super.registerSignals()

        let handler0:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::name", handler: gCallback(handler0)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyName?(self, param0)
        }

        let handler1:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::propagation-limit", handler: gCallback(handler1)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPropagationLimit?(self, param0)
        }

        let handler2:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::propagation-phase", handler: gCallback(handler2)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyPropagationPhase?(self, param0)
        }

        let handler3:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::widget", handler: gCallback(handler3)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyWidget?(self, param0)
        }
    }

    /// The name for this controller, typically used for debugging purposes.
    @GObjectProperty(named: "name") public var name: String?

    /// The limit for which events this controller will handle.
    @GObjectProperty(named: "propagation-limit") public var propagationLimit: PropagationLimit

    /// The propagation phase at which this controller will handle events.
    @GObjectProperty(named: "propagation-phase") public var propagationPhase: PropagationPhase

    public var notifyName: ((EventController, OpaquePointer) -> Void)?

    public var notifyPropagationLimit: ((EventController, OpaquePointer) -> Void)?

    public var notifyPropagationPhase: ((EventController, OpaquePointer) -> Void)?

    public var notifyWidget: ((EventController, OpaquePointer) -> Void)?
}
