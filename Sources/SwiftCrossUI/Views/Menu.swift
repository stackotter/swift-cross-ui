public struct Menu: TypeSafeView {
    var label: String
    var items: [(String, () -> Void)]

    public var body = EmptyView()

    public init(_ label: String, items: [(String, () -> Void)]) {
        self.label = label
        self.items = items
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
        backend.updateButton(
            widget,
            label: label,
            action: {
                let menu = backend.createPopoverMenu()
                children.menu = menu
                backend.updatePopoverMenu(
                    menu,
                    items: items.map { (label, action) in
                        (
                            label,
                            {
                                children.menu = nil
                                action()
                            }
                        )
                    },
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
