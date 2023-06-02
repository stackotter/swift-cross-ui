//
//  Copyright © 2015 Tomas Linhart. All rights reserved.
//

import CGtk
import Foundation

open class Widget {
    private var signals: [(UInt, Any)] = []
    var widgetPointer: UnsafeMutablePointer<GtkWidget>?

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

    public func setForegroundColor(color: Color) {
        let className = String("class-\(UUID().uuidString)").replacingOccurrences(
            of: "-",
            with: "_"
        )
        className.withCString { string in
            gtk_widget_add_css_class(widgetPointer, string)
        }

        let css =
            ".\(className){color:rgba(\(color.red*255),\(color.green*255),\(color.blue*255),\(color.alpha*255));}"
        let provider = CssProvider()
        provider.loadFromData(css)
        addCssProvider(provider)
    }

    public func addCssProvider(_ provider: CssProvider) {
        gtk_style_context_add_provider_for_display(
            gdk_display_get_default(),
            OpaquePointer(provider.pointer),
            UInt32(GTK_STYLE_PROVIDER_PRIORITY_APPLICATION)
        )
    }

    public func show() {
        gtk_widget_set_visible(widgetPointer, true.toGBoolean())
    }

    public func hide() {
        gtk_widget_set_visible(widgetPointer, false.toGBoolean())
    }

    public var opacity: Double {
        get {
            return gtk_widget_get_opacity(widgetPointer)
        }
        set {
            gtk_widget_set_opacity(widgetPointer, newValue)
        }
    }

    public var topMargin: Int {
        get {
            return Int(gtk_widget_get_margin_top(widgetPointer))
        }
        set {
            gtk_widget_set_margin_top(widgetPointer, gint(newValue))
        }
    }

    public var bottomMargin: Int {
        get {
            return Int(gtk_widget_get_margin_bottom(widgetPointer))
        }
        set {
            gtk_widget_set_margin_bottom(widgetPointer, gint(newValue))
        }
    }

    public var leadingMargin: Int {
        get {
            return Int(gtk_widget_get_margin_start(widgetPointer))
        }
        set {
            gtk_widget_set_margin_start(widgetPointer, gint(newValue))
        }
    }

    public var trailingMargin: Int {
        get {
            return Int(gtk_widget_get_margin_end(widgetPointer))
        }
        set {
            gtk_widget_set_margin_end(widgetPointer, gint(newValue))
        }
    }

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

    public var expandHorizontally: Bool {
        get {
            return gtk_widget_get_hexpand(castedPointer()) != 0
        }
        set {
            gtk_widget_set_hexpand(castedPointer(), newValue ? 1 : 0)
        }
    }

    public var expandVertically: Bool {
        get {
            return gtk_widget_get_vexpand(castedPointer()) != 0
        }
        set {
            gtk_widget_set_vexpand(castedPointer(), newValue ? 1 : 0)
        }
    }


    /// -1 for no min size request
    public var sizeRequest: (width: Int, height: Int) {
        get {
            var w: Int32 = -1, h: Int32 = -1
            gtk_widget_get_size_request(castedPointer(), &w, &h)
            return (Int(w), Int(h))
        }
        set {
            gtk_widget_set_size_request(castedPointer(), Int32(newValue.width), Int32(newValue.height))
        }
    }
}
