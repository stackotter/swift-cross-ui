import CGtk

/// `GtkSectionModel` is an interface that adds support for sections to list models.
///
/// A `GtkSectionModel` groups successive items into so-called sections. List widgets
/// like `GtkListView` and `GtkGridView` then allow displaying section headers for
/// these sections by installing a header factory.
///
/// Many GTK list models support sections inherently, or they pass through the sections
/// of a model they are wrapping.
///
/// When the section groupings of a model change, the model will emit the
/// [signal@Gtk.SectionModel::sections-changed] signal by calling the
/// [method@Gtk.SectionModel.sections_changed] function. All sections in the given range
/// then need to be queried again.
/// The [signal@Gio.ListModel::items-changed] signal has the same effect, all sections in
/// that range are invalidated, too.
public protocol SectionModel: GObjectRepresentable {

    /// Emitted when the start-of-section state of some of the items in @model changes.
    ///
    /// Note that this signal does not specify the new section state of the
    /// items, they need to be queried manually. It is also not necessary for
    /// a model to change the section state of any of the items in the section
    /// model, though it would be rather useless to emit such a signal.
    ///
    /// The [signal@Gio.ListModel::items-changed] implies the effect of the
    /// [signal@Gtk.SectionModel::sections-changed] signal for all the items
    /// it covers.
    var sectionsChanged: ((Self) -> Void)? { get set }
}
