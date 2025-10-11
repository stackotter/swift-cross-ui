extension View {
    /// Set SwiftUI.Text selectability
    public func textSelectionEnabled(_ isEnabled: Bool = true) -> some View {
        EnvironmentModifier(
            self,
            modification: { environment in
                var newEnvironment = environment
                newEnvironment.isTextSelectionEnabled = isEnabled
                return newEnvironment
            })
    }
}
