import CGtk

/// The type of license for an application.
///
/// This enumeration can be expanded at later date.
public enum License {
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

    /// Converts the value to its corresponding Gtk representation.
    func toGtkLicense() -> GtkLicense {
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

extension GtkLicense {
    /// Converts a Gtk value to its corresponding swift representation.
    func toLicense() -> License {
        switch self {
            case GTK_LICENSE_UNKNOWN:
                return .unknown
            case GTK_LICENSE_CUSTOM:
                return .custom
            case GTK_LICENSE_GPL_2_0:
                return .gpl20
            case GTK_LICENSE_GPL_3_0:
                return .gpl30
            case GTK_LICENSE_LGPL_2_1:
                return .lgpl21
            case GTK_LICENSE_LGPL_3_0:
                return .lgpl30
            case GTK_LICENSE_BSD:
                return .bsd
            case GTK_LICENSE_MIT_X11:
                return .mitX11
            case GTK_LICENSE_ARTISTIC:
                return .artistic
            case GTK_LICENSE_GPL_2_0_ONLY:
                return .gpl20Only
            case GTK_LICENSE_GPL_3_0_ONLY:
                return .gpl30Only
            case GTK_LICENSE_LGPL_2_1_ONLY:
                return .lgpl21Only
            case GTK_LICENSE_LGPL_3_0_ONLY:
                return .lgpl30Only
            case GTK_LICENSE_AGPL_3_0:
                return .agpl30
            case GTK_LICENSE_AGPL_3_0_ONLY:
                return .agpl30Only
            case GTK_LICENSE_BSD_3:
                return .bsd3
            case GTK_LICENSE_APACHE_2_0:
                return .apache20
            case GTK_LICENSE_MPL_2_0:
                return .mpl20
            default:
                fatalError("Unsupported GtkLicense enum value: \(self.rawValue)")
        }
    }
}
