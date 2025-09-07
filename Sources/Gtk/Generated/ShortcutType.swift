import CGtk

/// GtkShortcutType specifies the kind of shortcut that is being described.
///
/// More values may be added to this enumeration over time.
public enum ShortcutType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkShortcutType

    /// The shortcut is a keyboard accelerator. The GtkShortcutsShortcut:accelerator
    /// property will be used.
    case accelerator
    /// The shortcut is a pinch gesture. GTK provides an icon and subtitle.
    case gesturePinch
    /// The shortcut is a stretch gesture. GTK provides an icon and subtitle.
    case gestureStretch
    /// The shortcut is a clockwise rotation gesture. GTK provides an icon and subtitle.
    case gestureRotateClockwise
    /// The shortcut is a counterclockwise rotation gesture. GTK provides an icon and subtitle.
    case gestureRotateCounterclockwise
    /// The shortcut is a two-finger swipe gesture. GTK provides an icon and subtitle.
    case gestureTwoFingerSwipeLeft
    /// The shortcut is a two-finger swipe gesture. GTK provides an icon and subtitle.
    case gestureTwoFingerSwipeRight
    /// The shortcut is a gesture. The GtkShortcutsShortcut:icon property will be
    /// used.
    case gesture
    /// The shortcut is a swipe gesture. GTK provides an icon and subtitle.
    case gestureSwipeLeft
    /// The shortcut is a swipe gesture. GTK provides an icon and subtitle.
    case gestureSwipeRight

    public static var type: GType {
        gtk_shortcut_type_get_type()
    }

    public init(from gtkEnum: GtkShortcutType) {
        switch gtkEnum {
            case GTK_SHORTCUT_ACCELERATOR:
                self = .accelerator
            case GTK_SHORTCUT_GESTURE_PINCH:
                self = .gesturePinch
            case GTK_SHORTCUT_GESTURE_STRETCH:
                self = .gestureStretch
            case GTK_SHORTCUT_GESTURE_ROTATE_CLOCKWISE:
                self = .gestureRotateClockwise
            case GTK_SHORTCUT_GESTURE_ROTATE_COUNTERCLOCKWISE:
                self = .gestureRotateCounterclockwise
            case GTK_SHORTCUT_GESTURE_TWO_FINGER_SWIPE_LEFT:
                self = .gestureTwoFingerSwipeLeft
            case GTK_SHORTCUT_GESTURE_TWO_FINGER_SWIPE_RIGHT:
                self = .gestureTwoFingerSwipeRight
            case GTK_SHORTCUT_GESTURE:
                self = .gesture
            case GTK_SHORTCUT_GESTURE_SWIPE_LEFT:
                self = .gestureSwipeLeft
            case GTK_SHORTCUT_GESTURE_SWIPE_RIGHT:
                self = .gestureSwipeRight
            default:
                fatalError("Unsupported GtkShortcutType enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkShortcutType {
        switch self {
            case .accelerator:
                return GTK_SHORTCUT_ACCELERATOR
            case .gesturePinch:
                return GTK_SHORTCUT_GESTURE_PINCH
            case .gestureStretch:
                return GTK_SHORTCUT_GESTURE_STRETCH
            case .gestureRotateClockwise:
                return GTK_SHORTCUT_GESTURE_ROTATE_CLOCKWISE
            case .gestureRotateCounterclockwise:
                return GTK_SHORTCUT_GESTURE_ROTATE_COUNTERCLOCKWISE
            case .gestureTwoFingerSwipeLeft:
                return GTK_SHORTCUT_GESTURE_TWO_FINGER_SWIPE_LEFT
            case .gestureTwoFingerSwipeRight:
                return GTK_SHORTCUT_GESTURE_TWO_FINGER_SWIPE_RIGHT
            case .gesture:
                return GTK_SHORTCUT_GESTURE
            case .gestureSwipeLeft:
                return GTK_SHORTCUT_GESTURE_SWIPE_LEFT
            case .gestureSwipeRight:
                return GTK_SHORTCUT_GESTURE_SWIPE_RIGHT
        }
    }
}
