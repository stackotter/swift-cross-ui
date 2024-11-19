//
//  Copyright © 2015 Tomas Linhart. All rights reserved.
//

import CGtk3

extension Label {
    public var lineWrapMode: WrapMode {
        get {
            return gtk_label_get_line_wrap_mode(castedPointer()).toWrapMode()
        }
        set {
            gtk_label_set_line_wrap_mode(castedPointer(), newValue.toPangoWrapMode())
        }
    }

    public var wrap: Bool {
        get {
            self.getProperty(named: "wrap")
        }
        set {
            self.setProperty(named: "wrap", newValue: newValue)
        }
    }
}
