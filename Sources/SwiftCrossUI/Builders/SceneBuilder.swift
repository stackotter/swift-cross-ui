/// Builds an app's root scene by composing other scenes together.
@resultBuilder
public struct SceneBuilder {
    /// A single scene doesn't need to get wrapped, simply pass it straight through.
    public static func buildBlock<Content: Scene>(_ content: Content) -> Content {
        return content
    }

    public static func buildBlock<
        Scene0: Scene,
        Scene1: Scene
    >(
        _ scene0: Scene0,
        _ scene1: Scene1
    ) -> TupleScene2<
        Scene0,
        Scene1
    > {
        return TupleScene2(
            scene0,
            scene1
        )
    }

    public static func buildBlock<
        Scene0: Scene,
        Scene1: Scene,
        Scene2: Scene
    >(
        _ scene0: Scene0,
        _ scene1: Scene1,
        _ scene2: Scene2
    ) -> TupleScene3<
        Scene0,
        Scene1,
        Scene2
    > {
        return TupleScene3(
            scene0,
            scene1,
            scene2
        )
    }

    public static func buildBlock<
        Scene0: Scene,
        Scene1: Scene,
        Scene2: Scene,
        Scene3: Scene
    >(
        _ scene0: Scene0,
        _ scene1: Scene1,
        _ scene2: Scene2,
        _ scene3: Scene3
    ) -> TupleScene4<
        Scene0,
        Scene1,
        Scene2,
        Scene3
    > {
        return TupleScene4(
            scene0,
            scene1,
            scene2,
            scene3
        )
    }

    public static func buildBlock<
        Scene0: Scene,
        Scene1: Scene,
        Scene2: Scene,
        Scene3: Scene,
        Scene4: Scene
    >(
        _ scene0: Scene0,
        _ scene1: Scene1,
        _ scene2: Scene2,
        _ scene3: Scene3,
        _ scene4: Scene4
    ) -> TupleScene5<
        Scene0,
        Scene1,
        Scene2,
        Scene3,
        Scene4
    > {
        return TupleScene5(
            scene0,
            scene1,
            scene2,
            scene3,
            scene4
        )
    }

    public static func buildBlock<
        Scene0: Scene,
        Scene1: Scene,
        Scene2: Scene,
        Scene3: Scene,
        Scene4: Scene,
        Scene5: Scene
    >(
        _ scene0: Scene0,
        _ scene1: Scene1,
        _ scene2: Scene2,
        _ scene3: Scene3,
        _ scene4: Scene4,
        _ scene5: Scene5
    ) -> TupleScene6<
        Scene0,
        Scene1,
        Scene2,
        Scene3,
        Scene4,
        Scene5
    > {
        return TupleScene6(
            scene0,
            scene1,
            scene2,
            scene3,
            scene4,
            scene5
        )
    }

    public static func buildBlock<
        Scene0: Scene,
        Scene1: Scene,
        Scene2: Scene,
        Scene3: Scene,
        Scene4: Scene,
        Scene5: Scene,
        Scene6: Scene
    >(
        _ scene0: Scene0,
        _ scene1: Scene1,
        _ scene2: Scene2,
        _ scene3: Scene3,
        _ scene4: Scene4,
        _ scene5: Scene5,
        _ scene6: Scene6
    ) -> TupleScene7<
        Scene0,
        Scene1,
        Scene2,
        Scene3,
        Scene4,
        Scene5,
        Scene6
    > {
        return TupleScene7(
            scene0,
            scene1,
            scene2,
            scene3,
            scene4,
            scene5,
            scene6
        )
    }

    public static func buildBlock<
        Scene0: Scene,
        Scene1: Scene,
        Scene2: Scene,
        Scene3: Scene,
        Scene4: Scene,
        Scene5: Scene,
        Scene6: Scene,
        Scene7: Scene
    >(
        _ scene0: Scene0,
        _ scene1: Scene1,
        _ scene2: Scene2,
        _ scene3: Scene3,
        _ scene4: Scene4,
        _ scene5: Scene5,
        _ scene6: Scene6,
        _ scene7: Scene7
    ) -> TupleScene8<
        Scene0,
        Scene1,
        Scene2,
        Scene3,
        Scene4,
        Scene5,
        Scene6,
        Scene7
    > {
        return TupleScene8(
            scene0,
            scene1,
            scene2,
            scene3,
            scene4,
            scene5,
            scene6,
            scene7
        )
    }

    public static func buildBlock<
        Scene0: Scene,
        Scene1: Scene,
        Scene2: Scene,
        Scene3: Scene,
        Scene4: Scene,
        Scene5: Scene,
        Scene6: Scene,
        Scene7: Scene,
        Scene8: Scene
    >(
        _ scene0: Scene0,
        _ scene1: Scene1,
        _ scene2: Scene2,
        _ scene3: Scene3,
        _ scene4: Scene4,
        _ scene5: Scene5,
        _ scene6: Scene6,
        _ scene7: Scene7,
        _ scene8: Scene8
    ) -> TupleScene9<
        Scene0,
        Scene1,
        Scene2,
        Scene3,
        Scene4,
        Scene5,
        Scene6,
        Scene7,
        Scene8
    > {
        return TupleScene9(
            scene0,
            scene1,
            scene2,
            scene3,
            scene4,
            scene5,
            scene6,
            scene7,
            scene8
        )
    }

    public static func buildBlock<
        Scene0: Scene,
        Scene1: Scene,
        Scene2: Scene,
        Scene3: Scene,
        Scene4: Scene,
        Scene5: Scene,
        Scene6: Scene,
        Scene7: Scene,
        Scene8: Scene,
        Scene9: Scene
    >(
        _ scene0: Scene0,
        _ scene1: Scene1,
        _ scene2: Scene2,
        _ scene3: Scene3,
        _ scene4: Scene4,
        _ scene5: Scene5,
        _ scene6: Scene6,
        _ scene7: Scene7,
        _ scene8: Scene8,
        _ scene9: Scene9
    ) -> TupleScene10<
        Scene0,
        Scene1,
        Scene2,
        Scene3,
        Scene4,
        Scene5,
        Scene6,
        Scene7,
        Scene8,
        Scene9
    > {
        return TupleScene10(
            scene0,
            scene1,
            scene2,
            scene3,
            scene4,
            scene5,
            scene6,
            scene7,
            scene8,
            scene9
        )
    }
}
