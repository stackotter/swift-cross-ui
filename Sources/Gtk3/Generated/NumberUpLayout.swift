import CGtk3

/// Used to determine the layout of pages on a sheet when printing
/// multiple pages per sheet.
public enum NumberUpLayout: GValueRepresentableEnum {
    public typealias GtkEnum = GtkNumberUpLayout

    /// ![](layout-lrtb.png)
    case lrtb
    /// ![](layout-lrbt.png)
    case lrbt
    /// ![](layout-rltb.png)
    case rltb
    /// ![](layout-rlbt.png)
    case rlbt
    /// ![](layout-tblr.png)
    case tblr
    /// ![](layout-tbrl.png)
    case tbrl
    /// ![](layout-btlr.png)
    case btlr
    /// ![](layout-btrl.png)
    case btrl

    public static var type: GType {
        gtk_number_up_layout_get_type()
    }

    public init(from gtkEnum: GtkNumberUpLayout) {
        switch gtkEnum {
            case GTK_NUMBER_UP_LAYOUT_LEFT_TO_RIGHT_TOP_TO_BOTTOM:
                self = .lrtb
            case GTK_NUMBER_UP_LAYOUT_LEFT_TO_RIGHT_BOTTOM_TO_TOP:
                self = .lrbt
            case GTK_NUMBER_UP_LAYOUT_RIGHT_TO_LEFT_TOP_TO_BOTTOM:
                self = .rltb
            case GTK_NUMBER_UP_LAYOUT_RIGHT_TO_LEFT_BOTTOM_TO_TOP:
                self = .rlbt
            case GTK_NUMBER_UP_LAYOUT_TOP_TO_BOTTOM_LEFT_TO_RIGHT:
                self = .tblr
            case GTK_NUMBER_UP_LAYOUT_TOP_TO_BOTTOM_RIGHT_TO_LEFT:
                self = .tbrl
            case GTK_NUMBER_UP_LAYOUT_BOTTOM_TO_TOP_LEFT_TO_RIGHT:
                self = .btlr
            case GTK_NUMBER_UP_LAYOUT_BOTTOM_TO_TOP_RIGHT_TO_LEFT:
                self = .btrl
            default:
                fatalError("Unsupported GtkNumberUpLayout enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkNumberUpLayout {
        switch self {
            case .lrtb:
                return GTK_NUMBER_UP_LAYOUT_LEFT_TO_RIGHT_TOP_TO_BOTTOM
            case .lrbt:
                return GTK_NUMBER_UP_LAYOUT_LEFT_TO_RIGHT_BOTTOM_TO_TOP
            case .rltb:
                return GTK_NUMBER_UP_LAYOUT_RIGHT_TO_LEFT_TOP_TO_BOTTOM
            case .rlbt:
                return GTK_NUMBER_UP_LAYOUT_RIGHT_TO_LEFT_BOTTOM_TO_TOP
            case .tblr:
                return GTK_NUMBER_UP_LAYOUT_TOP_TO_BOTTOM_LEFT_TO_RIGHT
            case .tbrl:
                return GTK_NUMBER_UP_LAYOUT_TOP_TO_BOTTOM_RIGHT_TO_LEFT
            case .btlr:
                return GTK_NUMBER_UP_LAYOUT_BOTTOM_TO_TOP_LEFT_TO_RIGHT
            case .btrl:
                return GTK_NUMBER_UP_LAYOUT_BOTTOM_TO_TOP_RIGHT_TO_LEFT
        }
    }
}
