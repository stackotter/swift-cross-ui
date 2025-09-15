import CGtk3

/// Widget path types.
/// See also gtk_binding_set_add_path().
public enum PathType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkPathType

    /// Deprecated
    case widget
    /// Deprecated
    case widgetClass
    /// Deprecated
    case class_

    public static var type: GType {
        gtk_path_type_get_type()
    }

    public init(from gtkEnum: GtkPathType) {
        switch gtkEnum {
            case GTK_PATH_WIDGET:
                self = .widget
            case GTK_PATH_WIDGET_CLASS:
                self = .widgetClass
            case GTK_PATH_CLASS:
                self = .class_
            default:
                fatalError("Unsupported GtkPathType enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkPathType {
        switch self {
            case .widget:
                return GTK_PATH_WIDGET
            case .widgetClass:
                return GTK_PATH_WIDGET_CLASS
            case .class_:
                return GTK_PATH_CLASS
        }
    }
}
