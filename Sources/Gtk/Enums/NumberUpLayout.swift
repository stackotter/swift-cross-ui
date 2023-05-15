import CGtk

/// Used to determine the layout of pages on a sheet when printing multiple pages per sheet.
/// 
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.NumberUpLayout.html)
public enum NumberUpLayout {
    case leftToRightTopToBottom
    case leftToRightBottomToTop
    case rightToLeftTopToBottom
    case rightToLeftBottomToTop
    case topToBottomLeftToRight
    case topToBottomRightToLeft
    case bottomToTopLeftToRight
    case bottomToTopRightToLeft

    func toGtkNumberUpLayout() -> GtkNumberUpLayout {
        switch self {
        case .leftToRightTopToBottom:
            return GTK_NUMBER_UP_LAYOUT_LEFT_TO_RIGHT_TOP_TO_BOTTOM
        case .leftToRightBottomToTop:
            return GTK_NUMBER_UP_LAYOUT_LEFT_TO_RIGHT_BOTTOM_TO_TOP
        case .rightToLeftTopToBottom:
            return GTK_NUMBER_UP_LAYOUT_RIGHT_TO_LEFT_TOP_TO_BOTTOM
        case .rightToLeftBottomToTop:
            return GTK_NUMBER_UP_LAYOUT_RIGHT_TO_LEFT_BOTTOM_TO_TOP
        case .topToBottomLeftToRight:
            return GTK_NUMBER_UP_LAYOUT_TOP_TO_BOTTOM_LEFT_TO_RIGHT
        case .topToBottomRightToLeft:
            return GTK_NUMBER_UP_LAYOUT_TOP_TO_BOTTOM_RIGHT_TO_LEFT
        case .bottomToTopLeftToRight:
            return GTK_NUMBER_UP_LAYOUT_BOTTOM_TO_TOP_LEFT_TO_RIGHT
        case .bottomToTopRightToLeft:
            return GTK_NUMBER_UP_LAYOUT_BOTTOM_TO_TOP_RIGHT_TO_LEFT
        }
    }
}

extension GtkNumberUpLayout {
    func toNumberUpLayout() -> NumberUpLayout {
        switch self {
        case GTK_NUMBER_UP_LAYOUT_LEFT_TO_RIGHT_TOP_TO_BOTTOM:
            return .leftToRightTopToBottom
        case GTK_NUMBER_UP_LAYOUT_LEFT_TO_RIGHT_BOTTOM_TO_TOP:
            return .leftToRightBottomToTop
        case GTK_NUMBER_UP_LAYOUT_RIGHT_TO_LEFT_TOP_TO_BOTTOM:
            return .rightToLeftTopToBottom
        case GTK_NUMBER_UP_LAYOUT_RIGHT_TO_LEFT_BOTTOM_TO_TOP:
            return .rightToLeftBottomToTop
        case GTK_NUMBER_UP_LAYOUT_TOP_TO_BOTTOM_LEFT_TO_RIGHT:
            return .topToBottomLeftToRight
        case GTK_NUMBER_UP_LAYOUT_TOP_TO_BOTTOM_RIGHT_TO_LEFT:
            return .topToBottomRightToLeft
        case GTK_NUMBER_UP_LAYOUT_BOTTOM_TO_TOP_LEFT_TO_RIGHT:
            return .bottomToTopLeftToRight
        case GTK_NUMBER_UP_LAYOUT_BOTTOM_TO_TOP_RIGHT_TO_LEFT:
            return .bottomToTopRightToLeft
        default:
            fatalError("Unsupported GtkNumberUpLayout enum value: \(self.rawValue)")
        }
    }
}
