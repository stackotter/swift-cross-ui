import CGtk3

/// The #GtkRcTokenType enumeration represents the tokens
/// in the RC file. It is exposed so that theme engines
/// can reuse these tokens when parsing the theme-engine
/// specific portions of a RC file.
public enum RcTokenType: GValueRepresentableEnum {
    public typealias GtkEnum = GtkRcTokenType

    /// Deprecated
    case invalid
    /// Deprecated
    case include
    /// Deprecated
    case normal
    /// Deprecated
    case active
    /// Deprecated
    case prelight
    /// Deprecated
    case selected
    /// Deprecated
    case insensitive
    /// Deprecated
    case fg
    /// Deprecated
    case bg
    /// Deprecated
    case text
    /// Deprecated
    case base
    /// Deprecated
    case xthickness
    /// Deprecated
    case ythickness
    /// Deprecated
    case font
    /// Deprecated
    case fontset
    /// Deprecated
    case fontName
    /// Deprecated
    case bgPixmap
    /// Deprecated
    case pixmapPath
    /// Deprecated
    case style
    /// Deprecated
    case binding
    /// Deprecated
    case bind
    /// Deprecated
    case widget
    /// Deprecated
    case widgetClass
    /// Deprecated
    case class_
    /// Deprecated
    case lowest
    /// Deprecated
    case gtk
    /// Deprecated
    case application
    /// Deprecated
    case theme
    /// Deprecated
    case rc
    /// Deprecated
    case highest
    /// Deprecated
    case engine
    /// Deprecated
    case modulePath
    /// Deprecated
    case imModulePath
    /// Deprecated
    case imModuleFile
    /// Deprecated
    case stock
    /// Deprecated
    case ltr
    /// Deprecated
    case rtl
    /// Deprecated
    case color
    /// Deprecated
    case unbind
    /// Deprecated
    case last

    public static var type: GType {
        gtk_rc_token_type_get_type()
    }

    public init(from gtkEnum: GtkRcTokenType) {
        switch gtkEnum {
            case GTK_RC_TOKEN_INVALID:
                self = .invalid
            case GTK_RC_TOKEN_INCLUDE:
                self = .include
            case GTK_RC_TOKEN_NORMAL:
                self = .normal
            case GTK_RC_TOKEN_ACTIVE:
                self = .active
            case GTK_RC_TOKEN_PRELIGHT:
                self = .prelight
            case GTK_RC_TOKEN_SELECTED:
                self = .selected
            case GTK_RC_TOKEN_INSENSITIVE:
                self = .insensitive
            case GTK_RC_TOKEN_FG:
                self = .fg
            case GTK_RC_TOKEN_BG:
                self = .bg
            case GTK_RC_TOKEN_TEXT:
                self = .text
            case GTK_RC_TOKEN_BASE:
                self = .base
            case GTK_RC_TOKEN_XTHICKNESS:
                self = .xthickness
            case GTK_RC_TOKEN_YTHICKNESS:
                self = .ythickness
            case GTK_RC_TOKEN_FONT:
                self = .font
            case GTK_RC_TOKEN_FONTSET:
                self = .fontset
            case GTK_RC_TOKEN_FONT_NAME:
                self = .fontName
            case GTK_RC_TOKEN_BG_PIXMAP:
                self = .bgPixmap
            case GTK_RC_TOKEN_PIXMAP_PATH:
                self = .pixmapPath
            case GTK_RC_TOKEN_STYLE:
                self = .style
            case GTK_RC_TOKEN_BINDING:
                self = .binding
            case GTK_RC_TOKEN_BIND:
                self = .bind
            case GTK_RC_TOKEN_WIDGET:
                self = .widget
            case GTK_RC_TOKEN_WIDGET_CLASS:
                self = .widgetClass
            case GTK_RC_TOKEN_CLASS:
                self = .class_
            case GTK_RC_TOKEN_LOWEST:
                self = .lowest
            case GTK_RC_TOKEN_GTK:
                self = .gtk
            case GTK_RC_TOKEN_APPLICATION:
                self = .application
            case GTK_RC_TOKEN_THEME:
                self = .theme
            case GTK_RC_TOKEN_RC:
                self = .rc
            case GTK_RC_TOKEN_HIGHEST:
                self = .highest
            case GTK_RC_TOKEN_ENGINE:
                self = .engine
            case GTK_RC_TOKEN_MODULE_PATH:
                self = .modulePath
            case GTK_RC_TOKEN_IM_MODULE_PATH:
                self = .imModulePath
            case GTK_RC_TOKEN_IM_MODULE_FILE:
                self = .imModuleFile
            case GTK_RC_TOKEN_STOCK:
                self = .stock
            case GTK_RC_TOKEN_LTR:
                self = .ltr
            case GTK_RC_TOKEN_RTL:
                self = .rtl
            case GTK_RC_TOKEN_COLOR:
                self = .color
            case GTK_RC_TOKEN_UNBIND:
                self = .unbind
            case GTK_RC_TOKEN_LAST:
                self = .last
            default:
                fatalError("Unsupported GtkRcTokenType enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkRcTokenType {
        switch self {
            case .invalid:
                return GTK_RC_TOKEN_INVALID
            case .include:
                return GTK_RC_TOKEN_INCLUDE
            case .normal:
                return GTK_RC_TOKEN_NORMAL
            case .active:
                return GTK_RC_TOKEN_ACTIVE
            case .prelight:
                return GTK_RC_TOKEN_PRELIGHT
            case .selected:
                return GTK_RC_TOKEN_SELECTED
            case .insensitive:
                return GTK_RC_TOKEN_INSENSITIVE
            case .fg:
                return GTK_RC_TOKEN_FG
            case .bg:
                return GTK_RC_TOKEN_BG
            case .text:
                return GTK_RC_TOKEN_TEXT
            case .base:
                return GTK_RC_TOKEN_BASE
            case .xthickness:
                return GTK_RC_TOKEN_XTHICKNESS
            case .ythickness:
                return GTK_RC_TOKEN_YTHICKNESS
            case .font:
                return GTK_RC_TOKEN_FONT
            case .fontset:
                return GTK_RC_TOKEN_FONTSET
            case .fontName:
                return GTK_RC_TOKEN_FONT_NAME
            case .bgPixmap:
                return GTK_RC_TOKEN_BG_PIXMAP
            case .pixmapPath:
                return GTK_RC_TOKEN_PIXMAP_PATH
            case .style:
                return GTK_RC_TOKEN_STYLE
            case .binding:
                return GTK_RC_TOKEN_BINDING
            case .bind:
                return GTK_RC_TOKEN_BIND
            case .widget:
                return GTK_RC_TOKEN_WIDGET
            case .widgetClass:
                return GTK_RC_TOKEN_WIDGET_CLASS
            case .class_:
                return GTK_RC_TOKEN_CLASS
            case .lowest:
                return GTK_RC_TOKEN_LOWEST
            case .gtk:
                return GTK_RC_TOKEN_GTK
            case .application:
                return GTK_RC_TOKEN_APPLICATION
            case .theme:
                return GTK_RC_TOKEN_THEME
            case .rc:
                return GTK_RC_TOKEN_RC
            case .highest:
                return GTK_RC_TOKEN_HIGHEST
            case .engine:
                return GTK_RC_TOKEN_ENGINE
            case .modulePath:
                return GTK_RC_TOKEN_MODULE_PATH
            case .imModulePath:
                return GTK_RC_TOKEN_IM_MODULE_PATH
            case .imModuleFile:
                return GTK_RC_TOKEN_IM_MODULE_FILE
            case .stock:
                return GTK_RC_TOKEN_STOCK
            case .ltr:
                return GTK_RC_TOKEN_LTR
            case .rtl:
                return GTK_RC_TOKEN_RTL
            case .color:
                return GTK_RC_TOKEN_COLOR
            case .unbind:
                return GTK_RC_TOKEN_UNBIND
            case .last:
                return GTK_RC_TOKEN_LAST
        }
    }
}
