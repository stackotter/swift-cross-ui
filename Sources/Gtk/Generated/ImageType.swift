import CGtk

/// Describes the image data representation used by a [class@Gtk.Image].
///
/// If you want to get the image from the widget, you can only get the
/// currently-stored representation; for instance, if the gtk_image_get_storage_type()
/// returns %GTK_IMAGE_PAINTABLE, then you can call gtk_image_get_paintable().
///
/// For empty images, you can request any storage type (call any of the "get"
/// functions), but they will all return %NULL values.
public enum ImageType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkImageType

    /// There is no image displayed by the widget
    case empty
    /// The widget contains a named icon
    case iconName
    /// The widget contains a `GIcon`
    case gicon
    /// The widget contains a `GdkPaintable`
    case paintable

    public static var type: GType {
        gtk_image_type_get_type()
    }

    public init(from gtkEnum: GtkImageType) {
        switch gtkEnum {
            case GTK_IMAGE_EMPTY:
                self = .empty
            case GTK_IMAGE_ICON_NAME:
                self = .iconName
            case GTK_IMAGE_GICON:
                self = .gicon
            case GTK_IMAGE_PAINTABLE:
                self = .paintable
            default:
                fatalError("Unsupported GtkImageType enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkImageType {
        switch self {
            case .empty:
                return GTK_IMAGE_EMPTY
            case .iconName:
                return GTK_IMAGE_ICON_NAME
            case .gicon:
                return GTK_IMAGE_GICON
            case .paintable:
                return GTK_IMAGE_PAINTABLE
        }
    }
}
