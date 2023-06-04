//
//  Copyright © 2016 Tomas Linhart. All rights reserved.
//

import CGtk

public class Calendar: Widget {
    public override init() {
        super.init()

        widgetPointer = gtk_calendar_new()
    }

    /// The selected year. This property gets initially set to the current year.
    @GObjectProperty(named: "year") public var year: Int
    /// Determines whether a heading is displayed.
    @GObjectProperty(named: "show-heading") public var showHeading: Bool
}
