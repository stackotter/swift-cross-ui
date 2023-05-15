import CGtk

/// GtkShortcutType specifies the kind of shortcut that is being described. More values may be added to this enumeration over time.
/// 
/// [Gtk docs](https://docs.gtk.org/gtk3/enum.ShortcutType.html)
public enum ShortcutType {
    /// The shortcut is a keyboard accelerator. The `GtkShortcutsShortcut:accelerator` property will be used.
    case accelerator
    /// The shortcut is a pinch gesture. GTK+ provides an icon and subtitle.
    case gesturePinch
    /// The shortcut is a stretch gesture. GTK+ provides an icon and subtitle.
    case gestureStretch
    /// The shortcut is a clockwise rotation gesture. GTK+ provides an icon and subtitle.
    case gestureRotateClockwise
    /// The shortcut is a counterclockwise rotation gesture. GTK+ provides an icon and subtitle.
    case gestureRotateCounterClockwise
    /// The shortcut is a two-finger swipe gesture. GTK+ provides an icon and subtitle.
    case gestureTwoFingerSwipeLeft
    /// The shortcut is a two-finger swipe gesture. GTK+ provides an icon and subtitle.
    case gestureTwoFingerSwipeRight
    /// The shortcut is a gesture. The GtkShortcutsShortcut:icon property will be used.
    case gesture

    func toGtkShortcutType() -> GtkShortcutType {
        switch self {
        case .accelerator:
            return GTK_SHORTCUT_ACCELERATOR
        case .gesturePinch:
            return GTK_SHORTCUT_GESTURE_PINCH
        case .gestureStretch:
            return GTK_SHORTCUT_GESTURE_STRETCH
        case .gestureRotateClockwise:
            return GTK_SHORTCUT_GESTURE_ROTATE_CLOCKWISE
        case .gestureRotateCounterClockwise:
            return GTK_SHORTCUT_GESTURE_ROTATE_COUNTERCLOCKWISE
        case .gestureTwoFingerSwipeLeft:
            return GTK_SHORTCUT_GESTURE_TWO_FINGER_SWIPE_LEFT
        case .gestureTwoFingerSwipeRight:
            return GTK_SHORTCUT_GESTURE_TWO_FINGER_SWIPE_RIGHT
        case .gesture:
            return GTK_SHORTCUT_GESTURE
        }
    }
}

extension GtkShortcutType {
    func toShortcutType() -> ShortcutType {
        switch self {
        case GTK_SHORTCUT_ACCELERATOR:
            return .accelerator
        case GTK_SHORTCUT_GESTURE_PINCH:
            return .gesturePinch
        case GTK_SHORTCUT_GESTURE_STRETCH:
            return .gestureStretch
        case GTK_SHORTCUT_GESTURE_ROTATE_CLOCKWISE:
            return .gestureRotateClockwise
        case GTK_SHORTCUT_GESTURE_ROTATE_COUNTERCLOCKWISE:
            return .gestureRotateCounterClockwise
        case GTK_SHORTCUT_GESTURE_TWO_FINGER_SWIPE_LEFT:
            return .gestureTwoFingerSwipeLeft
        case GTK_SHORTCUT_GESTURE_TWO_FINGER_SWIPE_RIGHT:
            return .gestureTwoFingerSwipeRight
        case GTK_SHORTCUT_GESTURE:
            return .gesture
        default:
            fatalError("Unsupported GtkShortcutType enum value: \(self.rawValue)")
        }
    }
}
