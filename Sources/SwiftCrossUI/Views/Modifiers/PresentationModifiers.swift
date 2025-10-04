extension View {
    /// Sets the available detents (heights) for a sheet presentation.
    ///
    /// This modifier only affects the sheet presentation itself when applied to the
    /// top-level view within a sheet. It allows users to resize the sheet to different
    /// predefined heights.
    ///
    /// supported platforms: iOS (ignored on unsupported platforms)
    /// ignored on: older than iOS 15
    /// fraction and height fall back to medium on iOS 15 and work as you'd expect on >=16
    ///
    /// - Parameter detents: A set of detents that the sheet can be resized to.
    /// - Returns: A view with the presentation detents preference set.
    public func presentationDetents(_ detents: Set<PresentationDetent>) -> some View {
        preference(key: \.presentationDetents, value: Array(detents))
    }

    /// Sets the corner radius for a sheet presentation.
    ///
    /// This modifier only affects the sheet presentation itself when applied to the
    /// top-level view within a sheet. It does not affect the content's corner radius.
    ///
    /// supported platforms: iOS (ignored on unsupported platforms)
    /// ignored on: older than iOS 15
    ///
    /// - Parameter radius: The corner radius in pixels.
    /// - Returns: A view with the presentation corner radius preference set.
    public func presentationCornerRadius(_ radius: Double) -> some View {
        preference(key: \.presentationCornerRadius, value: radius)
    }

    public func presentationDragIndicatorVisibility(
        _ visibility: PresentationDragIndicatorVisibility
    ) -> some View {
        preference(key: \.presentationDragIndicatorVisibility, value: visibility)
    }

    public func presentationBackground(_ color: Color) -> some View {
        preference(key: \.presentationBackground, value: color)
    }

    public func interactiveDismissDisabled(_ isDisabled: Bool = true) -> some View {
        preference(key: \.interactiveDismissDisabled, value: isDisabled)
    }
}
