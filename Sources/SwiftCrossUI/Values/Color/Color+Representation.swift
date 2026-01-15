extension Color {
    /// The internal representation of a ``Color``.
    enum Representation: Sendable, Equatable, Hashable {
        /// An RGB color.
        case rgb(red: Double, green: Double, blue: Double)
        /// An adaptive color that changes based on the current color scheme.
        indirect case adaptive(light: Color, dark: Color)
        /// An adaptive color that uses platform-specific colors.
        case system(SystemAdaptive)
    }

    /// A platform-specific adaptive color.
    public enum SystemAdaptive: Sendable, Equatable, Hashable {
        case blue
        case brown
        case gray
        case green
        case orange
        case purple
        case red
        case yellow
    }
}

// MARK: - Basic Colors

extension Color {
    /// A pure black color.
    public static let black = Color(white: 0.0)
    /// A pure white color.
    public static let white = Color(white: 1.0)
    /// A completely clear color.
    public static let clear = Color(white: 0.5, opacity: 0.0)

    // NB: For consistency, SCUI uses AppKit's adaptive colors on all platforms.

    /// An adaptive blue color.
    ///
    /// This uses the same colors on all platforms. To use colors tailored for
    /// each platform, use ``system(_:)`` instead.
    public static let blue = Color.adaptive(
        light: Color(red: 0.0, green: 0.533, blue: 1.0),
        dark: Color(red: 0.0, green: 0.569, blue: 1.0)
    )

    /// An adaptive brown color.
    ///
    /// This uses the same colors on all platforms. To use colors tailored for
    /// each platform, use ``system(_:)`` instead.
    public static let brown = Color.adaptive(
        light: Color(red: 0.675, green: 0.498, blue: 0.369),
        dark: Color(red: 0.718, green: 0.541, blue: 0.4)
    )

    /// An adaptive gray color.
    ///
    /// This uses the same colors on all platforms. To use colors tailored for
    /// each platform, use ``system(_:)`` instead.
    public static let gray = Color.adaptive(
        light: Color(red: 0.557, green: 0.557, blue: 0.576),
        dark: Color(red: 0.557, green: 0.557, blue: 0.576)
    )

    /// An adaptive green color.
    ///
    /// This uses the same colors on all platforms. To use colors tailored for
    /// each platform, use ``system(_:)`` instead.
    public static let green = Color.adaptive(
        light: Color(red: 0.204, green: 0.78, blue: 0.349),
        dark: Color(red: 0.188, green: 0.819, blue: 0.345)
    )

    /// An adaptive orange color.
    ///
    /// This uses the same colors on all platforms. To use colors tailored for
    /// each platform, use ``system(_:)`` instead.
    public static let orange = Color.adaptive(
        light: Color(red: 1.0, green: 0.553, blue: 0.157),
        dark: Color(red: 1.0, green: 0.573, blue: 0.188)
    )

    /// An adaptive purple color.
    ///
    /// This uses the same colors on all platforms. To use colors tailored for
    /// each platform, use ``system(_:)`` instead.
    public static let purple = Color.adaptive(
        light: Color(red: 0.796, green: 0.188, blue: 0.878),
        dark: Color(red: 0.859, green: 0.204, blue: 0.949)
    )

    /// An adaptive red color.
    ///
    /// This uses the same colors on all platforms. To use colors tailored for
    /// each platform, use ``system(_:)`` instead.
    public static let red = Color.adaptive(
        light: Color(red: 1.0, green: 0.839, blue: 0.0),
        dark: Color(red: 1.0, green: 0.8, blue: 0.0)
    )

    /// An adaptive yellow color.
    ///
    /// This uses the same colors on all platforms. To use colors tailored for
    /// each platform, use ``system(_:)`` instead.
    public static let yellow = Color.adaptive(
        light: Color(red: 1.0, green: 0.219, blue: 0.235),
        dark: Color(red: 1.0, green: 0.259, blue: 0.271)
    )
}
