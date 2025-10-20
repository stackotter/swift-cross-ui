//
//  Copyright © 2015 Tomas Linhart. All rights reserved.
//

import CGtk

open class Window: Widget {
    public var child: Widget?

    public convenience init() {
        self.init(gtk_window_new())
    }

    @GObjectProperty(named: "title") public var title: String?
    @GObjectProperty(named: "resizable") public var resizable: Bool
    @GObjectProperty(named: "modal") public var isModal: Bool
    @GObjectProperty(named: "decorated") public var isDecorated: Bool

    public func setTransient(for other: Window) {
        gtk_window_set_transient_for(castedPointer(), other.castedPointer())
    }

    /// The window must not be used after destruction.
    public func destroy() {
        gtk_window_destroy(castedPointer())
    }

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

    public func setMinimumSize(to minimumSize: Size) {
        gtk_widget_set_size_request(
            castedPointer(),
            gint(minimumSize.width),
            gint(minimumSize.height)
        )
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

    public func present() {
        gtk_window_present(castedPointer())
        
        addSignal(name: "close-request") { [weak self] () in
            guard let self = self else { return }
            self.onCloseRequest?(self)
        }
    }

    public func setEscapeKeyPressedHandler(to handler: (() -> Void)?) {
        if let data = escapeKeyHandlerData {
            Unmanaged<ValueBox<() -> Void>>.fromOpaque(data).release()
            escapeKeyHandlerData = nil
        }
        
        if let oldController = escapeKeyEventController {
            gtk_widget_remove_controller(widgetPointer, oldController)
            escapeKeyEventController = nil
        }
        
        escapeKeyPressed = handler
        
        guard handler != nil else { return }
        
        let keyEventController = gtk_event_controller_key_new()
        gtk_event_controller_set_propagation_phase(keyEventController, GTK_PHASE_BUBBLE)
        
        let thunk: @convention(c) (
            UnsafeMutableRawPointer?, guint, guint, GdkModifierType, gpointer?
        ) -> gboolean = { _, keyval, _, _, userData in
            if keyval == GDK_KEY_Escape {
                guard let userData else { return 1 }
                let box = Unmanaged<ValueBox<() -> Void>>.fromOpaque(userData).takeUnretainedValue()
                box.value()
                return 1
            }
            return 0
        }
        
        let boxedHandler = Unmanaged.passRetained(
            ValueBox(value: handler!)
        ).toOpaque()
        
        g_signal_connect_data(
            UnsafeMutableRawPointer(keyEventController),
            "key-pressed",
            unsafeBitCast(thunk, to: GCallback.self),
            boxedHandler,
            { data, _ in
                if let data {
                    Unmanaged<ValueBox<() -> Void>>.fromOpaque(data).release()
                }
            },
            .init(0)
        )
        
        gtk_widget_add_controller(widgetPointer, keyEventController)
        escapeKeyEventController = keyEventController
        escapeKeyHandlerData = boxedHandler
    }
    
    private var escapeKeyEventController: OpaquePointer?
    private var escapeKeyHandlerData: UnsafeMutableRawPointer?
    
    public var onCloseRequest: ((Window) -> Int32)?
    public var escapeKeyPressed: (() -> Void)?
}

final class ValueBox<T> {
    let value: T
    init(value: T) {
        self.value = value
    }
}
