import Foundation

public struct PreferenceValues: Sendable {
    public static let `default` = PreferenceValues(
        onOpenURL: nil,
        presentationDetents: nil,
        presentationCornerRadius: nil,
        presentationDragIndicatorVisibility: nil,
        presentationBackground: nil,
        interactiveDismissDisabled: nil
    )

    public var onOpenURL: (@Sendable @MainActor (URL) -> Void)?

    /// The available detents for a sheet presentation. Only applies to the top-level view in a sheet.
    public var presentationDetents: [PresentationDetent]?

    /// The corner radius for a sheet presentation. Only applies to the top-level view in a sheet.
    public var presentationCornerRadius: Double?

    /// The drag indicator visibility for a sheet presentation. Only applies to the top-level view in a sheet.
    public var presentationDragIndicatorVisibility: PresentationDragIndicatorVisibility?

    /// The backgroundcolor of a sheet. Only applies to the top-level view in a sheet
    public var presentationBackground: Color?

    public var interactiveDismissDisabled: Bool?

    public init(
        onOpenURL: (@Sendable @MainActor (URL) -> Void)?,
        presentationDetents: [PresentationDetent]? = nil,
        presentationCornerRadius: Double? = nil,
        presentationDragIndicatorVisibility: PresentationDragIndicatorVisibility? = nil,
        presentationBackground: Color? = nil,
        interactiveDismissDisabled: Bool? = nil
    ) {
        self.onOpenURL = onOpenURL
        self.presentationDetents = presentationDetents
        self.presentationCornerRadius = presentationCornerRadius
        self.presentationDragIndicatorVisibility = presentationDragIndicatorVisibility
        self.presentationBackground = presentationBackground
        self.interactiveDismissDisabled = interactiveDismissDisabled
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
        presentationDragIndicatorVisibility = children.first?.presentationDragIndicatorVisibility
        presentationBackground = children.first?.presentationBackground
        interactiveDismissDisabled = children.first?.interactiveDismissDisabled
    }
}
