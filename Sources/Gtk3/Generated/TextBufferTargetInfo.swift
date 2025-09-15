import CGtk3

/// These values are used as “info” for the targets contained in the
/// lists returned by gtk_text_buffer_get_copy_target_list() and
/// gtk_text_buffer_get_paste_target_list().
///
/// The values counts down from `-1` to avoid clashes
/// with application added drag destinations which usually start at 0.
public enum TextBufferTargetInfo: GValueRepresentableEnum {
    public typealias GtkEnum = GtkTextBufferTargetInfo

    /// Buffer contents
    case bufferContents
    /// Rich text
    case richText
    /// Text
    case text

    public static var type: GType {
        gtk_text_buffer_target_info_get_type()
    }

    public init(from gtkEnum: GtkTextBufferTargetInfo) {
        switch gtkEnum {
            case GTK_TEXT_BUFFER_TARGET_INFO_BUFFER_CONTENTS:
                self = .bufferContents
            case GTK_TEXT_BUFFER_TARGET_INFO_RICH_TEXT:
                self = .richText
            case GTK_TEXT_BUFFER_TARGET_INFO_TEXT:
                self = .text
            default:
                fatalError("Unsupported GtkTextBufferTargetInfo enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkTextBufferTargetInfo {
        switch self {
            case .bufferContents:
                return GTK_TEXT_BUFFER_TARGET_INFO_BUFFER_CONTENTS
            case .richText:
                return GTK_TEXT_BUFFER_TARGET_INFO_RICH_TEXT
            case .text:
                return GTK_TEXT_BUFFER_TARGET_INFO_TEXT
        }
    }
}
