public extension GtkContainer {
    func add(_ component: Component) {
        let widget: GtkWidget
        switch component {
            case .view(let view):
                let container = Box(orientation: .vertical, spacing: 8)
                for component in view.body {
                    container.add(component)
                }
                widget = container
            case .gtkWidget(let gtkWidth):
                widget = gtkWidth
            case .button(let button):
                let gtkButton = GtkButton()
                gtkButton.label = button.text
                widget = gtkButton
            case .hStack(let hStack):
                let container = Box(orientation: .horizontal, spacing: 8)
                for component in hStack.children {
                    container.add(component)
                }
                widget = container
        }
        add(widget)
    }
}
