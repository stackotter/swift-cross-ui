public struct Menu: TypeSafeView {
    public var label: String
    public var items: [MenuItem]

    public var body = EmptyView()

    public init(_ label: String, @MenuItemsBuilder items: () -> [MenuItem]) {
        self.label = label
        self.items = items()
    }

    /// Resolves the menu to a representation used by backends.
    func resolve() -> ResolvedMenu.Submenu {
        ResolvedMenu.Submenu(
            label: label,
            content: Self.resolveItems(items)
        )
    }

    /// Resolves the menu's items to a representation used by backends.
    static func resolveItems(_ items: [MenuItem]) -> ResolvedMenu {
        ResolvedMenu(
            items: items.map { item in
                switch item {
                    case .button(let button):
                        .button(button.label, button.action)
                    case .text(let text):
                        .button(text.string, nil)
                    case .submenu(let submenu):
                        .submenu(submenu.resolve())
                }
            }
        )
    }

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: Environment
    ) -> Children {
        MenuStorage()
    }

    func asWidget<Backend: AppBackend>(
        _ children: MenuStorage,
        backend: Backend
    ) -> Backend.Widget {
        return backend.createButton()
    }

    func layoutableChildren<Backend: AppBackend>(
        backend: Backend,
        children: MenuStorage
    ) -> [LayoutSystem.LayoutableChild] {
        []
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: MenuStorage,
        proposedSize: SIMD2<Int>,
        environment: Environment,
        backend: Backend,
        dryRun: Bool
    ) -> ViewSize {
        // TODO: Store popped menu in view graph node children so that we can
        //   continue updating it even once it's open.
        let size = backend.naturalSize(of: widget)

        let items = items.compactMap { item -> Button? in
            guard case let .button(button) = item else {
                return nil
            }
            return button
        }
        .map { button in
            (
                button.label,
                {
                    children.menu = nil
                    button.action()
                }
            )
        }

        backend.updateButton(
            widget,
            label: label,
            action: {
                let menu = backend.createPopoverMenu()
                children.menu = menu
                backend.updatePopoverMenu(
                    menu,
                    items: items,
                    environment: environment
                )
                backend.showPopoverMenu(menu, at: SIMD2(0, size.y + 2), relativeTo: widget) {
                    children.menu = nil
                }
            },
            environment: environment
        )
        children.updateMenuIfShown(items: items, environment: environment, backend: backend)
        return ViewSize(fixedSize: size)
    }
}

class MenuStorage: ViewGraphNodeChildren {
    var menu: Any?

    var widgets: [AnyWidget] = []
    var erasedNodes: [ErasedViewGraphNode] = []

    init() {}

    func updateMenuIfShown<Backend: AppBackend>(
        items: [(String, () -> Void)],
        environment: Environment,
        backend: Backend
    ) {
        guard let menu else {
            return
        }
        backend.updatePopoverMenu(
            menu as! Backend.Menu,
            items: items,
            environment: environment
        )
    }
}
