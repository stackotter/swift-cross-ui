//
//  Copyright © 2015 Tomas Linhart. All rights reserved.
//

import CGtk

open class Box: Widget, Orientable {
    var widgets: [Widget] = []

    public init(orientation: Orientation = .vertical, spacing: Int = 0) {
        super.init()

        widgetPointer = gtk_box_new(orientation.toGtkOrientation(), gint(spacing))
    }

    override func didMoveToParent() {
        for widget in widgets {
            widget.didMoveToParent()
        }
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

    @GObjectProperty(named: "spacing") open var spacing: Int

    open var orientation: Orientation {
        get { gtk_orientable_get_orientation(opaquePointer).toOrientation() }
        set { gtk_orientable_set_orientation(opaquePointer, newValue.toGtkOrientation()) }
    }
}

/// A Box that applies its parent Box' padding and orientation
public class SectionBox: Box {
    override func didMoveToParent() {
        update()
        super.didMoveToParent()
    }

    /// Get the first parent that is not a ModifierBox (view modifier, EitherView or OptionalView)
    /// and copy its orientation and spacing if it is a Box (HStack, VStack, ViewContent or ForEach)
    ///
    /// Needs to be called on View update as spacing might have changed. Maybe we can
    /// do observing for this in the future so this won't have to be called?
    public func update() {
        spacing = spacing
        orientation = orientation
    }

    override public var spacing: Int {
        get { (firstNonModifierParent() as? Box)?.spacing ?? super.spacing }
        set { super.spacing = newValue }
    }

    override public var orientation: Orientation {
        get { (firstNonModifierParent() as? Box)?.orientation ?? super.orientation }
        set { super.orientation = newValue }
    }
}
