import Foundation
import Qlift
import SwiftCrossUI

// TODO: Remove default padding from QBoxLayout related widgets.
// TODO: Fix window size code, currently seems to get pretty ignored.

public struct QtBackend: AppBackend {
    public typealias Widget = QWidget

    private class InternalState {
        var buttonClickActions: [ObjectIdentifier: () -> Void] = [:]
        var paddingContainerChildren: [ObjectIdentifier: Widget] = [:]
    }

    private var internalState: InternalState

    public init(appIdentifier: String) {
        internalState = InternalState()
    }

    public func run<AppRoot: App>(
        _ app: AppRoot,
        _ setViewGraph: @escaping (ViewGraph<AppRoot>) -> Void
    ) where AppRoot.Backend == Self {
        let application = QApplication()

        let viewGraph = ViewGraph(for: app, backend: self)
        setViewGraph(viewGraph)

        // TODO: app.windowProperties
        let mainWindow = MainWindow()
        mainWindow.setProperties(app.windowProperties)
        mainWindow.setRoot(viewGraph.rootNode.widget)
        mainWindow.show()

        _ = application.exec()
    }

    public func runInMainThread(action: @escaping () -> Void) {
        DispatchQueue.main.async {
            action()
        }
    }

    public func show(_ widget: Widget) {
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

    func setRoot(_ widget: QWidget) {
        centralWidget = widget
    }
}
