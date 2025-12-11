extension View {
    public func datePickerStyle(_ style: DatePickerStyle) -> some View {
        EnvironmentModifier(self) { environment in
            var style = style
            if !environment.supportedDatePickerStyles.contains(style) {
                assertionFailure("Unsupported date picker style: \(style)")
                style = .automatic
            }
            return environment.with(\.datePickerStyle, style)
        }
    }
}
