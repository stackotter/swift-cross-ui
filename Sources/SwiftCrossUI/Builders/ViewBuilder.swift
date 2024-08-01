
/// A result builder used to compose views together into composite views in
/// a declarative manner.
@resultBuilder
public struct ViewBuilder {
    public static func buildBlock() -> some View {
        return EmptyView()
    }



    public static func buildBlock<V0: View>(_ view0: V0) -> VariadicView1<V0> {
        return VariadicView1<V0>(view0)
    }


    public static func buildBlock<V0: View, V1: View>(_ view0: V0, _ view1: V1) -> VariadicView2<V0, V1> {
        return VariadicView2<V0, V1>(view0, view1)
    }


    public static func buildBlock<V0: View, V1: View, V2: View>(_ view0: V0, _ view1: V1, _ view2: V2) -> VariadicView3<V0, V1, V2> {
        return VariadicView3<V0, V1, V2>(view0, view1, view2)
    }


    public static func buildBlock<V0: View, V1: View, V2: View, V3: View>(_ view0: V0, _ view1: V1, _ view2: V2, _ view3: V3) -> VariadicView4<V0, V1, V2, V3> {
        return VariadicView4<V0, V1, V2, V3>(view0, view1, view2, view3)
    }


    public static func buildBlock<V0: View, V1: View, V2: View, V3: View, V4: View>(_ view0: V0, _ view1: V1, _ view2: V2, _ view3: V3, _ view4: V4) -> VariadicView5<V0, V1, V2, V3, V4> {
        return VariadicView5<V0, V1, V2, V3, V4>(view0, view1, view2, view3, view4)
    }


    public static func buildBlock<V0: View, V1: View, V2: View, V3: View, V4: View, V5: View>(_ view0: V0, _ view1: V1, _ view2: V2, _ view3: V3, _ view4: V4, _ view5: V5) -> VariadicView6<V0, V1, V2, V3, V4, V5> {
        return VariadicView6<V0, V1, V2, V3, V4, V5>(view0, view1, view2, view3, view4, view5)
    }


    public static func buildBlock<V0: View, V1: View, V2: View, V3: View, V4: View, V5: View, V6: View>(_ view0: V0, _ view1: V1, _ view2: V2, _ view3: V3, _ view4: V4, _ view5: V5, _ view6: V6) -> VariadicView7<V0, V1, V2, V3, V4, V5, V6> {
        return VariadicView7<V0, V1, V2, V3, V4, V5, V6>(view0, view1, view2, view3, view4, view5, view6)
    }


    public static func buildBlock<V0: View, V1: View, V2: View, V3: View, V4: View, V5: View, V6: View, V7: View>(_ view0: V0, _ view1: V1, _ view2: V2, _ view3: V3, _ view4: V4, _ view5: V5, _ view6: V6, _ view7: V7) -> VariadicView8<V0, V1, V2, V3, V4, V5, V6, V7> {
        return VariadicView8<V0, V1, V2, V3, V4, V5, V6, V7>(view0, view1, view2, view3, view4, view5, view6, view7)
    }


    public static func buildBlock<V0: View, V1: View, V2: View, V3: View, V4: View, V5: View, V6: View, V7: View, V8: View>(_ view0: V0, _ view1: V1, _ view2: V2, _ view3: V3, _ view4: V4, _ view5: V5, _ view6: V6, _ view7: V7, _ view8: V8) -> VariadicView9<V0, V1, V2, V3, V4, V5, V6, V7, V8> {
        return VariadicView9<V0, V1, V2, V3, V4, V5, V6, V7, V8>(view0, view1, view2, view3, view4, view5, view6, view7, view8)
    }


    public static func buildBlock<V0: View, V1: View, V2: View, V3: View, V4: View, V5: View, V6: View, V7: View, V8: View, V9: View>(_ view0: V0, _ view1: V1, _ view2: V2, _ view3: V3, _ view4: V4, _ view5: V5, _ view6: V6, _ view7: V7, _ view8: V8, _ view9: V9) -> VariadicView10<V0, V1, V2, V3, V4, V5, V6, V7, V8, V9> {
        return VariadicView10<V0, V1, V2, V3, V4, V5, V6, V7, V8, V9>(view0, view1, view2, view3, view4, view5, view6, view7, view8, view9)
    }

    // public static func buildEither<A: View, B: View>(first component: A) -> EitherView<A, B> {
    //     return EitherView(component)
    // }

    // public static func buildEither<A: View, B: View>(second component: B) -> EitherView<A, B> {
    //     return EitherView(component)
    // }

    // public static func buildIf<V: View>(_ content: V?) -> OptionalView<V> {
    //     return OptionalView(content)
    // }
}
