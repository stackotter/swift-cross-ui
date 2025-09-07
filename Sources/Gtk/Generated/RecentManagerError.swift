import CGtk

/// Error codes for `GtkRecentManager` operations
public enum RecentManagerError: GValueRepresentableEnum {
    public typealias GtkEnum = GtkRecentManagerError

    /// The URI specified does not exists in
    /// the recently used resources list.
    case notFound
    /// The URI specified is not valid.
    case invalidUri
    /// The supplied string is not
    /// UTF-8 encoded.
    case invalidEncoding
    /// No application has registered
    /// the specified item.
    case notRegistered
    /// Failure while reading the recently used
    /// resources file.
    case read
    /// Failure while writing the recently used
    /// resources file.
    case write
    /// Unspecified error.
    case unknown

    public static var type: GType {
        gtk_recent_manager_error_get_type()
    }

    public init(from gtkEnum: GtkRecentManagerError) {
        switch gtkEnum {
            case GTK_RECENT_MANAGER_ERROR_NOT_FOUND:
                self = .notFound
            case GTK_RECENT_MANAGER_ERROR_INVALID_URI:
                self = .invalidUri
            case GTK_RECENT_MANAGER_ERROR_INVALID_ENCODING:
                self = .invalidEncoding
            case GTK_RECENT_MANAGER_ERROR_NOT_REGISTERED:
                self = .notRegistered
            case GTK_RECENT_MANAGER_ERROR_READ:
                self = .read
            case GTK_RECENT_MANAGER_ERROR_WRITE:
                self = .write
            case GTK_RECENT_MANAGER_ERROR_UNKNOWN:
                self = .unknown
            default:
                fatalError("Unsupported GtkRecentManagerError enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkRecentManagerError {
        switch self {
            case .notFound:
                return GTK_RECENT_MANAGER_ERROR_NOT_FOUND
            case .invalidUri:
                return GTK_RECENT_MANAGER_ERROR_INVALID_URI
            case .invalidEncoding:
                return GTK_RECENT_MANAGER_ERROR_INVALID_ENCODING
            case .notRegistered:
                return GTK_RECENT_MANAGER_ERROR_NOT_REGISTERED
            case .read:
                return GTK_RECENT_MANAGER_ERROR_READ
            case .write:
                return GTK_RECENT_MANAGER_ERROR_WRITE
            case .unknown:
                return GTK_RECENT_MANAGER_ERROR_UNKNOWN
        }
    }
}
