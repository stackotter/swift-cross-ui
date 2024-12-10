//
//  Copyright © 2015 Tomas Linhart. All rights reserved.
//

import CGtk3

public class Window: Bin {
    override public init() {
        super.init()
        widgetPointer = gtk_window_new(GTK_WINDOW_TOPLEVEL)
    }

    private init(pointer: UnsafeMutablePointer<GtkWidget>) {
        super.init()
        self.widgetPointer = pointer
    }

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
            defaultSize = Size(
                width: newValue.width,
                height: newValue.height
            )
            gtk_window_resize(castedPointer(), gint(newValue.width), gint(newValue.height))
        }
    }

    @GObjectProperty(named: "resizable") public var resizable: Bool

    public func setMinimumSize(to minimumSize: Size) {
        gtk_widget_set_size_request(
            castedPointer(),
            gint(minimumSize.width),
            gint(minimumSize.height)
        )
    }
}
