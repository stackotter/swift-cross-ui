extension View {
    @available(*, deprecated, renamed: "preferredColorScheme(_:)")
    public func colorScheme(_ colorScheme: ColorScheme) -> some View {
        self.preferredColorScheme(colorScheme)
    }

    public func preferredColorScheme(_ colorScheme: ColorScheme) -> some View {
        EnvironmentModifier(self) { environment in
            environment.with(\.colorScheme, colorScheme)
        }
    }
}
