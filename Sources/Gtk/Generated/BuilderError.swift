import CGtk

/// Error codes that identify various errors that can occur while using
/// `GtkBuilder`.
public enum BuilderError {
    /// A type-func attribute didn’t name
    /// a function that returns a `GType`.
    case invalidTypeFunction
    /// The input contained a tag that `GtkBuilder`
    /// can’t handle.
    case unhandledTag
    /// An attribute that is required by
    /// `GtkBuilder` was missing.
    case missingAttribute
    /// `GtkBuilder` found an attribute that
    /// it doesn’t understand.
    case invalidAttribute
    /// `GtkBuilder` found a tag that
    /// it doesn’t understand.
    case invalidTag
    /// A required property value was
    /// missing.
    case missingPropertyValue
    /// `GtkBuilder` couldn’t parse
    /// some attribute value.
    case invalidValue
    /// The input file requires a newer version
    /// of GTK.
    case versionMismatch
    /// An object id occurred twice.
    case duplicateId
    /// A specified object type is of the same type or
    /// derived from the type of the composite class being extended with builder XML.
    case objectTypeRefused
    /// The wrong type was specified in a composite class’s template XML
    case templateMismatch
    /// The specified property is unknown for the object class.
    case invalidProperty
    /// The specified signal is unknown for the object class.
    case invalidSignal
    /// An object id is unknown.
    case invalidId
    /// A function could not be found. This often happens
    /// when symbols are set to be kept private. Compiling code with -rdynamic or using the
    /// `gmodule-export-2.0` pkgconfig module can fix this problem.
    case invalidFunction

    /// Converts the value to its corresponding Gtk representation.
    func toGtkBuilderError() -> GtkBuilderError {
        switch self {
            case .invalidTypeFunction:
                return GTK_BUILDER_ERROR_INVALID_TYPE_FUNCTION
            case .unhandledTag:
                return GTK_BUILDER_ERROR_UNHANDLED_TAG
            case .missingAttribute:
                return GTK_BUILDER_ERROR_MISSING_ATTRIBUTE
            case .invalidAttribute:
                return GTK_BUILDER_ERROR_INVALID_ATTRIBUTE
            case .invalidTag:
                return GTK_BUILDER_ERROR_INVALID_TAG
            case .missingPropertyValue:
                return GTK_BUILDER_ERROR_MISSING_PROPERTY_VALUE
            case .invalidValue:
                return GTK_BUILDER_ERROR_INVALID_VALUE
            case .versionMismatch:
                return GTK_BUILDER_ERROR_VERSION_MISMATCH
            case .duplicateId:
                return GTK_BUILDER_ERROR_DUPLICATE_ID
            case .objectTypeRefused:
                return GTK_BUILDER_ERROR_OBJECT_TYPE_REFUSED
            case .templateMismatch:
                return GTK_BUILDER_ERROR_TEMPLATE_MISMATCH
            case .invalidProperty:
                return GTK_BUILDER_ERROR_INVALID_PROPERTY
            case .invalidSignal:
                return GTK_BUILDER_ERROR_INVALID_SIGNAL
            case .invalidId:
                return GTK_BUILDER_ERROR_INVALID_ID
            case .invalidFunction:
                return GTK_BUILDER_ERROR_INVALID_FUNCTION
        }
    }
}

extension GtkBuilderError {
    /// Converts a Gtk value to its corresponding swift representation.
    func toBuilderError() -> BuilderError {
        switch self {
            case GTK_BUILDER_ERROR_INVALID_TYPE_FUNCTION:
                return .invalidTypeFunction
            case GTK_BUILDER_ERROR_UNHANDLED_TAG:
                return .unhandledTag
            case GTK_BUILDER_ERROR_MISSING_ATTRIBUTE:
                return .missingAttribute
            case GTK_BUILDER_ERROR_INVALID_ATTRIBUTE:
                return .invalidAttribute
            case GTK_BUILDER_ERROR_INVALID_TAG:
                return .invalidTag
            case GTK_BUILDER_ERROR_MISSING_PROPERTY_VALUE:
                return .missingPropertyValue
            case GTK_BUILDER_ERROR_INVALID_VALUE:
                return .invalidValue
            case GTK_BUILDER_ERROR_VERSION_MISMATCH:
                return .versionMismatch
            case GTK_BUILDER_ERROR_DUPLICATE_ID:
                return .duplicateId
            case GTK_BUILDER_ERROR_OBJECT_TYPE_REFUSED:
                return .objectTypeRefused
            case GTK_BUILDER_ERROR_TEMPLATE_MISMATCH:
                return .templateMismatch
            case GTK_BUILDER_ERROR_INVALID_PROPERTY:
                return .invalidProperty
            case GTK_BUILDER_ERROR_INVALID_SIGNAL:
                return .invalidSignal
            case GTK_BUILDER_ERROR_INVALID_ID:
                return .invalidId
            case GTK_BUILDER_ERROR_INVALID_FUNCTION:
                return .invalidFunction
            default:
                fatalError("Unsupported GtkBuilderError enum value: \(self.rawValue)")
        }
    }
}
