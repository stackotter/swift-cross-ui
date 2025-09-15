import CGtk3

/// #GtkAppChooser is an interface that can be implemented by widgets which
/// allow the user to choose an application (typically for the purpose of
/// opening a file). The main objects that implement this interface are
/// #GtkAppChooserWidget, #GtkAppChooserDialog and #GtkAppChooserButton.
///
/// Applications are represented by GIO #GAppInfo objects here.
/// GIO has a concept of recommended and fallback applications for a
/// given content type. Recommended applications are those that claim
/// to handle the content type itself, while fallback also includes
/// applications that handle a more generic content type. GIO also
/// knows the default and last-used application for a given content
/// type. The #GtkAppChooserWidget provides detailed control over
/// whether the shown list of applications should include default,
/// recommended or fallback applications.
///
/// To obtain the application that has been selected in a #GtkAppChooser,
/// use gtk_app_chooser_get_app_info().
public protocol AppChooser: GObjectRepresentable {
    /// The content type of the #GtkAppChooser object.
    ///
    /// See [GContentType][gio-GContentType]
    /// for more information about content types.
    var contentType: String { get set }

}
