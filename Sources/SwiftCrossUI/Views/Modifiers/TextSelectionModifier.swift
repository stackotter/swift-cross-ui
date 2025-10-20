extension View {
    /// Set selectability of contained text. Ignored on tvOS.
    public func textSelectionEnabled(_ isEnabled: Bool = true) -> some View {
        EnvironmentModifier(
            self,
            modification: { environment in
                environment.with(\.isTextSelectionEnabled, isEnabled)
            })
    }
}
