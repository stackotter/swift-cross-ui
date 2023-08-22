import Gtk

// TODO: Get rid of the idea of CSS outside of the Gtk backend (currently just hacked over to get to a working state)

/// A modifier view on which you can apply CSS
struct CSSModifierView<Child: View>: View {
    var body: ViewContent1<Child>

    var properties: [CSSProperty]

    var clear: Bool

    var modifierName: String

    /// - Parameter clear: Whether to clear all properties before applying new. By default the properties
    ///                    are additive and it does not remove css properties previously set.
    internal init(
        _ child: Child, properties: [CSSProperty], clear: Bool = false,
        modifierName: String = #function
    ) {
        self.body = ViewContent1(child)
        self.properties = properties
        self.clear = clear
        self.modifierName = modifierName
    }

    func asWidget<Backend: AppBackend>(
        _ children: ViewGraphNodeChildren1<Child>,
        backend: Backend
    ) -> Backend.Widget {
        assert(type(of: backend) == GtkBackend.self)
        let widget = GtkModifierBox().debugName(Self.self, id: modifierName)
        widget.setChild(children.child0.widget.into())
        return widget as Backend.Widget
    }

    func update<Backend: AppBackend>(
        _ widget: GtkWidget,
        children: ViewGraphNodeChildren1<Child>,
        backend: Backend
    ) {
        let widget = widget as! GtkModifierBox
        widget.css.set(properties: properties, clear: clear)
    }
}
