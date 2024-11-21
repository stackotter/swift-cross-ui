import CGtk

/// Controls how a widget deals with extra space in a single dimension.
///
/// Alignment only matters if the widget receives a “too large” allocation,
/// for example if you packed the widget with the [property@Gtk.Widget:hexpand]
/// property inside a [class@Box], then the widget might get extra space.
/// If you have for example a 16x16 icon inside a 32x32 space, the icon
/// could be scaled and stretched, it could be centered, or it could be
/// positioned to one side of the space.
///
/// Note that in horizontal context `GTK_ALIGN_START` and `GTK_ALIGN_END`
/// are interpreted relative to text direction.
///
/// Baseline support is optional for containers and widgets, and is only available
/// for vertical alignment. `GTK_ALIGN_BASELINE_CENTER and `GTK_ALIGN_BASELINE_FILL`
/// are treated similar to `GTK_ALIGN_CENTER` and `GTK_ALIGN_FILL`, except that it
/// positions the widget to line up the baselines, where that is supported.
public enum Align: GValueRepresentableEnum {
    public typealias GtkEnum = GtkAlign

    /// Stretch to fill all space if possible, center if
    /// no meaningful way to stretch
    case fill
    /// Snap to left or top side, leaving space on right or bottom
    case start
    /// Snap to right or bottom side, leaving space on left or top
    case end
    /// Center natural width of widget inside the allocation
    case center
    /// Align the widget according to the baseline.
    case baseline

    public static var type: GType {
        gtk_align_get_type()
    }

    public init(from gtkEnum: GtkAlign) {
        switch gtkEnum {
            case GTK_ALIGN_FILL:
                self = .fill
            case GTK_ALIGN_START:
                self = .start
            case GTK_ALIGN_END:
                self = .end
            case GTK_ALIGN_CENTER:
                self = .center
            case GTK_ALIGN_BASELINE:
                self = .baseline
            default:
                fatalError("Unsupported GtkAlign enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkAlign {
        switch self {
            case .fill:
                return GTK_ALIGN_FILL
            case .start:
                return GTK_ALIGN_START
            case .end:
                return GTK_ALIGN_END
            case .center:
                return GTK_ALIGN_CENTER
            case .baseline:
                return GTK_ALIGN_BASELINE
        }
    }
}
