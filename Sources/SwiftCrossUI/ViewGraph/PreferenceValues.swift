import Foundation

public struct PreferenceValues: Sendable {
    public static let `default` = PreferenceValues(
        onOpenURL: nil
    )

    public var onOpenURL: (@Sendable @MainActor (URL) -> Void)?

    public init(onOpenURL: (@Sendable @MainActor (URL) -> Void)?) {
        self.onOpenURL = onOpenURL
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
    }
}
