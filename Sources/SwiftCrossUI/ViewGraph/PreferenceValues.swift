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

    /// The available detents for a sheet presentation. Applies to enclosing sheets.
    public var presentationDetents: [PresentationDetent]?

    /// The corner radius for a sheet presentation. Applies to enclosing sheets.
    public var presentationCornerRadius: Double?

    /// The drag indicator visibility for a sheet presentation. Applies to enclosing sheets.
    public var presentationDragIndicatorVisibility: Visibility?

    /// The backgroundcolor of a sheet. Applies to enclosing sheets.
    public var presentationBackground: Color?
    
    /// Controls whether the user can interactively dismiss enclosing sheets.  Applies to enclosing sheets.
    public var interactiveDismissDisabled: Bool?

    public init(
        onOpenURL: (@Sendable @MainActor (URL) -> Void)?,
        presentationDetents: [PresentationDetent]? = nil,
        presentationCornerRadius: Double? = nil,
        presentationDragIndicatorVisibility: Visibility? = nil,
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

        // For presentation modifiers, take the outer-most value (using child ordering to break ties).
        presentationDetents = children.compactMap { $0.presentationDetents }.first
        presentationCornerRadius = children.compactMap { $0.presentationCornerRadius }.first
        presentationDragIndicatorVisibility = children.compactMap {
            $0.presentationDragIndicatorVisibility
        }.first
        presentationBackground = children.compactMap { $0.presentationBackground }.first
        interactiveDismissDisabled = children.compactMap { $0.interactiveDismissDisabled }.first
    }
}
