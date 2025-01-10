//
//  UIKitBackend+Passive.swift
//  swift-cross-ui
//
//  Created by William Baker on 1/9/25.
//

import SwiftCrossUI
import UIKit

extension UIKitBackend {
    internal static func uiFont(for font: Font) -> UIFont {
        switch font {
        case .system(size: let size, weight: let weight, design: let design):
            let weight: UIFont.Weight = switch weight {
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
    
    internal static func attributedString(
        text: String,
        environment: EnvironmentValues
    ) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = switch environment.multilineTextAlignment {
            case .center:
                .center
            case .leading:
                .natural
            case .trailing:
                UIScreen.main.traitCollection.layoutDirection == .rightToLeft ? .left : .right
            }
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        return NSAttributedString(
            string: text,
            attributes: [
                .font: uiFont(for: environment.font),
                .foregroundColor: UIColor(
                    red: CGFloat(environment.suggestedForegroundColor.red),
                    green: CGFloat(environment.suggestedForegroundColor.green),
                    blue: CGFloat(environment.suggestedForegroundColor.blue),
                    alpha: CGFloat(environment.suggestedForegroundColor.alpha)
                ),
                .paragraphStyle: paragraphStyle
            ]
        )
    }
    
    public func createTextView() -> Widget {
        UILabel()
    }
    
    public func updateTextView(
        _ textView: Widget,
        content: String,
        environment: EnvironmentValues
    ) {
        let label = textView as! UILabel
        label.attributedText = UIKitBackend.attributedString(text: content, environment: environment)
    }
    
    public func size(
        of text: String,
        whenDisplayedIn textView: Widget,
        proposedFrame: SIMD2<Int>?,
        environment: EnvironmentValues
    ) -> SIMD2<Int> {
        let attributedString = UIKitBackend.attributedString(text: text, environment: environment)
        let boundingSize = if let proposedFrame { CGSize(width: CGFloat(proposedFrame.x), height: .greatestFiniteMagnitude) } else {
            CGSize(width: .greatestFiniteMagnitude, height: UIKitBackend.uiFont(for: environment.font).lineHeight)
        }
        let size = attributedString.boundingRect(
            with: boundingSize,
            options: proposedFrame == nil ? [] : [.usesLineFragmentOrigin],
            context: nil
        )
        return SIMD2(
            Int(size.width.rounded(.awayFromZero)),
            Int(size.height.rounded(.awayFromZero))
        )
    }
    
    public func createImageView() -> Widget {
        UIImageView()
    }
    
    public func updateImageView(
        _ imageView: Widget,
        rgbaData: [UInt8],
        width: Int,
        height: Int,
        targetWidth: Int,
        targetHeight: Int,
        dataHasChanged: Bool
    ) {
        guard dataHasChanged else { return }
        let uiImageView = imageView as! UIImageView
        let ciImage = CIImage(
            bitmapData: Data(rgbaData),
            bytesPerRow: width * 4,
            size: CGSize(width: CGFloat(width), height: CGFloat(height)),
            format: .RGBA8,
            colorSpace: .init(name: CGColorSpace.sRGB)
        )
        uiImageView.image = .init(ciImage: ciImage)
    }
}
