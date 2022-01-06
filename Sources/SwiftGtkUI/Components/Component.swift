/// A UI component. Can be a builtin widget, a custom Gtk widget, or a view.
public enum Component {
    /// A view made up of components.
    case view(View)
    /// A custom Gtk widget.
    case gtkWidget(GtkWidget)
    
    /// A button.
    case button(Button)
    /// A horizontal container.
    case hStack(HStack)
}
