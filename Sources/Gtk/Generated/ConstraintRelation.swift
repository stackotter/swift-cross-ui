import CGtk

/// The relation between two terms of a constraint.
public enum ConstraintRelation {
    /// Less than, or equal
    case le
    /// Equal
    case eq
    /// Greater than, or equal
    case ge

    /// Converts the value to its corresponding Gtk representation.
    func toGtkConstraintRelation() -> GtkConstraintRelation {
        switch self {
            case .le:
                return GTK_CONSTRAINT_RELATION_LE
            case .eq:
                return GTK_CONSTRAINT_RELATION_EQ
            case .ge:
                return GTK_CONSTRAINT_RELATION_GE
        }
    }
}

extension GtkConstraintRelation {
    /// Converts a Gtk value to its corresponding swift representation.
    func toConstraintRelation() -> ConstraintRelation {
        switch self {
            case GTK_CONSTRAINT_RELATION_LE:
                return .le
            case GTK_CONSTRAINT_RELATION_EQ:
                return .eq
            case GTK_CONSTRAINT_RELATION_GE:
                return .ge
            default:
                fatalError("Unsupported GtkConstraintRelation enum value: \(self.rawValue)")
        }
    }
}
