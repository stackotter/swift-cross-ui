import CGtk3

/// Describes the image data representation used by a #GtkImage. If you
/// want to get the image from the widget, you can only get the
/// currently-stored representation. e.g.  if the
/// gtk_image_get_storage_type() returns #GTK_IMAGE_PIXBUF, then you can
/// call gtk_image_get_pixbuf() but not gtk_image_get_stock().  For empty
/// images, you can request any storage type (call any of the "get"
/// functions), but they will all return %NULL values.
public enum ImageType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkImageType

    /// There is no image displayed by the widget
    case empty
    /// The widget contains a #GdkPixbuf
    case pixbuf
    /// The widget contains a [stock item name][gtkstock]
    case stock
    /// The widget contains a #GtkIconSet
    case iconSet
    /// The widget contains a #GdkPixbufAnimation
    case animation
    /// The widget contains a named icon.
    /// This image type was added in GTK+ 2.6
    case iconName
    /// The widget contains a #GIcon.
    /// This image type was added in GTK+ 2.14
    case gicon
    /// The widget contains a #cairo_surface_t.
    /// This image type was added in GTK+ 3.10
    case surface

    public static var type: GType {
        gtk_image_type_get_type()
    }

    public init(from gtkEnum: GtkImageType) {
        switch gtkEnum {
            case GTK_IMAGE_EMPTY:
                self = .empty
            case GTK_IMAGE_PIXBUF:
                self = .pixbuf
            case GTK_IMAGE_STOCK:
                self = .stock
            case GTK_IMAGE_ICON_SET:
                self = .iconSet
            case GTK_IMAGE_ANIMATION:
                self = .animation
            case GTK_IMAGE_ICON_NAME:
                self = .iconName
            case GTK_IMAGE_GICON:
                self = .gicon
            case GTK_IMAGE_SURFACE:
                self = .surface
            default:
                fatalError("Unsupported GtkImageType enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkImageType {
        switch self {
            case .empty:
                return GTK_IMAGE_EMPTY
            case .pixbuf:
                return GTK_IMAGE_PIXBUF
            case .stock:
                return GTK_IMAGE_STOCK
            case .iconSet:
                return GTK_IMAGE_ICON_SET
            case .animation:
                return GTK_IMAGE_ANIMATION
            case .iconName:
                return GTK_IMAGE_ICON_NAME
            case .gicon:
                return GTK_IMAGE_GICON
            case .surface:
                return GTK_IMAGE_SURFACE
        }
    }
}
