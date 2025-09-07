import CGtk

/// A `GtkGesture` subclass optimized for singe-touch and mouse gestures.
///
/// Under interaction, these gestures stick to the first interacting sequence,
/// which is accessible through [method@Gtk.GestureSingle.get_current_sequence]
/// while the gesture is being interacted with.
///
/// By default gestures react to both %GDK_BUTTON_PRIMARY and touch events.
/// [method@Gtk.GestureSingle.set_touch_only] can be used to change the
/// touch behavior. Callers may also specify a different mouse button number
/// to interact with through [method@Gtk.GestureSingle.set_button], or react
/// to any mouse button by setting it to 0. While the gesture is active, the
/// button being currently pressed can be known through
/// [method@Gtk.GestureSingle.get_current_button].
open class GestureSingle: Gesture {

    public override func registerSignals() {
        super.registerSignals()

        let handler0:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::button", handler: gCallback(handler0)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyButton?(self, param0)
        }

        let handler1:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::exclusive", handler: gCallback(handler1)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyExclusive?(self, param0)
        }

        let handler2:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::touch-only", handler: gCallback(handler2)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyTouchOnly?(self, param0)
        }
    }

    /// Mouse button number to listen to, or 0 to listen for any button.
    @GObjectProperty(named: "button") public var button: UInt

    /// Whether the gesture is exclusive.
    ///
    /// Exclusive gestures only listen to pointer and pointer emulated events.
    @GObjectProperty(named: "exclusive") public var exclusive: Bool

    /// Whether the gesture handles only touch events.
    @GObjectProperty(named: "touch-only") public var touchOnly: Bool

    public var notifyButton: ((GestureSingle, OpaquePointer) -> Void)?

    public var notifyExclusive: ((GestureSingle, OpaquePointer) -> Void)?

    public var notifyTouchOnly: ((GestureSingle, OpaquePointer) -> Void)?
}
