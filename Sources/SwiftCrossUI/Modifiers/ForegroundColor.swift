extension View {
    /// Sets the color of the foreground elements displayed by this view.
    public func foregroundColor(_ color: Color) -> some View {
        return CSSModifierView(self, properties: [
            .foregroundColor(color.gtkColor)
        ])
    }
}
