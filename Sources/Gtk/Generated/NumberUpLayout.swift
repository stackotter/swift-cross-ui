import CGtk

/// Used to determine the layout of pages on a sheet when printing
/// multiple pages per sheet.
public enum NumberUpLayout {
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

    /// Converts the value to its corresponding Gtk representation.
    func toGtkNumberUpLayout() -> GtkNumberUpLayout {
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

extension GtkNumberUpLayout {
    /// Converts a Gtk value to its corresponding swift representation.
    func toNumberUpLayout() -> NumberUpLayout {
        switch self {
            case GTK_NUMBER_UP_LAYOUT_LEFT_TO_RIGHT_TOP_TO_BOTTOM:
                return .lrtb
            case GTK_NUMBER_UP_LAYOUT_LEFT_TO_RIGHT_BOTTOM_TO_TOP:
                return .lrbt
            case GTK_NUMBER_UP_LAYOUT_RIGHT_TO_LEFT_TOP_TO_BOTTOM:
                return .rltb
            case GTK_NUMBER_UP_LAYOUT_RIGHT_TO_LEFT_BOTTOM_TO_TOP:
                return .rlbt
            case GTK_NUMBER_UP_LAYOUT_TOP_TO_BOTTOM_LEFT_TO_RIGHT:
                return .tblr
            case GTK_NUMBER_UP_LAYOUT_TOP_TO_BOTTOM_RIGHT_TO_LEFT:
                return .tbrl
            case GTK_NUMBER_UP_LAYOUT_BOTTOM_TO_TOP_LEFT_TO_RIGHT:
                return .btlr
            case GTK_NUMBER_UP_LAYOUT_BOTTOM_TO_TOP_RIGHT_TO_LEFT:
                return .btrl
            default:
                fatalError("Unsupported GtkNumberUpLayout enum value: \(self.rawValue)")
        }
    }
}
