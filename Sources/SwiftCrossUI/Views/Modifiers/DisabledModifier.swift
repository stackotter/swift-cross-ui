extension View {
    /// Disables user interaction in any subviews that support disabling
    /// interaction.
    public func disabled(_ disabled: Bool = true) -> some View {
        EnvironmentModifier(self) { environment in
            environment.with(\.isEnabled, !disabled)
        }
    }
}
