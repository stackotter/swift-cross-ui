import CGtk

/// `GtkPrintOperationPreview` is the interface that is used to
/// implement print preview.
///
/// A `GtkPrintOperationPreview` object is passed to the
/// [signal@Gtk.PrintOperation::preview] signal by
/// [class@Gtk.PrintOperation].
public protocol PrintOperationPreview: GObjectRepresentable {

    /// Emitted once for each page that gets rendered to the preview.
    ///
    /// A handler for this signal should update the @context
    /// according to @page_setup and set up a suitable cairo
    /// context, using [method@Gtk.PrintContext.set_cairo_context].
    var gotPageSize: ((Self) -> Void)? { get set }

    /// The ::ready signal gets emitted once per preview operation,
    /// before the first page is rendered.
    ///
    /// A handler for this signal can be used for setup tasks.
    var ready: ((Self) -> Void)? { get set }
}
