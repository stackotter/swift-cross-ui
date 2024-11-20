public enum ColorScheme {
    case light
    case dark

    public var defaultForegroundColor: Color {
        switch self {
            case .light: .black
            case .dark: .white
        }
    }
}
