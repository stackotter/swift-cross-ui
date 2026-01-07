extension View {
    /// Sets the menu sort order, for backends that support it.
    public func menuOrder(_ order: MenuOrder) -> some View {
        environment(\.menuOrder, order)
    }
}
