import CGtk3

public protocol PrintOperationPreview: GObjectRepresentable {

    /// The ::got-page-size signal is emitted once for each page
    /// that gets rendered to the preview.
    ///
    /// A handler for this signal should update the @context
    /// according to @page_setup and set up a suitable cairo
    /// context, using gtk_print_context_set_cairo_context().
    var gotPageSize: ((Self) -> Void)? { get set }

    /// The ::ready signal gets emitted once per preview operation,
    /// before the first page is rendered.
    ///
    /// A handler for this signal can be used for setup tasks.
    var ready: ((Self) -> Void)? { get set }
}
