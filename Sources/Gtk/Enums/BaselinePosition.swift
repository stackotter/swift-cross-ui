import CGtk

/// Whenever a container has some form of natural row it may align children in that row along a common typographical baseline. If the amount of verical space in the row is taller than the total requested height of the baseline-aligned children then it can use a `GtkBaselinePosition` to select where to put the baseline inside the extra availible space.
///
/// Available since:	3.10
/// 
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.BaselinePosition.html)
public enum BaselinePosition {
    /// Align the baseline at the top.
    case top
    /// Center the baseline.
    case center
    /// Align the baseline at the bottom.
    case bottom

    func toGtkBaselinePosition() -> GtkBaselinePosition {
        switch self {
        case .top:
            return GTK_BASELINE_POSITION_TOP
        case .center:
            return GTK_BASELINE_POSITION_CENTER
        case .bottom:
            return GTK_BASELINE_POSITION_BOTTOM
        }
    }
}

extension GtkBaselinePosition {
    func toBaselinePosition() -> BaselinePosition {
        switch self {
        case GTK_BASELINE_POSITION_TOP:
            return .top
        case GTK_BASELINE_POSITION_CENTER:
            return .center
        case GTK_BASELINE_POSITION_BOTTOM:
            return .bottom
        default:
            fatalError("Unsupported GtkBaselinePosition enum value: \(self.rawValue)")
        }
    }
}
