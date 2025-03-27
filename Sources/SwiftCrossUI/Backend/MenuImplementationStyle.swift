/// How a backend implements popover menus.
///
/// Regardless of implementation style, backends are expected to implement
/// ``AppBackend/createPopoverMenu()``, ``AppBackend/updatePopoverMenu(_:content:environment:)``,
/// and ``AppBackend/updateButton(_:label:action:environment:)``.
public enum MenuImplementationStyle {
    /// The backend can show popover menus arbitrarily.
    ///
    /// Backends that use this style must implement
    /// ``AppBackend/showPopoverMenu(_:at:relativeTo:closeHandler:)``. For these backends,
    /// ``AppBackend/createPopoverMenu()`` is not called until after the button is tapped.
    case dynamicPopover
    /// The backend requires menus to be constructed and attached to buttons ahead-of-time.
    ///
    /// Backends that use this style must implement
    /// ``AppBackend/updateButton(_:label:menu:environment:)``.
    case menuButton
}
