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
        // If this sheet has a presented view controller (nested sheet), dismiss it first
        if let presentedVC = sheet.presentedViewController {
            presentedVC.dismiss(animated: false) { [weak sheet] in
                // After the nested sheet is dismissed, dismiss this sheet
                sheet?.dismissProgrammatically()
            }
        } else {
            sheet.dismissProgrammatically()
        }
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

    public func setPresentationDragIndicatorVisibility(
        of sheet: Sheet, to visibility: PresentationDragIndicatorVisibility
    ) {
        if #available(iOS 15.0, *) {
            if let sheetController = sheet.sheetPresentationController {
                sheetController.prefersGrabberVisible = visibility == .visible ? true : false
            }
        } else {
            #if DEBUG
                print(
                    "Your current OS Version doesn't support setting sheet drag indicator visibility.\n Setting this is only available from iOS 15.0"
                )
            #endif
        }
    }

    public func setPresentationBackground(of sheet: CustomSheet, to color: Color) {
        sheet.view.backgroundColor = color.uiColor
    }
}

public final class CustomSheet: UIViewController, SheetImplementation {
    public var size: SIMD2<Int> {
        let size = view.frame.size
        return SIMD2(x: Int(size.width), y: Int(size.height))
    }

    var onDismiss: (() -> Void)?
    private var isDismissedProgrammatically = false

    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    func dismissProgrammatically() {
        isDismissedProgrammatically = true
        dismiss(animated: true)
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // Only call onDismiss if the sheet was dismissed by user interaction (swipe down, tap outside)
        // not when dismissed programmatically via the dismiss action
        if !isDismissedProgrammatically {
            onDismiss?()
        }
    }
}
