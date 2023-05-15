import CGtk

/// Describes the image data representation used by a `GtkImage`. If you want to get the image from the widget, you can only get the currently-stored representation. e.g. if the `gtk_image_get_storage_type()` returns #GTK_IMAGE_PIXBUF, then you can call `gtk_image_get_pixbuf()` but not `gtk_image_get_stock()`. For empty images, you can request any storage type (call any of the “get” functions), but they will all return `NULL` values.
/// 
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.ImageType.html)
public enum ImageType {
    /// There is no image displayed by the widget.
    case empty
    /// The widget contains a named icon.
    case iconName
    /// The widget contains a GIcon. This image type was added in GTK+ 2.14.
    case gIcon
    /// The widget contains a `GdkPaintable`.
    case paintable

    func toGtkImageType() -> GtkImageType {
        switch self {
        case .empty:
            return GTK_IMAGE_EMPTY
        case .iconName:
            return GTK_IMAGE_ICON_NAME
        case .gIcon:
            return GTK_IMAGE_GICON
        case .paintable:
            return GTK_IMAGE_PAINTABLE
        }
    }
}

extension GtkImageType {
    func toImageType() -> ImageType {
        switch self {
        case GTK_IMAGE_EMPTY:
            return .empty
        case GTK_IMAGE_ICON_NAME:
            return .iconName
        case GTK_IMAGE_GICON:
            return .gIcon
        case GTK_IMAGE_PAINTABLE:
            return .paintable
        default:
            fatalError("Unsupported GtkImageType enum value: \(self.rawValue)")
        }
    }
}
