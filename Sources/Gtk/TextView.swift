//
//  Copyright © 2016 Tomas Linhart. All rights reserved.
//

import CGtk

public class TextView: Widget {
    public override init() {
        super.init()

        widgetPointer = gtk_text_view_new()
    }

    override func didMoveToParent() {
        super.didMoveToParent()

        addSignal(name: "backspace") { [weak self] in
            guard let self = self else { return }
            self.backspace?(self)
        }
        addSignal(name: "copy-clipboard") { [weak self] in
            guard let self = self else { return }
            self.copyClipboard?(self)
        }
        addSignal(name: "cut-clipboard") { [weak self] in
            guard let self = self else { return }
            self.cutClipboard?(self)
        }
        addSignal(name: "paste-clipboard") { [weak self] in
            guard let self = self else { return }
            self.pasteClipboard?(self)
        }

        addSignal(name: "insert-at-cursor") { [weak self] (pointer: UnsafeMutableRawPointer) in
            guard let self = self else { return }
            let pointer = UnsafeRawPointer(pointer).bindMemory(to: CChar.self, capacity: 1)
            let string = String(cString: pointer)
            self.insertAtCursor?(self, string)
        }

        addSignal(name: "preedit-changed") { [weak self] (pointer: UnsafeMutableRawPointer) in
            guard let self = self else { return }
            let pointer = UnsafeRawPointer(pointer).bindMemory(to: CChar.self, capacity: 1)
            let string = String(cString: pointer)
            self.preeditChanged?(self, string)
        }

        addSignal(name: "select-all") { [weak self] (pointer: UnsafeMutableRawPointer) in
            guard let self = self else { return }
            // We need to get actual value of the pointer because it is not pointer but only integer.
            let select = Int(bitPattern: pointer).toBool()
            self.selectAll?(self, select)
        }
    }

    public var editable: Bool {
        get {
            return gtk_text_view_get_editable(castedPointer()).toBool()
        }
        set {
            gtk_text_view_set_editable(castedPointer(), newValue.toGBoolean())
        }
    }

    // MARK: - Signals

    public var backspace: ((TextView) -> Void)?
    public var pasteClipboard: ((TextView) -> Void)?
    public var cutClipboard: ((TextView) -> Void)?
    public var copyClipboard: ((TextView) -> Void)?
    public var selectAll: ((TextView, Bool) -> Void)?
    public var preeditChanged: ((TextView, String) -> Void)?
    public var insertAtCursor: ((TextView, String) -> Void)?
}
