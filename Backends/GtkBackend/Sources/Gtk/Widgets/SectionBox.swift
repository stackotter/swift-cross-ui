/// A Box that applies its parent Box' padding and orientation as
/// it represents a section of the boxed widgets.
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
