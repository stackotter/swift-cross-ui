import Foundation

public struct PreferenceValues {
    public static let `default` = PreferenceValues(
        onOpenURL: nil
    )

    public var onOpenURL: ((URL) -> Void)?

    public init(onOpenURL: ((URL) -> Void)?) {
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
