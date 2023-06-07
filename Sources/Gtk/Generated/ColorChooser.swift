import CGtk

/// `GtkColorChooser` is an interface that is implemented by widgets
/// for choosing colors.
///
/// Depending on the situation, colors may be allowed to have alpha (translucency).
///
/// In GTK, the main widgets that implement this interface are
/// [class@Gtk.ColorChooserWidget], [class@Gtk.ColorChooserDialog] and
/// [class@Gtk.ColorButton].
public protocol ColorChooser: GObjectRepresentable {
    /// Whether colors may have alpha (translucency).
    ///
    /// When ::use-alpha is %FALSE, the `GdkRGBA` struct obtained
    /// via the [property@Gtk.ColorChooser:rgba] property will be
    /// forced to have alpha == 1.
    ///
    /// Implementations are expected to show alpha by rendering the color
    /// over a non-uniform background (like a checkerboard pattern).
    var useAlpha: Bool { get set }

    /// Emitted when a color is activated from the color chooser.
    ///
    /// This usually happens when the user clicks a color swatch,
    /// or a color is selected and the user presses one of the keys
    /// Space, Shift+Space, Return or Enter.
    var colorActivated: ((Self) -> Void)? { get set }
}
