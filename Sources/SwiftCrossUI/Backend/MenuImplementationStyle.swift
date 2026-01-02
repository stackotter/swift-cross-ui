/// How a backend implements popover menus.
///
/// Regardless of implementation style, backends are expected to implement
/// ``AppBackend/createPopoverMenu()-9qdz1``,
/// ``AppBackend/updatePopoverMenu(_:content:environment:)-6cws8``, and
/// ``AppBackend/updateButton(_:label:environment:action:)-2n3zk``.
public enum MenuImplementationStyle {
    /// The backend can show popover menus arbitrarily.
    ///
    /// Backends that use this style must implement
    /// ``AppBackend/showPopoverMenu(_:at:relativeTo:closeHandler:)-3p1ct``. For
    /// these backends, ``AppBackend/createPopoverMenu()-9qdz1`` is not called
    /// until after the button is tapped.
    case dynamicPopover
    /// The backend requires menus to be constructed and attached to buttons
    /// ahead of time.
    ///
    /// Backends that use this style must implement
    /// ``AppBackend/updateButton(_:label:menu:environment:)-17ypq``.
    case menuButton
}
