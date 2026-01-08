import Foundation

public struct PreferenceValues: Sendable {
    /// The default preferences.
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

    /// The background color for enclosing sheets.
    public var presentationBackground: Color?

    /// Controls whether the user can interactively dismiss enclosing sheets.
    public var interactiveDismissDisabled: Bool?
}

extension PreferenceValues {
    init(merging children: [PreferenceValues]) {
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
        presentationDragIndicatorVisibility =
            children.compactMap {
                $0.presentationDragIndicatorVisibility
            }.first
        presentationBackground = children.compactMap { $0.presentationBackground }.first
        interactiveDismissDisabled = children.compactMap { $0.interactiveDismissDisabled }.first
    }
}
