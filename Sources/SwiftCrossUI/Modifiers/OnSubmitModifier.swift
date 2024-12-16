extension View {
    /// Adds an action to perform when the user submits a text field within this
    /// view (generally via pressing the Enter/Return key).
    public func onSubmit(perform action: @escaping () -> Void) -> some View {
        EnvironmentModifier(self) { environment in
            environment.with(\.onSubmit, action)
        }
    }

    /// Prevents text field submissions from propagating to this view's
    /// ancestors.
    public func submitScope() -> some View {
        EnvironmentModifier(self) { environment in
            environment.with(\.onSubmit, nil)
        }
    }
}
