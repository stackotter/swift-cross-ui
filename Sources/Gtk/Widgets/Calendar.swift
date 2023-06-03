//
//  Copyright © 2016 Tomas Linhart. All rights reserved.
//

import CGtk

public class Calendar: Widget {
    public override init() {
        super.init()

        widgetPointer = gtk_calendar_new()
    }

    @GObjectProperty(named: "year") public var year: Int

    @GObjectProperty(named: "show-heading") public var showHeading: Bool
}
