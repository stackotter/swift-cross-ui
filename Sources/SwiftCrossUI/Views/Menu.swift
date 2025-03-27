/// A button that shows a popover menu when clicked.
///
/// Due to technical limitations, the minimum supported OS's for menu buttons in UIKitBackend
/// are iOS 14 and tvOS 17.
public struct Menu {
    public var label: String
    public var items: [MenuItem]

    var buttonWidth: Int?

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
}

@available(iOS 14, macCatalyst 14, tvOS 17, *)
extension Menu: TypeSafeView {
    public var body: EmptyView { return EmptyView() }

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: EnvironmentValues
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
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        // TODO: Store popped menu in view graph node children so that we can
        //   continue updating it even once it's open.
        var size = backend.naturalSize(of: widget)
        size.x = buttonWidth ?? size.x

        let content = resolve().content
        switch backend.menuImplementationStyle {
            case .dynamicPopover:
                backend.updateButton(
                    widget,
                    label: label,
                    action: {
                        let menu = backend.createPopoverMenu()
                        children.menu = menu
                        backend.updatePopoverMenu(
                            menu,
                            content: content,
                            environment: environment
                        )
                        backend.showPopoverMenu(
                            menu,
                            at: SIMD2(0, size.y + 2),
                            relativeTo: widget
                        ) {
                            children.menu = nil
                        }
                    },
                    environment: environment
                )

                if !dryRun {
                    backend.setSize(of: widget, to: size)
                    children.updateMenuIfShown(
                        content: content,
                        environment: environment,
                        backend: backend
                    )
                }
            case .menuButton:
                let menu = children.menu as? Backend.Menu ?? backend.createPopoverMenu()
                children.menu = menu
                backend.updatePopoverMenu(
                    menu,
                    content: content,
                    environment: environment
                )
                backend.updateButton(widget, label: label, menu: menu, environment: environment)

                if !dryRun {
                    backend.setSize(of: widget, to: size)
                }
        }

        return ViewUpdateResult.leafView(size: ViewSize(fixedSize: size))
    }

    /// A temporary button width solution until arbitrary labels are supported.
    public func _buttonWidth(_ width: Int?) -> Menu {
        var menu = self
        menu.buttonWidth = width
        return menu
    }
}

class MenuStorage: ViewGraphNodeChildren {
    var menu: Any?

    var widgets: [AnyWidget] = []
    var erasedNodes: [ErasedViewGraphNode] = []

    init() {}

    func updateMenuIfShown<Backend: AppBackend>(
        content: ResolvedMenu,
        environment: EnvironmentValues,
        backend: Backend
    ) {
        guard let menu else {
            return
        }
        backend.updatePopoverMenu(
            menu as! Backend.Menu,
            content: content,
            environment: environment
        )
    }
}
