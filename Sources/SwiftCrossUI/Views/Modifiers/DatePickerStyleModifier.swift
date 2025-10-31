extension View {
    @available(tvOS, unavailable)
    public func datePickerStyle(_ style: DatePickerStyle) -> some View {
        EnvironmentModifier(self) { environment in
            environment.with(\.datePickerStyle, style)
        }
    }
}
