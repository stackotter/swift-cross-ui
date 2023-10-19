import Foundation
import SwiftCrossUI
import TermKit

public struct CursesBackend: AppBackend {
    public typealias Widget = TermKit.View

    public init(appIdentifier: String) {}

    public func run<AppRoot: App>(
        _ app: AppRoot,
        _ setViewGraph: @escaping (ViewGraph<AppRoot>) -> Void
    ) where AppRoot.Backend == Self {
        let viewGraph = ViewGraph(for: app, backend: self)
        setViewGraph(viewGraph)

        Application.prepare()
        let root = RootView()
        root.addSubview(viewGraph.rootNode.widget)
        Application.top.addSubview(root)
        Application.run()
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

    public func show(_ widget: Widget) {
        widget.setNeedsDisplay()
    }

    public func createVStack(spacing: Int) -> Widget {
        return View()
    }

    public func addChild(_ child: Widget, toVStack container: Widget) {
        // TODO: Properly calculate layout
        child.y = Pos.at(container.subviews.count)
        container.addSubview(child)
    }

    public func setSpacing(ofVStack container: Widget, to spacing: Int) {}

    public func createHStack(spacing: Int) -> Widget {
        return View()
    }

    public func addChild(_ child: Widget, toHStack container: Widget) {
        // TODO: Properly calculate layout
        child.y = Pos.at(container.subviews.count)
        container.addSubview(child)
    }

    public func setSpacing(ofHStack container: Widget, to spacing: Int) {}

    public func createTextView(content: String, shouldWrap: Bool) -> Widget {
        let label = Label(content)
        label.width = Dim.fill()
        return label
    }

    public func setContent(ofTextView textView: Widget, to content: String) {
        let label = textView as! Label
        label.text = content
    }

    public func setWrap(ofTextView textView: Widget, to shouldWrap: Bool) {}

    public func createButton(label: String, action: @escaping () -> Void) -> Widget {
        let button = TermKit.Button(label, clicked: action)
        button.height = Dim.sized(1)
        return button
    }

    public func setLabel(ofButton button: Widget, to label: String) {
        (button as! TermKit.Button).text = label
    }

    public func setAction(ofButton button: Widget, to action: @escaping () -> Void) {
        (button as! TermKit.Button).clicked = { _ in
            action()
        }
    }

    // TODO: Properly implement padding container. Perhaps use a conversion factor to
    //   convert the pixel values to 'characters' of padding
    public func createPaddingContainer(for child: Widget) -> Widget {
        return child
    }

    public func getChild(ofPaddingContainer container: Widget) -> Widget {
        return container
    }

    public func setPadding(
        ofPaddingContainer container: Widget,
        top: Int,
        bottom: Int,
        leading: Int,
        trailing: Int
    ) {}
}

class RootView: TermKit.View {
    override func processKey(event: KeyEvent) -> Bool {
        if super.processKey(event: event) {
            return true
        }

        switch event.key {
            case .controlC, .esc:
                Application.requestStop()
                return true
            default:
                return false
        }
    }
}
