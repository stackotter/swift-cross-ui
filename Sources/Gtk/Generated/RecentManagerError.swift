import CGtk

/// Error codes for `GtkRecentManager` operations
public enum RecentManagerError {
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

    /// Converts the value to its corresponding Gtk representation.
    func toGtkRecentManagerError() -> GtkRecentManagerError {
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

extension GtkRecentManagerError {
    /// Converts a Gtk value to its corresponding swift representation.
    func toRecentManagerError() -> RecentManagerError {
        switch self {
            case GTK_RECENT_MANAGER_ERROR_NOT_FOUND:
                return .notFound
            case GTK_RECENT_MANAGER_ERROR_INVALID_URI:
                return .invalidUri
            case GTK_RECENT_MANAGER_ERROR_INVALID_ENCODING:
                return .invalidEncoding
            case GTK_RECENT_MANAGER_ERROR_NOT_REGISTERED:
                return .notRegistered
            case GTK_RECENT_MANAGER_ERROR_READ:
                return .read
            case GTK_RECENT_MANAGER_ERROR_WRITE:
                return .write
            case GTK_RECENT_MANAGER_ERROR_UNKNOWN:
                return .unknown
            default:
                fatalError("Unsupported GtkRecentManagerError enum value: \(self.rawValue)")
        }
    }
}
