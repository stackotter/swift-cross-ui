import CGtk

/// `GtkRange` is the common base class for widgets which visualize an
/// adjustment.
///
/// Widgets that are derived from `GtkRange` include
/// [class@Gtk.Scale] and [class@Gtk.Scrollbar].
///
/// Apart from signals for monitoring the parameters of the adjustment,
/// `GtkRange` provides properties and methods for setting a
/// “fill level” on range widgets. See [method@Gtk.Range.set_fill_level].
public class Range: Widget, Orientable {

    override func didMoveToParent() {
        super.didMoveToParent()

        removeSignals()

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
    }

    /// The fill level (e.g. prebuffering of a network stream).
    @GObjectProperty(named: "fill-level") public var fillLevel: Double

    /// If %TRUE, the direction in which the slider moves is inverted.
    @GObjectProperty(named: "inverted") public var inverted: Bool

    /// Controls whether slider movement is restricted to an
    /// upper boundary set by the fill level.
    @GObjectProperty(named: "restrict-to-fill-level") public var restrictToFillLevel: Bool

    /// The number of digits to round the value to when
    /// it changes.
    ///
    /// See [signal@Gtk.Range::change-value].
    @GObjectProperty(named: "round-digits") public var roundDigits: Int

    /// Controls whether fill level indicator graphics are displayed
    /// on the trough.
    @GObjectProperty(named: "show-fill-level") public var showFillLevel: Bool

    /// The orientation of the orientable.
    @GObjectProperty(named: "orientation") public var orientation: Orientation

    /// Emitted before clamping a value, to give the application a
    /// chance to adjust the bounds.
    public var adjustBounds: ((Range) -> Void)?

    /// Emitted when a scroll action is performed on a range.
    ///
    /// It allows an application to determine the type of scroll event
    /// that occurred and the resultant new value. The application can
    /// handle the event itself and return %TRUE to prevent further
    /// processing. Or, by returning %FALSE, it can pass the event to
    /// other handlers until the default GTK handler is reached.
    ///
    /// The value parameter is unrounded. An application that overrides
    /// the ::change-value signal is responsible for clamping the value
    /// to the desired number of decimal digits; the default GTK
    /// handler clamps the value based on [property@Gtk.Range:round-digits].
    public var changeValue: ((Range) -> Void)?

    /// Virtual function that moves the slider.
    ///
    /// Used for keybindings.
    public var moveSlider: ((Range) -> Void)?

    /// Emitted when the range value changes.
    public var valueChanged: ((Range) -> Void)?
}
