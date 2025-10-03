import SwiftCrossUI
import UIKit

extension UIKitBackend {
    public typealias Sheet = CustomSheet

    public func createSheet() -> CustomSheet {
        let sheet = CustomSheet()
        sheet.modalPresentationStyle = .formSheet

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

    public func setPresentationDetents(of sheet: CustomSheet, to detents: [PresentationDetent]) {
        if #available(iOS 15.0, *) {
            if let sheetPresentation = sheet.sheetPresentationController {
                sheetPresentation.detents = detents.map {
                    switch $0 {
                        case .medium: return .medium()
                        case .large: return .large()
                        case .fraction(let fraction):
                            if #available(iOS 16.0, *) {
                                return .custom(
                                    identifier: .init("Fraction:\(fraction)"),
                                    resolver: { context in
                                        context.maximumDetentValue * fraction
                                    })
                            } else {
                                return .medium()
                            }
                        case .height(let height):
                            if #available(iOS 16.0, *) {
                                return .custom(
                                    identifier: .init("Height:\(height)"),
                                    resolver: { context in
                                        height
                                    })
                            } else {
                                return .medium()
                            }
                    }
                }
            }
        } else {
            #if DEBUG
                print(
                    "your current OS Version doesn't support variable sheet heights.\n Setting presentationDetents is only available from iOS 15.0"
                )
            #endif
        }
    }

    public func setPresentationCornerRadius(of sheet: CustomSheet, to radius: Double) {
        if #available(iOS 15.0, *) {
            if let sheetController = sheet.sheetPresentationController {
                sheetController.preferredCornerRadius = radius
            }
        } else {
            #if DEBUG
                print(
                    "your current OS Version doesn't support variable sheet corner radii.\n Setting them is only available from iOS 15.0"
                )
            #endif
        }
    }
}

public final class CustomSheet: UIViewController, SheetImplementation {
    public var size: SIMD2<Int> {
        let size = view.frame.size
        return SIMD2(x: Int(size.width), y: Int(size.height))
    }

    var onDismiss: (() -> Void)?

    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        onDismiss?()
    }
}
