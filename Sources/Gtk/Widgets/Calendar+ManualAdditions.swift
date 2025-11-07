import CGtk
import Foundation

extension Calendar {
    public var date: Date {
        get {
            GDateTime(gtk_calendar_get_date(opaquePointer)).toDate()
        }
        set {
            withExtendedLifetime(GDateTime(newValue)) { gDateTime in
                gtk_calendar_select_day(opaquePointer, gDateTime.pointer)
            }
        }
    }
}
