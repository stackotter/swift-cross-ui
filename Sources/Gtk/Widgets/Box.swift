//
//  Copyright © 2015 Tomas Linhart. All rights reserved.
//

import CGtk

open class Box: Widget, Orientable {
    var widgets: [Widget] = []

    public override var prefersFill: Bool {
        return widgets.contains { widget in
            return widget.prefersFill
        }
    }

    public init(orientation: Orientation = .vertical, spacing: Int = 0) {
        super.init()

        widgetPointer = gtk_box_new(orientation.toGtkOrientation(), gint(spacing))
    }

    public func add(_ child: Widget) {
        widgets.append(child)
        child.parentWidget = self
        gtk_box_append(castedPointer(), child.widgetPointer)
    }

    public func remove(_ child: Widget) {
        if let index = widgets.firstIndex(where: { $0 === child }) {
            gtk_box_remove(castedPointer(), child.widgetPointer)
            widgets.remove(at: index)
            child.parentWidget = nil
        }
    }

    public func removeAll() {
        for widget in widgets {
            gtk_box_remove(castedPointer(), widget.widgetPointer)
            widget.parentWidget = nil
        }
        widgets = []
    }

    public var spacing: Int {
        get {
            Int(gtk_box_get_spacing(castedPointer()))
        }
        set {
            gtk_box_set_spacing(castedPointer(), gint(newValue))
        }
    }
}
