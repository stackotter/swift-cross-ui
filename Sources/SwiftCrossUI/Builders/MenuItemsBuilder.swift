/// A builder for ``[MenuItem]``.
@resultBuilder
public struct MenuItemsBuilder {
    public static func buildPartialBlock(first: Button) -> [MenuItem] {
        [.button(first)]
    }

    public static func buildPartialBlock(first: Text) -> [MenuItem] {
        [.text(first)]
    }

    public static func buildPartialBlock(first: Menu) -> [MenuItem] {
        [.submenu(first)]
    }

    public static func buildPartialBlock(
        accumulated: [MenuItem],
        next: Button
    ) -> [MenuItem] {
        accumulated + [.button(next)]
    }

    public static func buildPartialBlock(
        accumulated: [MenuItem],
        next: Text
    ) -> [MenuItem] {
        accumulated + [.text(next)]
    }

    public static func buildPartialBlock(
        accumulated: [MenuItem],
        next: Menu
    ) -> [MenuItem] {
        accumulated + [.submenu(next)]
    }
}
