import CGtk

/// The relation between two terms of a constraint.
public enum ConstraintRelation: GValueRepresentableEnum {
    public typealias GtkEnum = GtkConstraintRelation

    /// Less than, or equal
    case le
    /// Equal
    case eq
    /// Greater than, or equal
    case ge

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkConstraintRelation) {
        switch gtkEnum {
            case GTK_CONSTRAINT_RELATION_LE:
                self = .le
            case GTK_CONSTRAINT_RELATION_EQ:
                self = .eq
            case GTK_CONSTRAINT_RELATION_GE:
                self = .ge
            default:
                fatalError("Unsupported GtkConstraintRelation enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkConstraintRelation {
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
