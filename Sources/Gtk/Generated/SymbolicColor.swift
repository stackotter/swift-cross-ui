import CGtk

/// The indexes of colors passed to symbolic color rendering, such as
/// [vfunc@Gtk.SymbolicPaintable.snapshot_symbolic].
///
/// More values may be added over time.
public enum SymbolicColor {
    /// The default foreground color
    case foreground
    /// Indication color for errors
    case error
    /// Indication color for warnings
    case warning
    /// Indication color for success
    case success

    /// Converts the value to its corresponding Gtk representation.
    func toGtkSymbolicColor() -> GtkSymbolicColor {
        switch self {
            case .foreground:
                return GTK_SYMBOLIC_COLOR_FOREGROUND
            case .error:
                return GTK_SYMBOLIC_COLOR_ERROR
            case .warning:
                return GTK_SYMBOLIC_COLOR_WARNING
            case .success:
                return GTK_SYMBOLIC_COLOR_SUCCESS
        }
    }
}

extension GtkSymbolicColor {
    /// Converts a Gtk value to its corresponding swift representation.
    func toSymbolicColor() -> SymbolicColor {
        switch self {
            case GTK_SYMBOLIC_COLOR_FOREGROUND:
                return .foreground
            case GTK_SYMBOLIC_COLOR_ERROR:
                return .error
            case GTK_SYMBOLIC_COLOR_WARNING:
                return .warning
            case GTK_SYMBOLIC_COLOR_SUCCESS:
                return .success
            default:
                fatalError("Unsupported GtkSymbolicColor enum value: \(self.rawValue)")
        }
    }
}
