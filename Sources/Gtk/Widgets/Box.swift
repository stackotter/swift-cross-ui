//
//  Copyright © 2015 Tomas Linhart. All rights reserved.
//

import CGtk

open class Box: Widget, Orientable {
    public var children: [Widget] = []

    public convenience init(orientation: Orientation = .vertical, spacing: Int = 0) {
        self.init(gtk_box_new(orientation.toGtk(), gint(spacing)))
    }

    open override func didMoveToParent() {
        for widget in children {
            widget.didMoveToParent()
        }
    }

    public func add(_ child: Widget) {
        children.append(child)
        child.parentWidget = self
        gtk_box_append(castedPointer(), child.widgetPointer)
    }

    public func remove(_ child: Widget) {
        if let index = children.firstIndex(where: { $0 === child }) {
            gtk_box_remove(castedPointer(), child.widgetPointer)
            children.remove(at: index)
            child.parentWidget = nil
        }
    }

    public func removeAll() {
        for widget in children {
            gtk_box_remove(castedPointer(), widget.widgetPointer)
            widget.parentWidget = nil
        }
        children = []
    }

    public func insert(child: Widget, after sibling: Widget) {
        gtk_box_insert_child_after(castedPointer(), child.widgetPointer, sibling.widgetPointer)
    }

    @GObjectProperty(named: "spacing") open var spacing: Int

    @GObjectProperty(named: "orientation") open var orientation: Orientation
}
