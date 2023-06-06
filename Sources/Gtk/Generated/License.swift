import CGtk

/// The type of license for an application.
///
/// This enumeration can be expanded at later date.
public enum License: GValueRepresentableEnum {
    public typealias GtkEnum = GtkLicense

    /// No license specified
    case unknown
    /// A license text is going to be specified by the
    /// developer
    case custom
    /// The GNU General Public License, version 2.0 or later
    case gpl20
    /// The GNU General Public License, version 3.0 or later
    case gpl30
    /// The GNU Lesser General Public License, version 2.1 or later
    case lgpl21
    /// The GNU Lesser General Public License, version 3.0 or later
    case lgpl30
    /// The BSD standard license
    case bsd
    /// The MIT/X11 standard license
    case mitX11
    /// The Artistic License, version 2.0
    case artistic
    /// The GNU General Public License, version 2.0 only
    case gpl20Only
    /// The GNU General Public License, version 3.0 only
    case gpl30Only
    /// The GNU Lesser General Public License, version 2.1 only
    case lgpl21Only
    /// The GNU Lesser General Public License, version 3.0 only
    case lgpl30Only
    /// The GNU Affero General Public License, version 3.0 or later
    case agpl30
    /// The GNU Affero General Public License, version 3.0 only
    case agpl30Only
    /// The 3-clause BSD licence
    case bsd3
    /// The Apache License, version 2.0
    case apache20
    /// The Mozilla Public License, version 2.0
    case mpl20

    /// Converts a Gtk value to its corresponding swift representation.
    public init(from gtkEnum: GtkLicense) {
        switch gtkEnum {
            case GTK_LICENSE_UNKNOWN:
                self = .unknown
            case GTK_LICENSE_CUSTOM:
                self = .custom
            case GTK_LICENSE_GPL_2_0:
                self = .gpl20
            case GTK_LICENSE_GPL_3_0:
                self = .gpl30
            case GTK_LICENSE_LGPL_2_1:
                self = .lgpl21
            case GTK_LICENSE_LGPL_3_0:
                self = .lgpl30
            case GTK_LICENSE_BSD:
                self = .bsd
            case GTK_LICENSE_MIT_X11:
                self = .mitX11
            case GTK_LICENSE_ARTISTIC:
                self = .artistic
            case GTK_LICENSE_GPL_2_0_ONLY:
                self = .gpl20Only
            case GTK_LICENSE_GPL_3_0_ONLY:
                self = .gpl30Only
            case GTK_LICENSE_LGPL_2_1_ONLY:
                self = .lgpl21Only
            case GTK_LICENSE_LGPL_3_0_ONLY:
                self = .lgpl30Only
            case GTK_LICENSE_AGPL_3_0:
                self = .agpl30
            case GTK_LICENSE_AGPL_3_0_ONLY:
                self = .agpl30Only
            case GTK_LICENSE_BSD_3:
                self = .bsd3
            case GTK_LICENSE_APACHE_2_0:
                self = .apache20
            case GTK_LICENSE_MPL_2_0:
                self = .mpl20
            default:
                fatalError("Unsupported GtkLicense enum value: \(gtkEnum.rawValue)")
        }
    }

    /// Converts the value to its corresponding Gtk representation.
    public func toGtk() -> GtkLicense {
        switch self {
            case .unknown:
                return GTK_LICENSE_UNKNOWN
            case .custom:
                return GTK_LICENSE_CUSTOM
            case .gpl20:
                return GTK_LICENSE_GPL_2_0
            case .gpl30:
                return GTK_LICENSE_GPL_3_0
            case .lgpl21:
                return GTK_LICENSE_LGPL_2_1
            case .lgpl30:
                return GTK_LICENSE_LGPL_3_0
            case .bsd:
                return GTK_LICENSE_BSD
            case .mitX11:
                return GTK_LICENSE_MIT_X11
            case .artistic:
                return GTK_LICENSE_ARTISTIC
            case .gpl20Only:
                return GTK_LICENSE_GPL_2_0_ONLY
            case .gpl30Only:
                return GTK_LICENSE_GPL_3_0_ONLY
            case .lgpl21Only:
                return GTK_LICENSE_LGPL_2_1_ONLY
            case .lgpl30Only:
                return GTK_LICENSE_LGPL_3_0_ONLY
            case .agpl30:
                return GTK_LICENSE_AGPL_3_0
            case .agpl30Only:
                return GTK_LICENSE_AGPL_3_0_ONLY
            case .bsd3:
                return GTK_LICENSE_BSD_3
            case .apache20:
                return GTK_LICENSE_APACHE_2_0
            case .mpl20:
                return GTK_LICENSE_MPL_2_0
        }
    }
}
