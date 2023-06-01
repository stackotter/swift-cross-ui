@resultBuilder
public struct ViewContentBuilder {
    public static func buildBlock() -> EmptyViewContent {
        return EmptyViewContent()
    }

    @available(macOS 99.99.0, *)
    public static func buildBlock<each V: View>(_ views: repeat each V) -> ViewContentVariadic<repeat each V> {
        return ViewContentVariadic(repeat each views)
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

    public static func buildFinalResult<V: View, R: ViewContent>(_ component: V) -> R
    where V.Content == R {
        return component.body
    }
}
