import SwiftCrossUI
import UIKit

extension Font.Resolved {
    var uiFont: UIFont {
        switch identifier.kind {
            case .system:
                let weight: UIFont.Weight =
                    switch weight {
                        case .ultraLight:
                            .ultraLight
                        case .thin:
                            .thin
                        case .light:
                            .light
                        case .regular:
                            .regular
                        case .medium:
                            .medium
                        case .semibold:
                            .semibold
                        case .bold:
                            .bold
                        case .heavy:
                            .heavy
                        case .black:
                            .black
                    }

                switch design {
                    case .monospaced:
                        return .monospacedSystemFont(ofSize: CGFloat(pointSize), weight: weight)
                    case .default:
                        return .systemFont(ofSize: CGFloat(pointSize), weight: weight)
                }
        }
    }
}
