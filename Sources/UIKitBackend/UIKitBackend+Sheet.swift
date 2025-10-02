import SwiftCrossUI
import UIKit

extension UIKitBackend {
    public typealias Sheet = CustomSheet

    public func createSheet() -> CustomSheet {
        let sheet = CustomSheet()
        sheet.modalPresentationStyle = .formSheet
        //sheet.transitioningDelegate = CustomSheetTransitioningDelegate()

        return sheet
    }

    public func updateSheet(_ sheet: CustomSheet, content: Widget, onDismiss: @escaping () -> Void)
    {
        sheet.view = content.view
        sheet.onDismiss = onDismiss
    }

    public func showSheet(_ sheet: CustomSheet, window: UIWindow?) {
        var topController = window?.rootViewController
        while let presented = topController?.presentedViewController {
            topController = presented
        }
        topController?.present(sheet, animated: true)
    }

    public func dismissSheet(_ sheet: CustomSheet, window: UIWindow?) {
        sheet.dismiss(animated: true)
    }
}

public final class CustomSheet: UIViewController {
    var onDismiss: (() -> Void)?

    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        onDismiss?()
    }
}
