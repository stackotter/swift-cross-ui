extension View {
    /// Sets the alignment of lines of text relative to each other in multiline
    /// text views.
    public func multilineTextAlignment(_ alignment: HorizontalAlignment) -> some View {
        return EnvironmentModifier(self) { environment in
            return environment.with(\.multilineTextAlignment, alignment)
        }
    }
}
