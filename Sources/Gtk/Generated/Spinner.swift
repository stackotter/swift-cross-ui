import CGtk

/// A `GtkSpinner` widget displays an icon-size spinning animation.
///
/// It is often used as an alternative to a [class@Gtk.ProgressBar]
/// for displaying indefinite activity, instead of actual progress.
///
/// ![An example GtkSpinner](spinner.png)
///
/// To start the animation, use [method@Gtk.Spinner.start], to stop it
/// use [method@Gtk.Spinner.stop].
///
/// # CSS nodes
///
/// `GtkSpinner` has a single CSS node with the name spinner.
/// When the animation is active, the :checked pseudoclass is
/// added to this node.
public class Spinner: Widget {
    /// Returns a new spinner widget. Not yet started.
    override public init() {
        super.init()
        widgetPointer = gtk_spinner_new()
    }

    override func didMoveToParent() {
        removeSignals()

        super.didMoveToParent()

        let handler0:
            @convention(c) (UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer) -> Void =
                { _, value1, data in
                    SignalBox1<OpaquePointer>.run(data, value1)
                }

        addSignal(name: "notify::spinning", handler: gCallback(handler0)) {
            [weak self] (_: OpaquePointer) in
            guard let self = self else { return }
            self.notifySpinning?(self)
        }
    }

    /// Whether the spinner is spinning
    @GObjectProperty(named: "spinning") public var spinning: Bool

    public var notifySpinning: ((Spinner) -> Void)?
}
