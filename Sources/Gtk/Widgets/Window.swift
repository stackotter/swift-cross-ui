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

    @GObjectProperty(named: "resizable") public var resizable: Bool

    private var _titleBar: Widget?
    public var titlebar: Widget? {
        get { return _titleBar }
        set { gtk_window_set_titlebar(castedPointer(), newValue?.widgetPointer) }
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
