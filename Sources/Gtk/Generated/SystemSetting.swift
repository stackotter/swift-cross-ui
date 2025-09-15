import CGtk

/// Values that can be passed to the [vfunc@Gtk.Widget.system_setting_changed]
/// vfunc.
///
/// The values indicate which system setting has changed.
/// Widgets may need to drop caches, or react otherwise.
///
/// Most of the values correspond to [class@Settings] properties.
///
/// More values may be added over time.
public enum SystemSetting: GValueRepresentableEnum {
    public typealias GtkEnum = GtkSystemSetting

    /// The [property@Gtk.Settings:gtk-xft-dpi] setting has changed
    case dpi
    /// The [property@Gtk.Settings:gtk-font-name] setting has changed
    case fontName
    /// The font configuration has changed in a way that
    /// requires text to be redrawn. This can be any of the
    /// [property@Gtk.Settings:gtk-xft-antialias],
    /// [property@Gtk.Settings:gtk-xft-hinting],
    /// [property@Gtk.Settings:gtk-xft-hintstyle],
    /// [property@Gtk.Settings:gtk-xft-rgba] or
    /// [property@Gtk.Settings:gtk-fontconfig-timestamp] settings
    case fontConfig
    /// The display has changed
    case display
    /// The icon theme has changed in a way that requires
    /// icons to be looked up again
    case iconTheme

    public static var type: GType {
        gtk_system_setting_get_type()
    }

    public init(from gtkEnum: GtkSystemSetting) {
        switch gtkEnum {
            case GTK_SYSTEM_SETTING_DPI:
                self = .dpi
            case GTK_SYSTEM_SETTING_FONT_NAME:
                self = .fontName
            case GTK_SYSTEM_SETTING_FONT_CONFIG:
                self = .fontConfig
            case GTK_SYSTEM_SETTING_DISPLAY:
                self = .display
            case GTK_SYSTEM_SETTING_ICON_THEME:
                self = .iconTheme
            default:
                fatalError("Unsupported GtkSystemSetting enum value: \(gtkEnum.rawValue)")
        }
    }

    public func toGtk() -> GtkSystemSetting {
        switch self {
            case .dpi:
                return GTK_SYSTEM_SETTING_DPI
            case .fontName:
                return GTK_SYSTEM_SETTING_FONT_NAME
            case .fontConfig:
                return GTK_SYSTEM_SETTING_FONT_CONFIG
            case .display:
                return GTK_SYSTEM_SETTING_DISPLAY
            case .iconTheme:
                return GTK_SYSTEM_SETTING_ICON_THEME
        }
    }
}
