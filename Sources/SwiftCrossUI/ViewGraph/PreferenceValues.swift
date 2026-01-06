import Foundation

public struct PreferenceValues: Sendable {
    public static let `default` = PreferenceValues(
        onOpenURL: nil,
        presentationDetents: nil,
        presentationCornerRadius: nil,
        presentationDragIndicatorVisibility: nil,
        presentationBackground: nil,
        interactiveDismissDisabled: nil,
        windowDismissBehavior: nil,
        windowMinimizeBehavior: nil,
        windowResizeBehavior: nil
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

    /// Controls whether the user can close the enclosing window.
    public var windowDismissBehavior: WindowInteractionBehavior?

    /// Controls whether the user can minimize the enclosing window.
    public var windowMinimizeBehavior: WindowInteractionBehavior?

    /// Controls whether the user can resize the enclosing window.
    public var windowResizeBehavior: WindowInteractionBehavior?

    init(
        onOpenURL: (@Sendable @MainActor (URL) -> Void)?,
        presentationDetents: [PresentationDetent]?,
        presentationCornerRadius: Double?,
        presentationDragIndicatorVisibility: Visibility?,
        presentationBackground: Color?,
        interactiveDismissDisabled: Bool?,
        windowDismissBehavior: WindowInteractionBehavior?,
        windowMinimizeBehavior: WindowInteractionBehavior?,
        windowResizeBehavior: WindowInteractionBehavior?
    ) {
        self.onOpenURL = onOpenURL
        self.presentationDetents = presentationDetents
        self.presentationCornerRadius = presentationCornerRadius
        self.presentationDragIndicatorVisibility = presentationDragIndicatorVisibility
        self.presentationBackground = presentationBackground
        self.interactiveDismissDisabled = interactiveDismissDisabled
        self.windowDismissBehavior = windowDismissBehavior
        self.windowMinimizeBehavior = windowMinimizeBehavior
        self.windowResizeBehavior = windowResizeBehavior
    }

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
        windowDismissBehavior = children.compactMap { $0.windowDismissBehavior }.first
        windowMinimizeBehavior = children.compactMap { $0.windowMinimizeBehavior }.first
        windowResizeBehavior = children.compactMap { $0.windowResizeBehavior }.first
    }
}
