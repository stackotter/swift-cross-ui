extension View {
    public func colorScheme(_ colorScheme: ColorScheme) -> some View {
        EnvironmentModifier(self) { environment in
            environment.with(\.colorScheme, colorScheme)
        }
    }
}
