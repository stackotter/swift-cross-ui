//
//  UIKitBackend+Passive.swift
//  swift-cross-ui
//
//  Created by William Baker on 1/9/25.
//

import SwiftCrossUI
import UIKit

extension UIKitBackend {
    internal static func attributedString(
        text: String,
        environment: EnvironmentValues
    ) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment =
            switch environment.multilineTextAlignment {
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
                .font: environment.font.uiFont,
                .foregroundColor: UIColor(color: environment.suggestedForegroundColor),
                .paragraphStyle: paragraphStyle,
            ]
        )
    }

    public func createTextView() -> Widget {
        WrapperWidget<UILabel>()
    }

    public func updateTextView(
        _ textView: Widget,
        content: String,
        environment: EnvironmentValues
    ) {
        let wrapper = textView as! WrapperWidget<UILabel>
        wrapper.child.attributedText = UIKitBackend.attributedString(
            text: content, environment: environment)
    }

    public func size(
        of text: String,
        whenDisplayedIn textView: Widget,
        proposedFrame: SIMD2<Int>?,
        environment: EnvironmentValues
    ) -> SIMD2<Int> {
        let attributedString = UIKitBackend.attributedString(text: text, environment: environment)
        let boundingSize =
            if let proposedFrame {
                CGSize(width: CGFloat(proposedFrame.x), height: .greatestFiniteMagnitude)
            } else {
                CGSize(width: .greatestFiniteMagnitude, height: environment.font.uiFont.lineHeight)
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
        WrapperWidget<UIImageView>()
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
        let wrapper = imageView as! WrapperWidget<UIImageView>
        let ciImage = CIImage(
            bitmapData: Data(rgbaData),
            bytesPerRow: width * 4,
            size: CGSize(width: CGFloat(width), height: CGFloat(height)),
            format: .RGBA8,
            colorSpace: .init(name: CGColorSpace.sRGB)
        )
        wrapper.child.image = .init(ciImage: ciImage)
    }
}
