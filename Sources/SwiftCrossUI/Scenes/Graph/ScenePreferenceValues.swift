import Foundation

public struct ScenePreferenceValues: Sendable {
    /// The commands to be shown by the app.
    public var commands: Commands = .empty

    init(commands: Commands = .empty) {
        self.commands = commands
    }

    init(merging children: [ScenePreferenceValues]) {
        commands = children.map(\.commands).reduce(.empty) { $0.overlayed(with: $1) }
    }
}
