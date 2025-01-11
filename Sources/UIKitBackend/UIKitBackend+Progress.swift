//
//  UIKitBackend+Progress.swift
//  swift-cross-ui
//
//  Created by William Baker on 1/10/25.
//

import SwiftCrossUI
import UIKit

internal final class ProgressSpinner: WrapperWidget<UIActivityIndicatorView> {
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        child.startAnimating()
    }
}

extension UIKitBackend {
    public func createProgressSpinner() -> Widget {
        ProgressSpinner()
    }

    public func createProgressBar() -> Widget {
        let style: UIProgressView.Style
        #if os(tvOS)
            style = .default
        #else
            style = .bar
        #endif
        return WrapperWidget(child: UIProgressView(progressViewStyle: style))
    }

    public func updateProgressBar(
        _ widget: Widget,
        progressFraction: Double?,
        environment: EnvironmentValues
    ) {
        guard let progressFraction else { return }
        let wrapper = widget as! WrapperWidget<UIProgressView>

        wrapper.child.setProgress(Float(progressFraction), animated: true)
    }
}
