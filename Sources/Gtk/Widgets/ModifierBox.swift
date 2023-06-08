import CGtk

/// Helper Box that uses GtkBox under the hood but only allows one child.
open class ModifierBox: Widget {
    public private(set) var child: Widget?

    public override init() {
        super.init()
        widgetPointer = gtk_box_new(Orientation.vertical.toGtkOrientation(), 0)
    }

    override func didMoveToParent() {
        update()
        child?.didMoveToParent()
    }

    /// Updates this box's orientation based on the firstNonModifierParent's box.
    /// This updates alignment values too, which fixes alignment issues with modifierbox
    /// inside a horizontal box.
    ///
    /// This currently only needs to be called from didMoveToParent because we don't allow
    /// boxes to change their orientation (eg HStack stays horizontal for its entire lifetime)
    private func update() {
        if let parent = firstNonModifierParent() as? Box {
            gtk_orientable_set_orientation(opaquePointer, parent.orientation.toGtkOrientation())
        }
    }

    /// This removes the previous child if it existed and shows the new child.
    ///
    /// When a child is set we copy its alignment to the box to make sure it fills/centers correctly.
    ///
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

extension Widget {
    /// Get the first parent that is not a ModifierBox
    public func firstNonModifierParent() -> Widget? {
        var firstNonModifierParent = parentWidget
        while let next = firstNonModifierParent as? ModifierBox {
            firstNonModifierParent = next.parentWidget
        }
        return firstNonModifierParent
    }
}
