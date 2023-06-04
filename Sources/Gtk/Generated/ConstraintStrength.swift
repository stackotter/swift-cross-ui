import CGtk

/// The strength of a constraint, expressed as a symbolic constant.
///
/// The strength of a [class@Constraint] can be expressed with any positive
/// integer; the values of this enumeration can be used for readability.
public enum ConstraintStrength {
    /// The constraint is required towards solving the layout
    case required
    /// A strong constraint
    case strong
    /// A medium constraint
    case medium
    /// A weak constraint
    case weak

    /// Converts the value to its corresponding Gtk representation.
    func toGtkConstraintStrength() -> GtkConstraintStrength {
        switch self {
            case .required:
                return GTK_CONSTRAINT_STRENGTH_REQUIRED
            case .strong:
                return GTK_CONSTRAINT_STRENGTH_STRONG
            case .medium:
                return GTK_CONSTRAINT_STRENGTH_MEDIUM
            case .weak:
                return GTK_CONSTRAINT_STRENGTH_WEAK
        }
    }
}

extension GtkConstraintStrength {
    /// Converts a Gtk value to its corresponding swift representation.
    func toConstraintStrength() -> ConstraintStrength {
        switch self {
            case GTK_CONSTRAINT_STRENGTH_REQUIRED:
                return .required
            case GTK_CONSTRAINT_STRENGTH_STRONG:
                return .strong
            case GTK_CONSTRAINT_STRENGTH_MEDIUM:
                return .medium
            case GTK_CONSTRAINT_STRENGTH_WEAK:
                return .weak
            default:
                fatalError("Unsupported GtkConstraintStrength enum value: \(self.rawValue)")
        }
    }
}
