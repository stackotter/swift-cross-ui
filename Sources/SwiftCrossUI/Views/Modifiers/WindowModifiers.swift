extension View {
    /// Sets the closability of the enclosing window.
    ///
    /// This only controls whether the title bar close button is enabled or
    /// not -- windows can always be closed programmatically.
    public func windowDismissBehavior(
        _ behavior: WindowInteractionBehavior
    ) -> some View {
        return preference(key: \.windowDismissBehavior, value: behavior)
    }

    /// Sets the minimizability of the enclosing window.
    public consuming func windowMinimizeBehavior(
        _ behavior: WindowInteractionBehavior
    ) -> some View {
        preference(key: \.windowMinimizeBehavior, value: behavior)
    }
}
