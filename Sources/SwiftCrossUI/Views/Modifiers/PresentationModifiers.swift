extension View {
    /// Sets the available detents (heights) for a sheet presentation.
    ///
    /// This modifier only affects the sheet presentation itself.
    /// It allows users to resize the sheet to different predefined heights.
    ///
    /// - Supported platforms: iOS 15+ (ignored on unsupported platforms)
    /// - `.fraction` and `.height` fall back to `.medium` on iOS 15 and earlier
    ///
    /// - Parameter detents: A set of detents that the sheet can be resized to.
    /// - Returns: A view with the presentation detents preference set.
    public func presentationDetents(_ detents: Set<PresentationDetent>) -> some View {
        preference(key: \.presentationDetents, value: Array(detents))
    }

    /// Sets the corner radius for a sheet presentation.
    ///
    /// This modifier only affects the sheet presentation itself.
    /// It does not affect the content's corner radius.
    ///
    /// - Supported platforms: iOS 15+, Gtk4 (ignored on unsupported platforms)
    ///
    /// - Parameter radius: The corner radius in points.
    /// - Returns: A view with the presentation corner radius preference set.
    public func presentationCornerRadius(_ radius: Double) -> some View {
        preference(key: \.presentationCornerRadius, value: radius)
    }

    /// Sets the visibility of a sheet's drag indicator.
    ///
    /// This modifier only affects the sheet presentation itself.
    ///
    /// - Supported platforms: iOS 15+ (ignored on unsupported platforms)
    ///
    /// - Parameter visibility: visible or hidden
    /// - Returns: A view with the presentationDragIndicatorVisibility preference set.
    public func presentationDragIndicatorVisibility(
        _ visibility: Visibility
    ) -> some View {
        preference(key: \.presentationDragIndicatorVisibility, value: visibility)
    }

    /// Sets the background of a sheet.
    ///
    /// This modifier only affects the sheet presentation itself.
    ///
    /// - Parameter color: the background color
    /// - Returns: A view with the presentationBackground preference set.
    public func presentationBackground(_ color: Color) -> some View {
        preference(key: \.presentationBackground, value: color)
    }

    /// Sets whether the user should be able to dismiss the sheet themself.
    ///
    /// This modifier only affects the sheet presentation itself.
    ///
    /// - Parameter isDisabled: Whether interactive dismissal is disabled
    /// - Returns: A view with the interactiveDismissDisabled preference set.
    public func interactiveDismissDisabled(_ isDisabled: Bool = true) -> some View {
        preference(key: \.interactiveDismissDisabled, value: isDisabled)
    }
}
