import CGtk

/// Built-in icon sizes.
///
/// Icon sizes default to being inherited. Where they cannot be
/// inherited, text size is the default.
///
/// All widgets which use `GtkIconSize` set the normal-icons or
/// large-icons style classes correspondingly, and let themes
/// determine the actual size to be used with the
/// `-gtk-icon-size` CSS property.
public enum IconSize: GValueRepresentableEnum {
    public typealias GtkEnum = GtkIconSize

    /// Keep the size of the parent element
    case inherit
    /// Size similar to text size
    case normal
    /// Large size, for example in an icon view
    case large

    public static var type: GType {
        gtk_icon_size_get_type()
    }

    public init(from gtkEnum: GtkIconSize) {
        switch gtkEnum {
            case GTK_ICON_SIZE_INHERIT:
                self = .inherit
            case GTK_ICON_SIZE_NORMAL:
                self = .normal
            case GTK_ICON_SIZE_LARGE:
                self = .large
            default:
                fatalError("Unsupported GtkIconSize enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkIconSize {
        switch self {
            case .inherit:
                return GTK_ICON_SIZE_INHERIT
            case .normal:
                return GTK_ICON_SIZE_NORMAL
            case .large:
                return GTK_ICON_SIZE_LARGE
        }
    }
}
