/// The launch behavior for a scene.
public enum SceneLaunchBehavior: Sendable {
    /// SwiftCrossUI decides whether to use ``presented`` or ``surpressed``
    /// depending on the type of scene.
    ///
    /// Currently, `presented` will be used for ``WindowGroup``, and
    /// `surpressed` will be used for ``Window``.
    case automatic
    /// The scene will be shown on app launch.
    case presented
    /// The scene will not be shown on app launch.
    case suppressed
}
