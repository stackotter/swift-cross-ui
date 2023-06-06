//
//  Copyright © 2015 Tomas Linhart. All rights reserved.
//

import CGtk

open class Stack: Widget {
    private var pages = [Widget]()

    public init(transitionDuration: Int, transitionType: StackTransitionType) {
        super.init()

        widgetPointer = gtk_stack_new()

        self.transitionDuration = transitionDuration
        self.transitionType = transitionType
    }

    /// Transition duration in milliseconds
    @GObjectProperty(named: "transition-duration") public var transitionDuration: Int

    /// Transition type
    public var transitionType: StackTransitionType {
        get {
            return gtk_stack_get_transition_type(opaquePointer).toStackTransitionType()
        }
        set {
            gtk_stack_set_transition_type(opaquePointer, newValue.toGtkStackTransitionType())
        }
    }

    public func add(_ child: Widget, named name: String, title: String? = nil) {
        pages.append(child)
        child.parentWidget = self
        if let title {
            gtk_stack_add_titled(opaquePointer, child.castedPointer(), name, title)
        } else {
            gtk_stack_add_named(opaquePointer, child.castedPointer(), name)
        }
    }

    public func remove(_ child: Widget) {
        if let index = pages.lastIndex(where: { $0 === child }) {
            gtk_stack_remove(opaquePointer, child.castedPointer())
            pages.remove(at: index)
            child.parentWidget = nil
        }
    }

    public func setVisible(_ child: Widget) {
        if pages.contains(where: { $0 === child }) {
            gtk_stack_set_visible_child(opaquePointer, child.castedPointer())
        }
    }
}
