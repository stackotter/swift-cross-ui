extension View {
    public func font(_ font: Font) -> some View {
        EnvironmentModifier(self) { environment in
            environment.with(\.font, font)
        }
    }

    public func bold() -> some View {
        EnvironmentModifier(self) { environment in
            let font =
                switch environment.font {
                    case let .system(size, _, design):
                        Font.system(size: size, weight: .bold, design: design)
                }

            return environment.with(
                \.font,
                font
            )
        }
    }
}
