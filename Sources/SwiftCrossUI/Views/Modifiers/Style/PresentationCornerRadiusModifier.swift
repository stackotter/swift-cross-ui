//
//  PresentationCornerRadiusModifier.swift
//  swift-cross-ui
//
//  Created by Mia Koring on 03.10.25.
//

extension View {
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
}
