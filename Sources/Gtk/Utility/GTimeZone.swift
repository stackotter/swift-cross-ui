import CGtk
import Foundation

public final class GTimeZone {
    public let pointer: OpaquePointer

    public init?(identifier: String) {
        guard let pointer = g_time_zone_new_identifier(identifier) else { return nil }
        self.pointer = pointer
    }

    public convenience init?(_ timeZone: TimeZone) {
        self.init(identifier: timeZone.identifier)
    }

    deinit {
        g_time_zone_unref(pointer)
    }
}
