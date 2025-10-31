import CGtk
import Foundation

public class GDateTime {
    public let pointer: OpaquePointer

    public init(_ pointer: OpaquePointer) {
        self.pointer = pointer
    }

    public init?(_ pointer: OpaquePointer?) {
        guard let pointer else { return nil }
        self.pointer = pointer
    }

    public convenience init?(unixEpoch: Int) {
        // g_date_time_new_from_unix_utc_usec appears to be too new
        self.init(g_date_time_new_from_unix_utc(gint64(unixEpoch)))
    }

    public convenience init?(
        timeZone: GTimeZone,
        year: Int,
        month: Int,
        day: Int,
        hour: Int,
        minute: Int,
        second: Double
    ) {
        self.init(
            g_date_time_new(
                timeZone.pointer,
                gint(year),
                gint(month),
                gint(day),
                gint(hour),
                gint(minute),
                second
            )
        )
    }

    /// Create a UTC-based GDateTime from a Foundation Date, discarding fractional seconds.
    public convenience init!(_ date: Date) {
        self.init(unixEpoch: Int(date.timeIntervalSince1970))
    }

    deinit {
        g_date_time_unref(pointer)
    }

    public func toDate() -> Date {
        let offset = g_date_time_to_unix(pointer)
        return Date(timeIntervalSince1970: Double(offset))
    }
}
