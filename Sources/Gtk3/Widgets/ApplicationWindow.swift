//
//  Copyright © 2015 Tomas Linhart. All rights reserved.
//

import CGtk3

public class ApplicationWindow: Window {
    public init(application: Application) {
        super.init()
        widgetPointer = gtk_application_window_new(application.applicationPointer)
    }
}
