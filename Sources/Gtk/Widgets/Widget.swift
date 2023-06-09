//
//  Copyright © 2015 Tomas Linhart. All rights reserved.
//

import CGtk
import Foundation

open class Widget: GObjectRepresentable {
    private var signals: [(UInt, Any)] = []
    var widgetPointer: UnsafeMutablePointer<GtkWidget>?

    public var gobjectPointer: UnsafeMutablePointer<GObject> {
        return widgetPointer!.cast()
    }

    public var opaquePointer: OpaquePointer? {
        return OpaquePointer(widgetPointer)
    }

    public weak var parentWidget: Widget? {
        willSet {

        }
        didSet {
            if parentWidget != nil {
                didMoveToParent()
            } else {
                didMoveFromParent()
                removeSignals()
            }
        }
    }

    init() {
        widgetPointer = nil
    }

    private func removeSignals() {
        for (handlerId, _) in signals {
            disconnectSignal(widgetPointer, handlerId: handlerId)
        }

        signals = []
    }

    func didMoveToParent() {

    }

    func didMoveFromParent() {

    }

    /// Adds a signal that is not carrying any additional information.
    func addSignal(name: String, callback: @escaping SignalCallbackZero) {
        let box = SignalBoxZero(callback: callback)
        let handler:
            @convention(c) (
                UnsafeMutableRawPointer,
                UnsafeMutableRawPointer
            ) -> Void = { _, data in
                let box = unsafeBitCast(data, to: SignalBoxZero.self)
                box.callback()
            }

        let handlerId = connectSignal(
            widgetPointer,
            name: name,
            data: Unmanaged.passUnretained(box).toOpaque(),
            handler: unsafeBitCast(handler, to: GCallback.self)
        )

        signals.append((handlerId, box))
    }

    func addSignal(name: String, callback: @escaping SignalCallbackOne) {
        let box = SignalBoxOne(callback: callback)
        let handler:
            @convention(c) (
                UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer
            ) -> Void = { _, pointer, data in
                let box = unsafeBitCast(data, to: SignalBoxOne.self)
                box.callback(pointer)
            }

        let handlerId = connectSignal(
            widgetPointer,
            name: name,
            data: Unmanaged.passUnretained(box).toOpaque(),
            handler: unsafeBitCast(handler, to: GCallback.self)
        )

        signals.append((handlerId, box))
    }

    func addSignal(name: String, callback: @escaping SignalCallbackTwo) {
        let box = SignalBoxTwo(callback: callback)
        let handler:
            @convention(c) (
                UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer,
                UnsafeMutableRawPointer
            ) -> Void = { _, pointer1, pointer2, data in
                let box = unsafeBitCast(data, to: SignalBoxTwo.self)
                box.callback(pointer1, pointer2)
            }

        let handlerId = connectSignal(
            widgetPointer,
            name: name,
            data: Unmanaged.passUnretained(box).toOpaque(),
            handler: unsafeBitCast(handler, to: GCallback.self)
        )

        signals.append((handlerId, box))
    }

    func addSignal(name: String, callback: @escaping SignalCallbackThree) {
        let box = SignalBoxThree(callback: callback)
        let handler:
            @convention(c) (
                UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer,
                UnsafeMutableRawPointer, UnsafeMutableRawPointer
            ) -> Void = { _, pointer1, pointer2, pointer3, data in
                let box = unsafeBitCast(data, to: SignalBoxThree.self)
                box.callback(pointer1, pointer2, pointer3)
            }

        let handlerId = connectSignal(
            widgetPointer,
            name: name,
            data: Unmanaged.passUnretained(box).toOpaque(),
            handler: unsafeBitCast(handler, to: GCallback.self)
        )

        signals.append((handlerId, box))
    }

    func addSignal(name: String, callback: @escaping SignalCallbackFour) {
        let box = SignalBoxFour(callback: callback)
        let handler:
            @convention(c) (
                UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer,
                UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer
            ) -> Void = { _, pointer1, pointer2, pointer3, pointer4, data in
                let box = unsafeBitCast(data, to: SignalBoxFour.self)
                box.callback(pointer1, pointer2, pointer3, pointer4)
            }

        let handlerId = connectSignal(
            widgetPointer,
            name: name,
            data: Unmanaged.passUnretained(box).toOpaque(),
            handler: unsafeBitCast(handler, to: GCallback.self)
        )

        signals.append((handlerId, box))
    }

    func addSignal(name: String, callback: @escaping SignalCallbackFive) {
        let box = SignalBoxFive(callback: callback)
        let handler:
            @convention(c) (
                UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer,
                UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer,
                UnsafeMutableRawPointer
            ) -> Void = { _, pointer1, pointer2, pointer3, pointer4, pointer5, data in
                let box = unsafeBitCast(data, to: SignalBoxFive.self)
                box.callback(pointer1, pointer2, pointer3, pointer4, pointer5)
            }

        let handlerId = connectSignal(
            widgetPointer,
            name: name,
            data: Unmanaged.passUnretained(box).toOpaque(),
            handler: unsafeBitCast(handler, to: GCallback.self)
        )

        signals.append((handlerId, box))
    }

    func addSignal(name: String, callback: @escaping SignalCallbackSix) {
        let box = SignalBoxSix(callback: callback)
        let handler:
            @convention(c) (
                UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer,
                UnsafeMutableRawPointer, UnsafeMutableRawPointer, UnsafeMutableRawPointer,
                UnsafeMutableRawPointer, UnsafeMutableRawPointer
            ) -> Void = { _, pointer1, pointer2, pointer3, pointer4, pointer5, pointer6, data in
                let box = unsafeBitCast(data, to: SignalBoxSix.self)
                box.callback(pointer1, pointer2, pointer3, pointer4, pointer5, pointer6)
            }

        let handlerId = connectSignal(
            widgetPointer,
            name: name,
            data: Unmanaged.passUnretained(box).toOpaque(),
            handler: unsafeBitCast(handler, to: GCallback.self)
        )

        signals.append((handlerId, box))
    }

    /// A block of CSS for this widget
    public lazy var css: CSSBlock = CSSBlock(forCssClass: customCssClass) {
        didSet {
            guard oldValue != css else { return }
            cssProvider.loadCss(from: css.stringRepresentation)
        }
    }

    /// Unique CSS class for this widget
    private lazy var customCssClass: String = {
        let className = ObjectIdentifier(self).debugDescription
            .replacingOccurrences(of: "ObjectIdentifier(0x", with: "class_")
            .replacingOccurrences(of: ")", with: "")
        gtk_widget_add_css_class(widgetPointer, className)
        return className
    }()

    /// A CSS provider specifically for this widget. Will get removed when
    /// it deinits.
    private lazy var cssProvider = CSSProvider()

    public func show() {
        gtk_widget_set_visible(widgetPointer, true.toGBoolean())
    }

    public func hide() {
        gtk_widget_set_visible(widgetPointer, false.toGBoolean())
    }

    @GObjectProperty(named: "name") public var name: String?

    @GObjectProperty(named: "opacity") public var opacity: Double

    @GObjectProperty(named: "margin-top") public var topMargin: Int
    @GObjectProperty(named: "margin-bottom") public var bottomMargin: Int
    @GObjectProperty(named: "margin-start") public var leadingMargin: Int
    @GObjectProperty(named: "margin-end") public var trailingMargin: Int

    public var horizontalAlignment: Align {
        get {
            return gtk_widget_get_halign(castedPointer()).toAlign()
        }
        set {
            gtk_widget_set_halign(castedPointer(), newValue.toGtkAlign())
        }
    }

    public var verticalAlignment: Align {
        get {
            return gtk_widget_get_valign(castedPointer()).toAlign()
        }
        set {
            gtk_widget_set_valign(castedPointer(), newValue.toGtkAlign())
        }
    }

    /// Whether to expand horizontally.
    @GObjectProperty(named: "hexpand") public var expandHorizontally: Bool
    /// Whether to use the expandHorizontally property.
    @GObjectProperty(named: "hexpand-set") public var useExpandHorizontally: Bool
    /// Whether to expand vertically.
    @GObjectProperty(named: "vexpand") public var expandVertically: Bool
    /// Whether to use the expandVertically property.
    @GObjectProperty(named: "vexpand-set") public var useExpandVertically: Bool

    /// Set to -1 for no min width request
    @GObjectProperty(named: "width-request") public var minWidth: Int
    /// Set to -1 for no min heigth request
    @GObjectProperty(named: "height-request") public var minHeight: Int

    /// Sets the name of the Gtk view for useful debugging in inspector (Ctrl+Shift+D)
    open func debugName<View>(_: View.Type) -> Self {
        #if DEBUG
            // Limited type depth because the inspector does not like long names
            name = String(describing: Self.self) + " " + typeDescription(of: View.self, withMaxDepth: 3)
        #endif
        return self
    }
}
