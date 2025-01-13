import SwiftCrossUI
import UIKit

extension UIKitBackend {
    public final class Alert {
        internal let controller: UIAlertController
        internal var handler: ((Int) -> Void)?

        internal init() {
            self.controller = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        }
    }

    public func createAlert() -> Alert {
        Alert()
    }

    public func updateAlert(
        _ alert: Alert,
        title: String,
        actionLabels: [String],
        environment _: EnvironmentValues
    ) {
        alert.controller.title = title

        for (i, actionLabel) in actionLabels.enumerated() {
            let action = UIAlertAction(title: actionLabel, style: .default) {
                [unowned self, weak alert] _ in
                guard let alert else { return }
                alert.handler!(i)
            }
            alert.controller.addAction(action)
        }
    }

    public func showAlert(
        _ alert: Alert,
        window: Window?,
        responseHandler handleResponse: @escaping (Int) -> Void
    ) {
        guard let window = window ?? mainWindow else {
            assertionFailure("Could not find window in which to display alert")
            return
        }

        alert.handler = handleResponse
        window.rootViewController!.present(alert.controller, animated: false)
    }

    public func dismissAlert(_ alert: Alert, window: Window?) {
        alert.controller.dismiss(animated: false)

    }
}
