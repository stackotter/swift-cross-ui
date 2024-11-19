//
//  Copyright © 2015 Tomas Linhart. All rights reserved.
//

open class Bin: Container {
    public var child: Widget?

    public func setChild(to widget: Widget) {
        if let child {
            remove(child)
        }
        self.child = widget
        add(widget)
    }
}
