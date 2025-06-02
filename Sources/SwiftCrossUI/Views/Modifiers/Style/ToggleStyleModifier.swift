extension View {
    /// Sets the style of the toggle.
    public func toggleStyle(_ toggleStyle: ToggleStyle) -> some View {
        return EnvironmentModifier(self) { environment in
            return environment.with(\.toggleStyle, toggleStyle)
        }
    }
}
