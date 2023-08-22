
@resultBuilder
public struct ViewContentBuilder {
    public static func buildBlock() -> EmptyViewContent {
        return EmptyViewContent()
    }



    public static func buildBlock<V0: View>(_ view0: V0) -> ViewContent1<V0> {
        return ViewContent1<V0>(view0)
    }


    public static func buildBlock<V0: View, V1: View>(_ view0: V0, _ view1: V1) -> ViewContent2<V0, V1> {
        return ViewContent2<V0, V1>(view0, view1)
    }


    public static func buildBlock<V0: View, V1: View, V2: View>(_ view0: V0, _ view1: V1, _ view2: V2) -> ViewContent3<V0, V1, V2> {
        return ViewContent3<V0, V1, V2>(view0, view1, view2)
    }


    public static func buildBlock<V0: View, V1: View, V2: View, V3: View>(_ view0: V0, _ view1: V1, _ view2: V2, _ view3: V3) -> ViewContent4<V0, V1, V2, V3> {
        return ViewContent4<V0, V1, V2, V3>(view0, view1, view2, view3)
    }


    public static func buildBlock<V0: View, V1: View, V2: View, V3: View, V4: View>(_ view0: V0, _ view1: V1, _ view2: V2, _ view3: V3, _ view4: V4) -> ViewContent5<V0, V1, V2, V3, V4> {
        return ViewContent5<V0, V1, V2, V3, V4>(view0, view1, view2, view3, view4)
    }


    public static func buildBlock<V0: View, V1: View, V2: View, V3: View, V4: View, V5: View>(_ view0: V0, _ view1: V1, _ view2: V2, _ view3: V3, _ view4: V4, _ view5: V5) -> ViewContent6<V0, V1, V2, V3, V4, V5> {
        return ViewContent6<V0, V1, V2, V3, V4, V5>(view0, view1, view2, view3, view4, view5)
    }


    public static func buildBlock<V0: View, V1: View, V2: View, V3: View, V4: View, V5: View, V6: View>(_ view0: V0, _ view1: V1, _ view2: V2, _ view3: V3, _ view4: V4, _ view5: V5, _ view6: V6) -> ViewContent7<V0, V1, V2, V3, V4, V5, V6> {
        return ViewContent7<V0, V1, V2, V3, V4, V5, V6>(view0, view1, view2, view3, view4, view5, view6)
    }


    public static func buildBlock<V0: View, V1: View, V2: View, V3: View, V4: View, V5: View, V6: View, V7: View>(_ view0: V0, _ view1: V1, _ view2: V2, _ view3: V3, _ view4: V4, _ view5: V5, _ view6: V6, _ view7: V7) -> ViewContent8<V0, V1, V2, V3, V4, V5, V6, V7> {
        return ViewContent8<V0, V1, V2, V3, V4, V5, V6, V7>(view0, view1, view2, view3, view4, view5, view6, view7)
    }


    public static func buildBlock<V0: View, V1: View, V2: View, V3: View, V4: View, V5: View, V6: View, V7: View, V8: View>(_ view0: V0, _ view1: V1, _ view2: V2, _ view3: V3, _ view4: V4, _ view5: V5, _ view6: V6, _ view7: V7, _ view8: V8) -> ViewContent9<V0, V1, V2, V3, V4, V5, V6, V7, V8> {
        return ViewContent9<V0, V1, V2, V3, V4, V5, V6, V7, V8>(view0, view1, view2, view3, view4, view5, view6, view7, view8)
    }


    public static func buildBlock<V0: View, V1: View, V2: View, V3: View, V4: View, V5: View, V6: View, V7: View, V8: View, V9: View>(_ view0: V0, _ view1: V1, _ view2: V2, _ view3: V3, _ view4: V4, _ view5: V5, _ view6: V6, _ view7: V7, _ view8: V8, _ view9: V9) -> ViewContent10<V0, V1, V2, V3, V4, V5, V6, V7, V8, V9> {
        return ViewContent10<V0, V1, V2, V3, V4, V5, V6, V7, V8, V9>(view0, view1, view2, view3, view4, view5, view6, view7, view8, view9)
    }

    public static func buildEither<A: View, B: View>(first component: A) -> EitherView<A, B> {
        return EitherView(component)
    }

    public static func buildEither<A: View, B: View>(second component: B) -> EitherView<A, B> {
        return EitherView(component)
    }

    public static func buildIf<V: View>(_ content: V?) -> OptionalView<V> {
        return OptionalView(content)
    }

    public static func buildFinalResult<V: View, R: ViewContent>(_ component: V) -> R where V.Content == R {
        return component.body
    }
}
