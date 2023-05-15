//
//  Copyright © 2016 Tomas Linhart. All rights reserved.
//

import CGtk

public class Calendar: Widget {
    public override init() {
        super.init()

        widgetPointer = gtk_calendar_new()
    }

    public var year: Int {
        get {
            return getProperty(castedPointer(), name: "year")
        }
        set {
            setProperty(castedPointer(), name: "year", newValue: newValue)
        }
    }

    public var showHeading: Bool {
        get {
            return getProperty(castedPointer(), name: "show-heading")
        }
        set {
            setProperty(castedPointer(), name: "show-heading", newValue: newValue)
        }
    }
}
