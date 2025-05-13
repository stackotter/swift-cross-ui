import CGtk

/// Recognizes long press gestures.
///
/// This gesture is also known as “Press and Hold”.
///
/// When the timeout is exceeded, the gesture is triggering the
/// [signal@Gtk.GestureLongPress::pressed] signal.
///
/// If the touchpoint is lifted before the timeout passes, or if
/// it drifts too far of the initial press point, the
/// [signal@Gtk.GestureLongPress::cancelled] signal will be emitted.
///
/// How long the timeout is before the ::pressed signal gets emitted is
/// determined by the [property@Gtk.Settings:gtk-long-press-time] setting.
/// It can be modified by the [property@Gtk.GestureLongPress:delay-factor]
/// property.
open class GestureLongPress: GestureSingle {
    /// Returns a newly created `GtkGesture` that recognizes long presses.
    public convenience init() {
        self.init(
            gtk_gesture_long_press_new()
        )
    }

    public override func registerSignals() {
        super.registerSignals()

        addSignal(name: "cancelled") { [weak self] () in
            guard let self = self else { return }
            self.cancelled?(self)
        }

        let handler1:
            @convention(c) (UnsafeMutableRawPointer, Double, Double, UnsafeMutableRawPointer) ->
                Void =
                { _, value1, value2, data in
                    SignalBox2<Double, Double>.run(data, value1, value2)
                }

        addSignal(name: "pressed", handler: gCallback(handler1)) {
            [weak self] (param0: Double, param1: Double) in
            guard let self = self else { return }
            self.pressed?(self, param0, param1)
        }

        let handler2:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::delay-factor", handler: gCallback(handler2)) {
            [weak self] (param0: OpaquePointer) in
            guard let self = self else { return }
            self.notifyDelayFactor?(self, param0)
        }
    }

    /// Factor by which to modify the default timeout.
    @GObjectProperty(named: "delay-factor") public var delayFactor: Double

    /// Emitted whenever a press moved too far, or was released
    /// before [signal@Gtk.GestureLongPress::pressed] happened.
    public var cancelled: ((GestureLongPress) -> Void)?

    /// Emitted whenever a press goes unmoved/unreleased longer than
    /// what the GTK defaults tell.
    public var pressed: ((GestureLongPress, Double, Double) -> Void)?

    public var notifyDelayFactor: ((GestureLongPress, OpaquePointer) -> Void)?
}
