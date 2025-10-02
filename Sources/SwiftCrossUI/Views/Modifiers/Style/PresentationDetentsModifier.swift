extension View {
    /// Sets the available detents (heights) for a sheet presentation.
    ///
    /// This modifier only affects the sheet presentation itself when applied to the
    /// top-level view within a sheet. It allows users to resize the sheet to different
    /// predefined heights.
    ///
    /// - Parameter detents: A set of detents that the sheet can be resized to.
    /// - Returns: A view with the presentation detents preference set.
    public func presentationDetents(_ detents: Set<PresentationDetent>) -> some View {
        preference(key: \.presentationDetents, value: Array(detents))
    }
}
