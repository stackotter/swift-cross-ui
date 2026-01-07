extension View {
    /// Sets the closability of the enclosing window.
    ///
    /// This only controls whether the title bar close button is enabled or
    /// not -- windows can always be closed programmatically.
    public func windowDismissBehavior(_ behavior: WindowInteractionBehavior) -> some View {
        preference(key: \.windowDismissBehavior, value: behavior)
    }

    /// Sets the minimizability of the enclosing window.
    ///
    /// - Important: This isn't supported on GtkBackend or Gtk3Backend.
    public func preferredWindowMinimizeBehavior(
        _ behavior: WindowInteractionBehavior
    ) -> some View {
        preference(key: \.preferredWindowMinimizeBehavior, value: behavior)
    }

    /// Sets the resizability of the enclosing window.
    public func windowResizeBehavior(_ behavior: WindowInteractionBehavior) -> some View {
        preference(key: \.windowResizeBehavior, value: behavior)
    }
}
