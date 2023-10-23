import Foundation
import Qlift
import SwiftCrossUI

// TODO: Remove default padding from QBoxLayout related widgets.
// TODO: Fix window size code, currently seems to get pretty ignored.

public struct QtBackend: AppBackend {
    public typealias Window = QMainWindow
    public typealias Widget = QWidget

    private class InternalState {
        var buttonClickActions: [ObjectIdentifier: () -> Void] = [:]
        var sliderChangeActions: [ObjectIdentifier: (Double) -> Void] = [:]
        var paddingContainerChildren: [ObjectIdentifier: Widget] = [:]
    }

    private var internalState: InternalState
    private let application: QApplication

    public init(appIdentifier: String) {
        internalState = InternalState()
        application = QApplication()
    }

    public func createRootWindow(
        _ properties: WindowProperties,
        _ callback: @escaping (Window) -> Void
    ) {
        let mainWindow = MainWindow()
        mainWindow.setProperties(properties)
        callback(mainWindow)
    }

    public func setChild(ofWindow window: Window, to child: Widget) {
        window.centralWidget = child
    }

    public func show(window: Window) {
        window.show()
    }

    public func runMainLoop() {
        _ = application.exec()
    }

    public func runInMainThread(action: @escaping () -> Void) {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
            DispatchQueue.main.async {
                action()
            }
        #else
            action()
        #endif
    }

    public func show(widget: Widget) {
        widget.show()
    }

    public func createVStack(spacing: Int) -> Widget {
        let layout = QVBoxLayout()
        layout.spacing = Int32(spacing)

        let widget = QWidget()
        widget.layout = layout
        return widget
    }

    public func addChild(_ child: Widget, toVStack container: Widget) {
        (container.layout as! QVBoxLayout).add(widget: child)
    }

    public func setSpacing(ofVStack widget: Widget, to spacing: Int) {
        (widget.layout as! QVBoxLayout).spacing = Int32(spacing)
    }

    public func createHStack(spacing: Int) -> Widget {
        let layout = QHBoxLayout()
        layout.spacing = Int32(spacing)

        let widget = QWidget()
        widget.layout = layout
        return widget
    }

    public func addChild(_ child: Widget, toHStack container: Widget) {
        (container.layout as! QHBoxLayout).add(widget: child)
    }

    public func setSpacing(ofHStack widget: Widget, to spacing: Int) {
        (widget.layout as! QHBoxLayout).spacing = Int32(spacing)
    }

    public func createPaddingContainer(for child: Widget) -> Widget {
        let container = createVStack(spacing: 0)
        addChild(child, toVStack: container)
        internalState.paddingContainerChildren[ObjectIdentifier(container)] = child
        return container
    }

    public func getChild(ofPaddingContainer container: Widget) -> Widget {
        return internalState.paddingContainerChildren[ObjectIdentifier(container)]!
    }

    public func setPadding(
        ofPaddingContainer container: Widget,
        top: Int,
        bottom: Int,
        leading: Int,
        trailing: Int
    ) {
        (container.layout! as! QVBoxLayout).contentsMargins = QMargins(
            left: Int32(leading),
            top: Int32(top),
            right: Int32(trailing),
            bottom: Int32(bottom)
        )
    }

    public func createTextView(content: String, shouldWrap: Bool) -> Widget {
        let label = QLabel(text: content)
        return label
    }

    public func setContent(ofTextView textView: Widget, to content: String) {
        (textView as! QLabel).text = content
    }

    public func setWrap(ofTextView textView: Widget, to shouldWrap: Bool) {
        // TODO: Implement text wrap setting
    }

    public func createButton(label: String, action: @escaping () -> Void) -> Widget {
        let button = QPushButton(text: label)

        // Internal state is required to avoid multiple subsequent calls to setAction adding
        // new handlers instead of replacing the existing handler
        internalState.buttonClickActions[ObjectIdentifier(button)] = action
        button.connectClicked(receiver: nil) { [weak internalState] in
            guard let internalState = internalState else {
                return
            }
            internalState.buttonClickActions[ObjectIdentifier(button)]?()
        }

        return button
    }

    public func setLabel(ofButton button: Widget, to label: String) {
        (button as! QPushButton).text = label
    }

    public func setAction(ofButton button: Widget, to action: @escaping () -> Void) {
        internalState.buttonClickActions[ObjectIdentifier(button)] = action
    }

    public func createSlider(
        minimum: Double,
        maximum: Double,
        value: Double,
        decimalPlaces: Int,
        onChange: @escaping (Double) -> Void
    ) -> QWidget {
        let slider = QSlider(orientation: .Horizontal)
        slider.minimum = Int32(minimum)
        slider.maximum = Int32(maximum)
        slider.value = Int32(value)

        internalState.sliderChangeActions[ObjectIdentifier(slider)] = onChange
        slider.connectValueChanged(receiver: nil) { [weak internalState] val in
            guard let internalState = internalState else {
                return
            }
            internalState.sliderChangeActions[ObjectIdentifier(slider)]?(Double(val))
        }

        return slider
    }

    public func setMinimum(ofSlider slider: Widget, to minimum: Double) {
        (slider as! QSlider).minimum = Int32(minimum)
    }

    public func setMaximum(ofSlider slider: Widget, to maximum: Double) {
        (slider as! QSlider).maximum = Int32(maximum)
    }

    public func setValue(ofSlider slider: Widget, to value: Double) {
        (slider as! QSlider).value = Int32(value)
    }

    /// non applicable here
    public func setDecimalPlaces(ofSlider slider: Widget, to decimalPlaces: Int) {
    }

    public func setOnChange(ofSlider slider: Widget, to onChange: @escaping (Double) -> Void) {
        internalState.sliderChangeActions[ObjectIdentifier(slider)] = onChange
    }
}

class MainWindow: QMainWindow {
    override init(parent: QWidget? = nil, flags: Qt.WindowFlags = .Widget) {
        super.init(parent: parent, flags: flags)
    }

    func setProperties(_ properties: WindowProperties) {
        windowTitle = properties.title

        let size = properties.defaultSize
        geometry = QRect(
            x: 0,
            y: 0,
            width: Int32(size?.width ?? 0),
            height: Int32(size?.height ?? 0)
        )

        let policy: QSizePolicy.Policy = .Maximum
        sizePolicy = QSizePolicy(horizontal: policy, vertical: policy)
    }
}
