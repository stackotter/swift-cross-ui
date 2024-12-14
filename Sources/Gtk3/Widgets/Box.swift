//
//  Copyright © 2015 Tomas Linhart. All rights reserved.
//

import CGtk3

open class Box: Widget, Orientable {
    public var children: [Widget] = []

    public convenience init(
        orientation: Orientation = .vertical,
        spacing: Int = 0
    ) {
        self.init(gtk_box_new(orientation.toGtk(), gint(spacing)))
    }

    override func didMoveToParent() {
        for widget in children {
            widget.didMoveToParent()
        }
    }

    public func add(_ child: Widget) {
        children.append(child)
        child.parentWidget = self
        gtk_container_add(castedPointer(), child.widgetPointer)
    }

    public func remove(_ child: Widget) {
        if let index = children.firstIndex(where: { $0 === child }) {
            gtk_container_remove(castedPointer(), child.widgetPointer)
            children.remove(at: index)
            child.parentWidget = nil
        }
    }

    public func removeAll() {
        for child in children {
            gtk_container_remove(castedPointer(), child.widgetPointer)
            child.parentWidget = nil
        }
        children = []
    }

    @GObjectProperty(named: "spacing") open var spacing: Int

    @GObjectProperty(named: "orientation") open var orientation: Orientation
}
