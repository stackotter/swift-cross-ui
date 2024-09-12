//
//  Copyright © 2015 Tomas Linhart. All rights reserved.
//

import CGtk

public class Window: Widget {
    var child: Widget?

    override public init() {
        super.init()
        widgetPointer = gtk_window_new()
    }

    private init(pointer: UnsafeMutablePointer<GtkWidget>) {
        super.init()
        self.widgetPointer = pointer
    }

    // public static var rootWindow: Window {
    //     gdk_display_get_default()
    //     return Window(pointer: UnsafeMutablePointer<GtkWidget>(gdk_screen_get_root_window(gdk_screen_get_default())))
    // }

    @GObjectProperty(named: "title") public var title: String?

    public var defaultSize: Size {
        get {
            var width: gint = 0
            var height: gint = 0
            gtk_window_get_default_size(castedPointer(), &width, &height)

            return Size(width: Int(width), height: Int(height))
        }
        set(size) {
            gtk_window_set_default_size(castedPointer(), gint(size.width), gint(size.height))
        }
    }

    public var size: Size {
        get {
            // TODO: The default size is the current size of the window unless we're
            //   in full screen. But we can't simply use the widget size, cause that
            //   doesn't work before the first proper update or something like that.
            defaultSize
        }
        set {
            // We set the 'default size' here because setting the size of the window
            // actually sets the window's minimum size. Whereas the 'default size' is
            // just the current size of the window, except when the window is in full
            // screen, in which case the 'default size' is the size that the window
            // should return to when it leaves full screen.
            defaultSize = newValue
        }
    }

    @GObjectProperty(named: "resizable") public var resizable: Bool

    private var _titleBar: Widget?
    public var titlebar: Widget? {
        get { return _titleBar }
        set { gtk_window_set_titlebar(castedPointer(), newValue?.widgetPointer) }
    }

    public func setMinimumSize(to minimumSize: Size) {
        gtk_widget_set_size_request(
            castedPointer(),
            gint(minimumSize.width),
            gint(minimumSize.height)
        )
    }

    public func onResize(_ action: @escaping () -> Void) {
        // let native = GTK_NATIVE(castedPointer())!
        // let surface = gtk_native_get_surface(native)

        // let box = SignalBox0(callback: action)
        // let handler1:
        //     @convention(c) (
        //         UnsafeMutableRawPointer, UnsafeMutableRawPointer
        //     ) -> Void = { _, data in
        //         let box = Unmanaged<SignalBox0>.fromOpaque(data).takeUnretainedValue()
        //         box.callback()
        //     }

        // g_signal_connect_data(
        //     UnsafeMutableRawPointer(surface!),
        //     "notify::state",
        //     unsafeBitCast(handler1, to: GCallback.self),
        //     Unmanaged.passUnretained(box).toOpaque().cast(),
        //     nil,
        //     ConnectFlags.after.toGConnectFlags()
        // )

        let handler2:
            @convention(c) (
                UnsafeMutableRawPointer, OpaquePointer, UnsafeMutableRawPointer
            ) -> Void = { _, value1, data in
                SignalBox1<OpaquePointer>.run(data, value1)
            }

        addSignal(name: "notify::default-width", handler: gCallback(handler2)) {
            (_: OpaquePointer) in
            action()
        }

        addSignal(name: "notify::default-height", handler: gCallback(handler2)) {
            (_: OpaquePointer) in
            action()
        }
    }

    public func setChild(_ child: Widget) {
        self.child?.parentWidget = nil
        self.child = child
        gtk_window_set_child(castedPointer(), child.widgetPointer)
        child.parentWidget = self
    }

    public func removeChild() {
        gtk_window_set_child(castedPointer(), nil)
        child?.parentWidget = nil
        child = nil
    }

    public func getChild() -> Widget? {
        return child
    }
}
