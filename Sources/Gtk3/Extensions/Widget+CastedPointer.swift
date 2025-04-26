//
//  Copyright © 2017 Tomas Linhart. All rights reserved.
//

import Foundation

extension Widget {
    public func castedPointer<T>() -> UnsafeMutablePointer<T> {
        return widgetPointer.cast()
    }
}
