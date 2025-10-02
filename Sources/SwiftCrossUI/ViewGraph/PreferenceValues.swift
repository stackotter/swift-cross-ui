import Foundation

public struct PreferenceValues: Sendable {
    public static let `default` = PreferenceValues(
        onOpenURL: nil,
        presentationDetents: nil,
        presentationCornerRadius: nil
    )

    public var onOpenURL: (@Sendable @MainActor (URL) -> Void)?

    /// The available detents for a sheet presentation. Only applies to the top-level view in a sheet.
    public var presentationDetents: [PresentationDetent]?

    /// The corner radius for a sheet presentation. Only applies to the top-level view in a sheet.
    public var presentationCornerRadius: Int?

    public init(
        onOpenURL: (@Sendable @MainActor (URL) -> Void)?,
        presentationDetents: [PresentationDetent]? = nil,
        presentationCornerRadius: Int? = nil
    ) {
        self.onOpenURL = onOpenURL
        self.presentationDetents = presentationDetents
        self.presentationCornerRadius = presentationCornerRadius
    }

    public init(merging children: [PreferenceValues]) {
        let handlers = children.compactMap(\.onOpenURL)

        if !handlers.isEmpty {
            onOpenURL = { url in
                for handler in handlers {
                    handler(url)
                }
            }
        }

        // For presentation modifiers, take the first (top-level) value only
        // This ensures only the root view's presentation modifiers apply to the sheet
        presentationDetents = children.first?.presentationDetents
        presentationCornerRadius = children.first?.presentationCornerRadius
    }
}
