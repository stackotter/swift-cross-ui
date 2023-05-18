/// An alignment option that can be used by a container to align its children.
public enum Alignment {
    /// Align children to the leading edge of the container along the alignment axis.
    case leading
    /// Align children to the center of the container along the alignment axis.
    case center
    /// Align children to the trailing edge of the container along the alignment axis.
    case trailing

    /// The underlying Gtk representation of the alignment value.
    var gtkAlignment: GtkAlign {
        switch self {
            case .leading:
                return .start
            case .center:
                return .center
            case .trailing:
                return .end
        }
    }
}
