import CGtk3

/// #GtkFontChooser is an interface that can be implemented by widgets
/// displaying the list of fonts. In GTK+, the main objects
/// that implement this interface are #GtkFontChooserWidget,
/// #GtkFontChooserDialog and #GtkFontButton. The GtkFontChooser interface
/// has been introducted in GTK+ 3.2.
public protocol FontChooser: GObjectRepresentable {
    /// The font description as a string, e.g. "Sans Italic 12".
    var font: String? { get set }

    /// The string with which to preview the font.
    var previewText: String { get set }

    /// Whether to show an entry to change the preview text.
    var showPreviewEntry: Bool { get set }

    /// Emitted when a font is activated.
    /// This usually happens when the user double clicks an item,
    /// or an item is selected and the user presses one of the keys
    /// Space, Shift+Space, Return or Enter.
    var fontActivated: ((Self, UnsafePointer<CChar>) -> Void)? { get set }
}
