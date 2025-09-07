import CGtk

/// `GtkFontChooser` is an interface that can be implemented by widgets
/// for choosing fonts.
///
/// In GTK, the main objects that implement this interface are
/// [class@Gtk.FontChooserWidget], [class@Gtk.FontChooserDialog] and
/// [class@Gtk.FontButton].
public protocol FontChooser: GObjectRepresentable {
    /// The font description as a string, e.g. "Sans Italic 12".
    var font: String? { get set }

    /// The selected font features.
    ///
    /// The format of the string is compatible with
    /// CSS and with Pango attributes.
    var fontFeatures: String { get set }

    /// The language for which the font features were selected.
    var language: String { get set }

    /// The string with which to preview the font.
    var previewText: String { get set }

    /// Whether to show an entry to change the preview text.
    var showPreviewEntry: Bool { get set }

    /// Emitted when a font is activated.
    ///
    /// This usually happens when the user double clicks an item,
    /// or an item is selected and the user presses one of the keys
    /// Space, Shift+Space, Return or Enter.
    var fontActivated: ((Self, UnsafePointer<CChar>) -> Void)? { get set }
}
