/// Builds an app's root scene by composing other scenes together.
@resultBuilder
public struct SceneBuilder {
    /// A single scene doesn't need to get wrapped, simply pass it straight through.
    public static func buildBlock<Content: Scene>(_ content: Content) -> Content {
        return content
    }

    public static func buildBlock<S0: Scene, S1: Scene>(
        _ scene0: S0, _ scene1: S1
    ) -> TupleScene2<S0, S1> {
        return TupleScene2(scene0, scene1)
    }
}
