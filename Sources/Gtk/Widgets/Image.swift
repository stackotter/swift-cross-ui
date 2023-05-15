//
//  Copyright © 2016 Tomas Linhart. All rights reserved.
//

import CGtk

public class Image: Widget {
    public init(path: String) {
        super.init()

        widgetPointer = gtk_image_new_from_file(path)
    }

    public func setPath(_ path: String) {
        gtk_image_set_from_file(opaquePointer, path)
    }
}
