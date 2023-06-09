extension View {
    /// Positions this view within an invisible frame having the specified size constraints.
    public func frame(minWidth: Int? = nil, minHeight: Int? = nil) -> some View {
        return CSSModifierView(self, properties: [
            .minWidth(minWidth ?? 0),
            .minHeight(minHeight ?? 0)
        ])
    }
}
