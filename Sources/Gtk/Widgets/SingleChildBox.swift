import CGtk

/// Helper Box that uses GtkBox under the hood but only allows one child. It returns its parents orientation.
open class SingleChildBox: Widget, Orientable {
    var child: Widget?

    public override init() {
        super.init()
        widgetPointer = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0)
    }

    /// This gets and sets the orientation of the parentWidget.
    ///
    /// Some parents are not Orientable (ScrollableWindow, Window, Viewport, Stack) in which case
    /// this does nothing.
    public var orientation: Orientation {
        get {
            (parentWidget as? Orientable)?.orientation ?? .vertical
        }
        set {
            (parentWidget as? Orientable)?.orientation = newValue
        }
    }

    public override var prefersFill: Bool {
        return child?.prefersFill ?? false
    }

    /// This removes the previous child if it existed and shows the new child.
    /// - Parameter newChild: The child to show, use `nil` to remove previous child.
    public func setChild(_ newChild: Widget?) {
        if let child {
            gtk_box_remove(castedPointer(), child.widgetPointer)
            child.parentWidget = nil
            self.child = nil
        }

        if let newChild {
            self.child = newChild
            newChild.parentWidget = self
            gtk_box_append(castedPointer(), newChild.widgetPointer)
        }
    }
}
