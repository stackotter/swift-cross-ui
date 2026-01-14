extension Color {
    /// A resolved RGBA color.
    public struct Resolved: Sendable, Equatable, Hashable, Codable {
        /// The red component.
        public var red: Float
        /// The green component.
        public var green: Float
        /// The blue component.
        public var blue: Float
        /// The alpha component (aka the opacity).
        public var opacity: Float

        /// Creates an instance.
        ///
        /// - Parameters:
        ///   - red: The red component.
        ///   - green: The green component.
        ///   - blue: The blue component.
        ///   - opacity: The alpha component (aka the opacity).
        public init(
            red: Float,
            green: Float,
            blue: Float,
            opacity: Float = 1.0
        ) {
            self.red = red
            self.green = green
            self.blue = blue
            self.opacity = opacity
        }
    }

    /// Resolves this color in the given environment.
    ///
    /// - Parameter environment: The environment.
    /// - Returns: The resolved color.
    @MainActor
    public func resolve(in environment: EnvironmentValues) -> Resolved {
        switch representation {
            case .rgb(let red, let green, let blue):
                Resolved(red: red, green: green, blue: blue, opacity: opacity)
            case .systemAdaptive(let color):
                environment.backend.resolveAdaptiveColor(color, in: environment)
            case .scuiAdaptive(let color):
                // For consistency, SCUI uses AppKit's adaptive colors on all platforms.
                switch environment.colorScheme {
                    case .light:
                        switch color {
                            case .blue: .init(red: 0.0, green: 0.533, blue: 1.0)
                            case .brown: .init(red: 0.675, green: 0.498, blue: 0.369)
                            case .gray: .init(red: 0.557, green: 0.557, blue: 0.576)
                            case .green: .init(red: 0.204, green: 0.78, blue: 0.349)
                            case .orange: .init(red: 1.0, green: 0.553, blue: 0.157)
                            case .purple: .init(red: 0.796, green: 0.188, blue: 0.878)
                            case .red: .init(red: 1.0, green: 0.219, blue: 0.235)
                            case .yellow: .init(red: 1.0, green: 0.839, blue: 0.0)
                        }
                    case .dark:
                        switch color {
                            case .blue: .init(red: 0.0, green: 0.569, blue: 1.0)
                            case .brown: .init(red: 0.718, green: 0.541, blue: 0.4)
                            case .gray: .init(red: 0.557, green: 0.557, blue: 0.576)
                            case .green: .init(red: 0.188, green: 0.819, blue: 0.345)
                            case .orange: .init(red: 1.0, green: 0.573, blue: 0.188)
                            case .purple: .init(red: 0.859, green: 0.204, blue: 0.949)
                            case .red: .init(red: 1.0, green: 0.259, blue: 0.271)
                            case .yellow: .init(red: 1.0, green: 0.8, blue: 0.0)
                        }
                }
        }
    }
}
