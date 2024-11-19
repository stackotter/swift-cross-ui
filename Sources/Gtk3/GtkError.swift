import CGtk3
import Foundation

public struct GtkError: LocalizedError {
    public var code: Int
    public var domain: Int
    public var message: String

    public init(from error: GError) {
        message = String(cString: error.message)
        code = Int(error.code)
        domain = Int(error.domain)
    }

    public var errorDescription: String? {
        return message
    }
}

/// An easy way to wrap Gtk code that uses error pointers for handling. Passes an error pointer to
/// your code, which is then checked for an error which is thrown if present.
@discardableResult
public func withGtkError<R>(
    _ action: (UnsafeMutablePointer<UnsafeMutablePointer<GError>?>) -> R
) throws -> R {
    var errorPointer: UnsafeMutablePointer<GError>? = nil
    let result = action(&errorPointer)

    if let errorPointer = errorPointer {
        throw GtkError(from: errorPointer.pointee)
    } else {
        return result
    }
}
