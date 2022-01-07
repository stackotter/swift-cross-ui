public extension GtkContainer {
    func add(_ component: Component) {
        let widget: GtkWidget
        switch component {
            case let view as View:
                let container = GtkBox(orientation: .vertical, spacing: 8)
                for component in view.body {
                    container.add(component)
                }
                widget = container
            case let gtkWidget as GtkWidget:
                widget = gtkWidget
            case let button as Button:
                let gtkButton = GtkButton()
                gtkButton.label = button.text
                widget = gtkButton
            case let hStack as HStack:
                let container = GtkBox(orientation: .horizontal, spacing: 8)
                for component in hStack.children {
                    container.add(component)
                }
                widget = container
            default:
                return
        }
        add(widget)
    }
}
