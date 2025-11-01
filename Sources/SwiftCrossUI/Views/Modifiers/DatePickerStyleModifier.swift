extension View {
    @available(tvOS, unavailable)
    public func datePickerStyle(_ style: DatePickerStyle) -> some View {
        #if os(tvOS)
            preconditionFailure()
        #else
            EnvironmentModifier(self) { environment in
                environment.with(\.datePickerStyle, style)
            }
        #endif
    }
}
