import Gtk

/// A modifier view on which you can apply CSS
struct CSSModifierView<Child: View>: View {
    var body: ViewContent1<Child>

    var properties: [CSSProperty]

    var clear: Bool

    var modifierName: String

    /// - Parameter clear: Whether to clear all properties before applying new. By default the properties
    ///                    are additive and it does not remove css properties previously set.
    internal init(_ child: Child, properties: [CSSProperty], clear: Bool = false, modifierName: String = #function) {
        self.body = ViewContent1(child)
        self.properties = properties
        self.clear = clear
        self.modifierName = modifierName
    }

    func asWidget(_ children: ViewGraphNodeChildren1<Child>) -> GtkModifierBox {
        let widget = GtkModifierBox().debugName(Self.self, id: modifierName)
        widget.setChild(children.child0.widget)
        return widget
    }

    func update(_ widget: GtkModifierBox, children: ViewGraphNodeChildren1<Child>) {
        widget.css.set(properties: properties, clear: clear)
    }
}
