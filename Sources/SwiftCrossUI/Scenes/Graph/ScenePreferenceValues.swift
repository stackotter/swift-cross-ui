import Foundation

public struct ScenePreferenceValues: Sendable {
    /// The default preferences.
    public static let `default` = ScenePreferenceValues(commands: .empty)

    /// The commands to be shown by the app.
    public var commands: Commands
}

extension ScenePreferenceValues {
    init(merging children: [ScenePreferenceValues]) {
        commands = children.map(\.commands).reduce(.empty) { $0.overlayed(with: $1) }
    }
}
