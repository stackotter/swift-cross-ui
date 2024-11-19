//
//  Copyright © 2015 Tomas Linhart. All rights reserved.
//

import CGtk3
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

    func removeSignals() {
        for (handlerId, _) in signals {
            disconnectSignal(widgetPointer, handlerId: handlerId)
        }

        signals = []
    }

    func didMoveToParent() {}

    func didMoveFromParent() {}

    /// Adds a signal that is not carrying any additional information.
    func addSignal(name: String, callback: @escaping () -> Void) {
        let box = SignalBox0(callback: callback)
        let handler:
            @convention(c) (
                UnsafeMutableRawPointer, UnsafeMutableRawPointer
            ) -> Void = { _, data in
                let box = Unmanaged<SignalBox0>.fromOpaque(data).takeUnretainedValue()
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

    func addSignal<T1>(name: String, handler: GCallback, callback: @escaping (T1) -> Void) {
        let box = SignalBox1(callback: callback)

        let handlerId = connectSignal(
            widgetPointer,
            name: name,
            data: Unmanaged.passUnretained(box).toOpaque(),
            handler: handler
        )

        signals.append((handlerId, box))
    }

    func addSignal<T1, T2>(name: String, handler: GCallback, callback: @escaping (T1, T2) -> Void) {
        let box = SignalBox2(callback: callback)

        let handlerId = connectSignal(
            widgetPointer,
            name: name,
            data: Unmanaged.passUnretained(box).toOpaque(),
            handler: handler
        )

        signals.append((handlerId, box))
    }

    func addSignal<T1, T2, T3>(
        name: String, handler: GCallback, callback: @escaping (T1, T2, T3) -> Void
    ) {
        let box = SignalBox3(callback: callback)

        let handlerId = connectSignal(
            widgetPointer,
            name: name,
            data: Unmanaged.passUnretained(box).toOpaque(),
            handler: handler
        )

        signals.append((handlerId, box))
    }

    func addSignal<T1, T2, T3, T4>(
        name: String, handler: GCallback, callback: @escaping (T1, T2, T3, T4) -> Void
    ) {
        let box = SignalBox4(callback: callback)

        let handlerId = connectSignal(
            widgetPointer,
            name: name,
            data: Unmanaged.passUnretained(box).toOpaque(),
            handler: handler
        )

        signals.append((handlerId, box))
    }

    func addSignal<T1, T2, T3, T4, T5>(
        name: String, handler: GCallback, callback: @escaping (T1, T2, T3, T4, T5) -> Void
    ) {
        let box = SignalBox5(callback: callback)

        let handlerId = connectSignal(
            widgetPointer,
            name: name,
            data: Unmanaged.passUnretained(box).toOpaque(),
            handler: handler
        )

        signals.append((handlerId, box))
    }

    func addSignal<T1, T2, T3, T4, T5, T6>(
        name: String, handler: GCallback, callback: @escaping (T1, T2, T3, T4, T5, T6) -> Void
    ) {
        let box = SignalBox6(callback: callback)

        let handlerId = connectSignal(
            widgetPointer,
            name: name,
            data: Unmanaged.passUnretained(box).toOpaque(),
            handler: handler
        )

        signals.append((handlerId, box))
    }

    /// The CSS rules applied directly to this widget.
    public lazy var css: CSSBlock = CSSBlock(forClass: customCSSClass) {
        didSet {
            guard oldValue != css else { return }
            cssProvider.loadCss(from: css.stringRepresentation)
        }
    }

    /// A unique CSS class for this widget. The class is lazily added to the
    /// widget when this property is first accessed.
    private lazy var customCSSClass: String = {
        let className = ObjectIdentifier(self).debugDescription
            .replacingOccurrences(of: "ObjectIdentifier(0x", with: "class_")
            .replacingOccurrences(of: ")", with: "")
        let context = gtk_widget_get_style_context(widgetPointer)
        gtk_style_context_add_class(context, className)
        return className
    }()

    /// A CSS provider specifically for this widget. Will get removed when
    /// it deinits.
    public lazy var cssProvider = CSSProvider(
        forContext: gtk_widget_get_style_context(widgetPointer)
    )

    public func showAll() {
        gtk_widget_show_all(widgetPointer)
    }

    public func show() {
        gtk_widget_show(widgetPointer)
    }

    public func hide() {
        gtk_widget_show(widgetPointer)
    }

    public func setSizeRequest(width: Int, height: Int) {
        gtk_widget_set_size_request(widgetPointer, Int32(width), Int32(height))
    }

    public func getSizeRequest() -> Size {
        var width: Int32 = 0
        var height: Int32 = 0
        gtk_widget_get_size_request(widgetPointer, &width, &height)
        return Size(width: Int(width), height: Int(height))
    }

    public func getNaturalSize() -> (width: Int, height: Int) {
        var minimumSize = GtkRequisition()
        var naturalSize = GtkRequisition()
        gtk_widget_get_preferred_size(widgetPointer, &minimumSize, &naturalSize)
        return (
            width: Int(naturalSize.width),
            height: Int(naturalSize.height)
        )
    }

    @GObjectProperty(named: "name") public var name: String?

    @GObjectProperty(named: "opacity") public var opacity: Double

    @GObjectProperty(named: "margin-top") public var marginTop: Int

    @GObjectProperty(named: "margin-bottom") public var marginBottom: Int

    @GObjectProperty(named: "margin-start") public var marginStart: Int

    @GObjectProperty(named: "margin-end") public var marginEnd: Int

    @GObjectProperty(named: "halign") public var horizontalAlignment: Align

    @GObjectProperty(named: "valign") public var verticalAlignment: Align

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

    /// Set to -1 for no min height request
    @GObjectProperty(named: "height-request") public var minHeight: Int

    /// Sets the name of the Gtk view for useful debugging in inspector (Ctrl+Shift+D)
    public func tag(as tag: String) {
        name = tag
    }
}
