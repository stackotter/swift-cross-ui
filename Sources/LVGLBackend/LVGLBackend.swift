import CLVGL
import Foundation
import LVGL
import SwiftCrossUI

public struct LVGLBackend: AppBackend {
    public class Widget {
        private var createWithParent: (LVObject) -> LVObject
        var widget: LVObject?

        init(createWithParent: @escaping (LVObject) -> LVObject) {
            self.createWithParent = createWithParent
            widget = nil
        }

        func postCreationAction(_ action: @escaping (LVObject) -> Void) {
            if let widget = widget {
                action(widget)
            } else {
                let create = createWithParent
                self.createWithParent = { parent in
                    let widget = create(parent)
                    action(widget)
                    return widget
                }
            }
        }

        func create(withParent parent: LVObject) -> LVObject {
            if let widget = widget {
                return widget
            }

            let widget = createWithParent(parent)
            self.widget = widget
            return widget
        }
    }

    public typealias Window = LVScreen

    public class Grid: Widget {
        var rowCount = 0
        var columnCount = 0
    }

    private let runLoop: LVRunLoop

    public init(appIdentifier: String) {
        runLoop = LVRunLoop.shared
    }

    public func createRootWindow(
        _ properties: WindowProperties,
        _ callback: @escaping (Window) -> Void
    ) {
        callback(LVScreen.active)
    }

    public func setChild(ofWindow window: Window, to child: Widget) {
        _ = child.create(withParent: window)
    }

    public func show(window: Window) {}

    public func runMainLoop() {
        runLoop.run()
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

    public func show(widget: Widget) {}

    public func createVStack(spacing: Int) -> Widget {
        let grid = Grid { parent in
            let grid = LVGrid(with: parent, rows: 0, columns: 1, padding: Int16(spacing))
            grid.size = LVSize(width: 1 << 13 | 2001, height: 1 << 13 | 2001)
            grid.center()
            return grid
        }
        grid.columnCount = 1
        return grid
    }

    public func addChild(_ child: Widget, toVStack container: Widget) {
        container.postCreationAction { widget in
            let rowCount = (container as! Grid).rowCount
            let grid = widget as! LVGrid
            grid.resize(rows: UInt8(rowCount + 1), columns: 1)
            // LVGL grid coordinates have column before row (weird)
            grid.set(cell: child.create(withParent: widget), at: (0, UInt8(rowCount)))
            (container as! Grid).rowCount += 1
        }
    }

    public func setSpacing(ofVStack container: Widget, to spacing: Int) {
        container.postCreationAction { widget in
            let rowCount = (container as! Grid).rowCount
            let grid = widget as! LVGrid
            grid.resize(rows: UInt8(rowCount), columns: 1, padding: Int16(spacing))
        }
    }

    public func createHStack(spacing: Int) -> Widget {
        let grid = Grid { parent in
            let grid = LVGrid(with: parent, rows: 1, columns: 0, padding: Int16(spacing))
            grid.size = LVSize(width: 1 << 13 | 2001, height: 1 << 13 | 2001)
            grid.center()
            return grid
        }
        grid.rowCount = 1
        return grid
    }

    public func addChild(_ child: Widget, toHStack container: Widget) {
        container.postCreationAction { widget in
            let columnCount = (container as! Grid).columnCount
            let grid = widget as! LVGrid
            grid.resize(rows: 1, columns: UInt8(columnCount + 1))
            // LVGL grid coordinates have column before row (weird)
            grid.set(cell: child.create(withParent: widget), at: (UInt8(columnCount), 0))
            (container as! Grid).columnCount += 1
        }
    }

    public func setSpacing(ofHStack container: Widget, to spacing: Int) {
        container.postCreationAction { widget in
            let columnCount = (container as! Grid).columnCount
            let grid = widget as! LVGrid
            grid.resize(rows: 1, columns: UInt8(columnCount), padding: Int16(spacing))
        }
    }

    public func createTextView(content: String, shouldWrap: Bool) -> Widget {
        return Widget { parent in
            let label = LVLabel(with: parent)
            label.text = content
            return label
        }
    }

    public func setContent(ofTextView textView: Widget, to content: String) {
        textView.postCreationAction { widget in
            (widget as! LVLabel).text = content
        }
    }

    public func setWrap(ofTextView textView: Widget, to shouldWrap: Bool) {
        // TODO: Implement text wrap option
    }

    public func createButton(label: String, action: @escaping () -> Void) -> Widget {
        return Widget { parent in
            let button = LVButton(with: parent)
            let buttonLabel = LVLabel(with: button)
            buttonLabel.text = label
            buttonLabel.center()
            button.onEvent = { event in
                if event.code == LV_EVENT_PRESSED {
                    action()
                }
            }
            return button
        }
    }

    public func setLabel(ofButton button: Widget, to label: String) {
        button.postCreationAction { widget in
            let widget = widget as! LVButton
            (widget.child(at: 0)! as! LVLabel).text = label
        }
    }

    public func setAction(ofButton button: Widget, to action: @escaping () -> Void) {
        button.postCreationAction { widget in
            let widget = widget as! LVButton
            widget.onEvent = { event in
                if event.code == LV_EVENT_PRESSED {
                    action()
                }
            }
        }
    }
}
