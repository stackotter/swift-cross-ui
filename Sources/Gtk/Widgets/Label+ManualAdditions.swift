//
//  Copyright © 2015 Tomas Linhart. All rights reserved.
//

import CGtk

extension Label {
    public var lineWrapMode: WrapMode {
        get {
            return gtk_label_get_wrap_mode(opaquePointer).toWrapMode()
        }
        set {
            gtk_label_set_wrap_mode(opaquePointer, newValue.toPangoWrapMode())
        }
    }
}
