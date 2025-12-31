import CGtk

public enum EllipsizeMode: GValueRepresentableEnum {
    public typealias GtkEnum = PangoEllipsizeMode

    case none
    case start
    case middle
    case end

    public static var type: GType {
        pango_ellipsize_mode_get_type()
    }

    public init(from gtkEnum: PangoEllipsizeMode) {
        switch gtkEnum {
            case PANGO_ELLIPSIZE_NONE:
                self = .none
            case PANGO_ELLIPSIZE_START:
                self = .start
            case PANGO_ELLIPSIZE_MIDDLE:
                self = .middle
            case PANGO_ELLIPSIZE_END:
                self = .end
            default:
                fatalError("Unsupported PangoEllipsizeMode enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> PangoEllipsizeMode {
        switch self {
            case .none:
                PANGO_ELLIPSIZE_NONE
            case .start:
                PANGO_ELLIPSIZE_START
            case .middle:
                PANGO_ELLIPSIZE_MIDDLE
            case .end:
                PANGO_ELLIPSIZE_END
        }
    }
}
