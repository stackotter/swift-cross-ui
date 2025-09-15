import CGtk3

/// Gives an indication why a drag operation failed.
/// The value can by obtained by connecting to the
/// #GtkWidget::drag-failed signal.
public enum DragResult: GValueRepresentableEnum {
    public typealias GtkEnum = GtkDragResult

    /// The drag operation was successful.
    case success
    /// No suitable drag target.
    case noTarget
    /// The user cancelled the drag operation.
    case userCancelled
    /// The drag operation timed out.
    case timeoutExpired
    /// The pointer or keyboard grab used
    /// for the drag operation was broken.
    case grabBroken
    /// The drag operation failed due to some
    /// unspecified error.
    case error

    public static var type: GType {
        gtk_drag_result_get_type()
    }

    public init(from gtkEnum: GtkDragResult) {
        switch gtkEnum {
            case GTK_DRAG_RESULT_SUCCESS:
                self = .success
            case GTK_DRAG_RESULT_NO_TARGET:
                self = .noTarget
            case GTK_DRAG_RESULT_USER_CANCELLED:
                self = .userCancelled
            case GTK_DRAG_RESULT_TIMEOUT_EXPIRED:
                self = .timeoutExpired
            case GTK_DRAG_RESULT_GRAB_BROKEN:
                self = .grabBroken
            case GTK_DRAG_RESULT_ERROR:
                self = .error
            default:
                fatalError("Unsupported GtkDragResult enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkDragResult {
        switch self {
            case .success:
                return GTK_DRAG_RESULT_SUCCESS
            case .noTarget:
                return GTK_DRAG_RESULT_NO_TARGET
            case .userCancelled:
                return GTK_DRAG_RESULT_USER_CANCELLED
            case .timeoutExpired:
                return GTK_DRAG_RESULT_TIMEOUT_EXPIRED
            case .grabBroken:
                return GTK_DRAG_RESULT_GRAB_BROKEN
            case .error:
                return GTK_DRAG_RESULT_ERROR
        }
    }
}
