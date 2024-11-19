//
//  Copyright © 2015 Tomas Linhart. All rights reserved.
//

import CGtk3

open class Container: Widget {
    var widgets: [Widget] = []

    public func add(_ widget: Widget) {
        widgets.append(widget)
        widget.parentWidget = self
        gtk_container_add(castedPointer(), widget.widgetPointer)
    }

    public func remove(_ widget: Widget) {
        if let index = widgets.firstIndex(where: { $0 === widget }) {
            gtk_container_remove(castedPointer(), widget.widgetPointer)
            widgets.remove(at: index)
            widget.parentWidget = nil
        }
    }

    public func removeAll() {
        var list = gtk_container_get_children(castedPointer())
        while let node = list {
            let widget = node.pointee.data.assumingMemoryBound(to: GtkWidget.self)
            gtk_container_remove(castedPointer(), widget)
            list = node.pointee.next
        }
    }
}
