import CGtk

/// Baseline position in a row of widgets.
///
/// Whenever a container has some form of natural row it may align
/// children in that row along a common typographical baseline. If
/// the amount of vertical space in the row is taller than the total
/// requested height of the baseline-aligned children then it can use a
/// `GtkBaselinePosition` to select where to put the baseline inside the
/// extra available space.
public enum BaselinePosition: GValueRepresentableEnum {
    public typealias GtkEnum = GtkBaselinePosition

    /// Align the baseline at the top
    case top
    /// Center the baseline
    case center
    /// Align the baseline at the bottom
    case bottom

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkBaselinePosition) {
        switch gtkEnum {
            case GTK_BASELINE_POSITION_TOP:
                self = .top
            case GTK_BASELINE_POSITION_CENTER:
                self = .center
            case GTK_BASELINE_POSITION_BOTTOM:
                self = .bottom
            default:
                fatalError("Unsupported GtkBaselinePosition enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkBaselinePosition {
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
