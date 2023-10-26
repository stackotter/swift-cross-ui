/// The layout orientation inherited by a widget from its nearest oriented parent.
public enum InheritedOrientation {
    /// The layout orientation used by the likes of ``VStack`` (the default for most containers).
    case vertical
    /// The layout orientation used by the likes of ``HStack``.
    case horizontal
}
