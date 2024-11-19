import CGtk3

/// #GtkRange is the common base class for widgets which visualize an
/// adjustment, e.g #GtkScale or #GtkScrollbar.
///
/// Apart from signals for monitoring the parameters of the adjustment,
/// #GtkRange provides properties and methods for influencing the sensitivity
/// of the “steppers”. It also provides properties and methods for setting a
/// “fill level” on range widgets. See gtk_range_set_fill_level().
public class Range: Widget, Orientable {

    override func didMoveToParent() {
        removeSignals()

        super.didMoveToParent()

        let handler0:
            @convention(c) (UnsafeMutableRawPointer, Double, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<Double>.run(data, value1)
                }

        addSignal(name: "adjust-bounds", handler: gCallback(handler0)) { [weak self] (_: Double) in
            guard let self = self else { return }
            self.adjustBounds?(self)
        }

        let handler1:
            @convention(c) (UnsafeMutableRawPointer, GtkScrollType, Double, UnsafeMutableRawPointer)
                -> Void =
                { _, value1, value2, data in
                    SignalBox2<GtkScrollType, Double>.run(data, value1, value2)
                }

        addSignal(name: "change-value", handler: gCallback(handler1)) {
            [weak self] (_: GtkScrollType, _: Double) in
            guard let self = self else { return }
            self.changeValue?(self)
        }

        let handler2:
            @convention(c) (UnsafeMutableRawPointer, GtkScrollType, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<GtkScrollType>.run(data, value1)
                }

        addSignal(name: "move-slider", handler: gCallback(handler2)) {
            [weak self] (_: GtkScrollType) in
            guard let self = self else { return }
            self.moveSlider?(self)
        }

        addSignal(name: "value-changed") { [weak self] () in
            guard let self = self else { return }
            self.valueChanged?(self)
        }

        let handler4:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::adjustment", handler: gCallback(handler4)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyAdjustment?(self)
        }

        let handler5:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::fill-level", handler: gCallback(handler5)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyFillLevel?(self)
        }

        let handler6:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::inverted", handler: gCallback(handler6)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyInverted?(self)
        }

        let handler7:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::lower-stepper-sensitivity", handler: gCallback(handler7)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyLowerStepperSensitivity?(self)
        }

        let handler8:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::restrict-to-fill-level", handler: gCallback(handler8)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyRestrictToFillLevel?(self)
        }

        let handler9:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::round-digits", handler: gCallback(handler9)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyRoundDigits?(self)
        }

        let handler10:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::show-fill-level", handler: gCallback(handler10)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyShowFillLevel?(self)
        }

        let handler11:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::upper-stepper-sensitivity", handler: gCallback(handler11)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyUpperStepperSensitivity?(self)
        }

        let handler12:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::orientation", handler: gCallback(handler12)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifyOrientation?(self)
        }
    }

    @GObjectProperty(named: "inverted") public var inverted: Bool

    @GObjectProperty(named: "lower-stepper-sensitivity") public var lowerStepperSensitivity:
        SensitivityType

    @GObjectProperty(named: "upper-stepper-sensitivity") public var upperStepperSensitivity:
        SensitivityType

    /// Emitted before clamping a value, to give the application a
    /// chance to adjust the bounds.
    public var adjustBounds: ((Range) -> Void)?

    /// The #GtkRange::change-value signal is emitted when a scroll action is
    /// performed on a range.  It allows an application to determine the
    /// type of scroll event that occurred and the resultant new value.
    /// The application can handle the event itself and return %TRUE to
    /// prevent further processing.  Or, by returning %FALSE, it can pass
    /// the event to other handlers until the default GTK+ handler is
    /// reached.
    ///
    /// The value parameter is unrounded.  An application that overrides
    /// the GtkRange::change-value signal is responsible for clamping the
    /// value to the desired number of decimal digits; the default GTK+
    /// handler clamps the value based on #GtkRange:round-digits.
    public var changeValue: ((Range) -> Void)?

    /// Virtual function that moves the slider. Used for keybindings.
    public var moveSlider: ((Range) -> Void)?

    /// Emitted when the range value changes.
    public var valueChanged: ((Range) -> Void)?

    public var notifyAdjustment: ((Range) -> Void)?

    public var notifyFillLevel: ((Range) -> Void)?

    public var notifyInverted: ((Range) -> Void)?

    public var notifyLowerStepperSensitivity: ((Range) -> Void)?

    public var notifyRestrictToFillLevel: ((Range) -> Void)?

    public var notifyRoundDigits: ((Range) -> Void)?

    public var notifyShowFillLevel: ((Range) -> Void)?

    public var notifyUpperStepperSensitivity: ((Range) -> Void)?

    public var notifyOrientation: ((Range) -> Void)?
}
