extension View {
    /// Sets the menu sort order, for backends that support it.
    ///
    /// This is currently only respected by UIKitBackend, and only on iOS/tvOS
    /// 16 and up. On other backends, it always behaves as if set to ``MenuOrder/fixed``.
    public func menuOrder(_ order: MenuOrder) -> some View {
        environment(\.menuOrder, order)
    }
}
