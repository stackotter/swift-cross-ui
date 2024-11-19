//
//  Copyright © 2015 Tomas Linhart. All rights reserved.
//

open class Bin: Container {
    public func getChild() -> Widget? {
        widgets.last
    }
}
