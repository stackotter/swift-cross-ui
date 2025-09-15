import CGtk

/// Describes primary purpose of the input widget.
///
/// This information is useful for on-screen keyboards and similar input
/// methods to decide which keys should be presented to the user.
///
/// Note that the purpose is not meant to impose a totally strict rule
/// about allowed characters, and does not replace input validation.
/// It is fine for an on-screen keyboard to let the user override the
/// character set restriction that is expressed by the purpose. The
/// application is expected to validate the entry contents, even if
/// it specified a purpose.
///
/// The difference between %GTK_INPUT_PURPOSE_DIGITS and
/// %GTK_INPUT_PURPOSE_NUMBER is that the former accepts only digits
/// while the latter also some punctuation (like commas or points, plus,
/// minus) and “e” or “E” as in 3.14E+000.
///
/// This enumeration may be extended in the future; input methods should
/// interpret unknown values as “free form”.
public enum InputPurpose: GValueRepresentableEnum {
    public typealias GtkEnum = GtkInputPurpose

    /// Allow any character
    case freeForm
    /// Allow only alphabetic characters
    case alpha
    /// Allow only digits
    case digits
    /// Edited field expects numbers
    case number
    /// Edited field expects phone number
    case phone
    /// Edited field expects URL
    case url
    /// Edited field expects email address
    case email
    /// Edited field expects the name of a person
    case name
    /// Like %GTK_INPUT_PURPOSE_FREE_FORM, but characters are hidden
    case password
    /// Like %GTK_INPUT_PURPOSE_DIGITS, but characters are hidden
    case pin
    /// Allow any character, in addition to control codes
    case terminal

    public static var type: GType {
        gtk_input_purpose_get_type()
    }

    public init(from gtkEnum: GtkInputPurpose) {
        switch gtkEnum {
            case GTK_INPUT_PURPOSE_FREE_FORM:
                self = .freeForm
            case GTK_INPUT_PURPOSE_ALPHA:
                self = .alpha
            case GTK_INPUT_PURPOSE_DIGITS:
                self = .digits
            case GTK_INPUT_PURPOSE_NUMBER:
                self = .number
            case GTK_INPUT_PURPOSE_PHONE:
                self = .phone
            case GTK_INPUT_PURPOSE_URL:
                self = .url
            case GTK_INPUT_PURPOSE_EMAIL:
                self = .email
            case GTK_INPUT_PURPOSE_NAME:
                self = .name
            case GTK_INPUT_PURPOSE_PASSWORD:
                self = .password
            case GTK_INPUT_PURPOSE_PIN:
                self = .pin
            case GTK_INPUT_PURPOSE_TERMINAL:
                self = .terminal
            default:
                fatalError("Unsupported GtkInputPurpose enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkInputPurpose {
        switch self {
            case .freeForm:
                return GTK_INPUT_PURPOSE_FREE_FORM
            case .alpha:
                return GTK_INPUT_PURPOSE_ALPHA
            case .digits:
                return GTK_INPUT_PURPOSE_DIGITS
            case .number:
                return GTK_INPUT_PURPOSE_NUMBER
            case .phone:
                return GTK_INPUT_PURPOSE_PHONE
            case .url:
                return GTK_INPUT_PURPOSE_URL
            case .email:
                return GTK_INPUT_PURPOSE_EMAIL
            case .name:
                return GTK_INPUT_PURPOSE_NAME
            case .password:
                return GTK_INPUT_PURPOSE_PASSWORD
            case .pin:
                return GTK_INPUT_PURPOSE_PIN
            case .terminal:
                return GTK_INPUT_PURPOSE_TERMINAL
        }
    }
}
