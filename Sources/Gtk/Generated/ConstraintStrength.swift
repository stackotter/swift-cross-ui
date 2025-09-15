import CGtk

/// The strength of a constraint, expressed as a symbolic constant.
///
/// The strength of a [class@Constraint] can be expressed with any positive
/// integer; the values of this enumeration can be used for readability.
public enum ConstraintStrength: GValueRepresentableEnum {
    public typealias GtkEnum = GtkConstraintStrength

    /// The constraint is required towards solving the layout
    case required
    /// A strong constraint
    case strong
    /// A medium constraint
    case medium
    /// A weak constraint
    case weak

    public static var type: GType {
        gtk_constraint_strength_get_type()
    }

    public init(from gtkEnum: GtkConstraintStrength) {
        switch gtkEnum {
            case GTK_CONSTRAINT_STRENGTH_REQUIRED:
                self = .required
            case GTK_CONSTRAINT_STRENGTH_STRONG:
                self = .strong
            case GTK_CONSTRAINT_STRENGTH_MEDIUM:
                self = .medium
            case GTK_CONSTRAINT_STRENGTH_WEAK:
                self = .weak
            default:
                fatalError("Unsupported GtkConstraintStrength enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkConstraintStrength {
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
