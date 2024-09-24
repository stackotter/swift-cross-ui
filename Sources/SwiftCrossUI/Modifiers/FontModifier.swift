extension View {
    public func font(_ font: Font) -> some View {
        EnvironmentModifier(self) { environment in
            // TODO: Merge fonts?
            environment.with(\.font, font)
        }
    }
}
