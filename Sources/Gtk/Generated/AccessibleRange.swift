import CGtk

/// This interface describes ranged controls, e.g. controls which have a single
/// value within an allowed range and that can optionally be changed by the user.
///
/// This interface is expected to be implemented by controls using the following
/// roles:
///
/// - `GTK_ACCESSIBLE_ROLE_METER`
/// - `GTK_ACCESSIBLE_ROLE_PROGRESS_BAR`
/// - `GTK_ACCESSIBLE_ROLE_SCROLLBAR`
/// - `GTK_ACCESSIBLE_ROLE_SLIDER`
/// - `GTK_ACCESSIBLE_ROLE_SPIN_BUTTON`
///
/// If that is not the case, a warning will be issued at run time.
///
/// In addition to this interface, its implementors are expected to provide the
/// correct values for the following properties:
///
/// - `GTK_ACCESSIBLE_PROPERTY_VALUE_MAX`
/// - `GTK_ACCESSIBLE_PROPERTY_VALUE_MIN`
/// - `GTK_ACCESSIBLE_PROPERTY_VALUE_NOW`
/// - `GTK_ACCESSIBLE_PROPERTY_VALUE_TEXT`
public protocol AccessibleRange: GObjectRepresentable {

}
