/// A builder for ``[MenuItem]``.
@resultBuilder
public struct MenuItemsBuilder {
    public static func buildBlock() -> [MenuItem] {
        []
    }
    
    public static func buildPartialBlock(first: Button) -> [MenuItem] {
        [.button(first)]
    }

    public static func buildPartialBlock(first: Text) -> [MenuItem] {
        [.text(first)]
    }

    public static func buildPartialBlock(first: Toggle) -> [MenuItem] {
        [.toggle(first)]
    }

    public static func buildPartialBlock(first: Menu) -> [MenuItem] {
        [.submenu(first)]
    }

    public static func buildPartialBlock(first: Block) -> [MenuItem] {
        first.items
    }

    public static func buildPartialBlock<Items: Collection>(
        first: ForEach<Items, [MenuItem]>
    ) -> [MenuItem] {
        first.elements.map(first.child).flatMap { $0 }
    }

    public static func buildPartialBlock(
        accumulated: [MenuItem],
        next: Button
    ) -> [MenuItem] {
        accumulated + buildPartialBlock(first: next)
    }

    public static func buildPartialBlock(
        accumulated: [MenuItem],
        next: Text
    ) -> [MenuItem] {
        accumulated + buildPartialBlock(first: next)
    }

    public static func buildPartialBlock(
        accumulated: [MenuItem],
        next: Toggle
    ) -> [MenuItem] {
        accumulated + buildPartialBlock(first: next)
    }

    public static func buildPartialBlock(
        accumulated: [MenuItem],
        next: Menu
    ) -> [MenuItem] {
        accumulated + buildPartialBlock(first: next)
    }

    public static func buildPartialBlock(
        accumulated: [MenuItem],
        next: Block
    ) -> [MenuItem] {
        accumulated + buildPartialBlock(first: next)
    }

    public static func buildPartialBlock<Items: Collection>(
        accumulated: [MenuItem],
        next: ForEach<Items, [MenuItem]>
    ) -> [MenuItem] {
        accumulated + buildPartialBlock(first: next)
    }

    public static func buildOptional(_ component: [MenuItem]?) -> Block {
        Block(items: component ?? [])
    }

    public static func buildEither(first component: [MenuItem]) -> Block {
        Block(items: component)
    }

    public static func buildEither(second component: [MenuItem]) -> Block {
        Block(items: component)
    }

    /// An implementation detail of ``MenuItemBuilder``'s support for
    /// `if`/`else if`/`else` blocks.
    public struct Block {
        var items: [MenuItem]
    }
}
