public enum MenuOrder: Hashable, Sendable {
    /// The automatic behavior.
    case automatic
    /// Sorts items so the first item is closest to where the user opened the menu from.
    case priority
    /// Sorts items in the order given.
    case fixed
}
