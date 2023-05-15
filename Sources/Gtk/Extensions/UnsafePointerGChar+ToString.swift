//
//  Copyright © 2017 Tomas Linhart. All rights reserved.
//

import CGtk

extension UnsafePointer where Pointee == gchar {
    func toString() -> String {
        return String(cString: self)
    }
}
