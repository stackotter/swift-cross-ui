/// Builds an app's root scene by composing other scenes together.
@resultBuilder
public struct SceneBuilder {
    /// A single scene doesn't need to get wrapped, simply pass it straight through.
    public static func buildBlock<Content: Scene>(_ content: Content) -> Content {
        return content
    }
}
