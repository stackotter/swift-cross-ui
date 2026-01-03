/// A scene that shows a standalone alert.
public struct AlertScene: Scene {
    public typealias Node = AlertSceneNode

    var title: String
    @Binding var isPresented: Bool
    var actions: [AlertAction]

    public let commands = Commands.empty

    public init(
        _ title: String,
        isPresented: Binding<Bool>,
        @AlertActionsBuilder actions: () -> [AlertAction]
    ) {
        self.title = title
        self._isPresented = isPresented
        self.actions = actions()
    }
}

public final class AlertSceneNode: SceneGraphNode {
    public typealias NodeScene = AlertScene

    private var scene: AlertScene
    private var alert: Any?

    public init<Backend: AppBackend>(
        from scene: AlertScene,
        backend: Backend,
        environment: EnvironmentValues
    ) {
        self.scene = scene
    }

    public func update<Backend: AppBackend>(
        _ newScene: AlertScene?,
        backend: Backend,
        environment: EnvironmentValues
    ) {
        if let newScene {
            self.scene = newScene
        }

        if scene.isPresented, alert == nil {
            let alert = backend.createAlert()
            backend.updateAlert(
                alert,
                title: scene.title,
                actionLabels: scene.actions.map(\.label),
                environment: environment
            )
            backend.showAlert(alert, window: nil) { [weak self] responseId in
                guard let self else {
                    return
                }

                self.alert = nil
                self.scene.isPresented = false
                self.scene.actions[responseId].action()
            }

            self.alert = alert
        } else if !scene.isPresented, let alert = alert as? Backend.Alert {
            backend.dismissAlert(alert, window: nil)
            self.alert = nil
        }
    }
}
