import SwiftCrossUI
import UIKit

extension Font {
    var uiFont: UIFont {
        switch self {
            case .system(let size, let weight, let design):
                let weight: UIFont.Weight =
                    switch weight {
                        case .black:
                            .black
                        case .bold:
                            .bold
                        case .heavy:
                            .heavy
                        case .light:
                            .light
                        case .medium:
                            .medium
                        case .regular, nil:
                            .regular
                        case .semibold:
                            .semibold
                        case .thin:
                            .thin
                        case .ultraLight:
                            .ultraLight
                    }

                switch design {
                    case .monospaced:
                        return .monospacedSystemFont(ofSize: CGFloat(size), weight: weight)
                    default:
                        return .systemFont(ofSize: CGFloat(size), weight: weight)
                }
        }
    }
}
