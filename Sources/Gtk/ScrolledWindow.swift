import CGtk

public class ScrolledWindow: Widget {
    var child: Widget?

    public override init() {
        super.init()
        widgetPointer = gtk_scrolled_window_new()
    }

    override func didMoveToParent() {
        super.didMoveToParent()
    }

    public var minimumContentWidth: Int {
        get {
            return Int(gtk_scrolled_window_get_min_content_width(opaquePointer))
        }
        set {
            gtk_scrolled_window_set_min_content_width(opaquePointer, gint(newValue))
        }
    }

    public var maximumContentWidth: Int {
        get {
            return Int(gtk_scrolled_window_get_max_content_width(opaquePointer))
        }
        set {
            gtk_scrolled_window_set_max_content_width(opaquePointer, gint(newValue))
        }
    }

    public var minimumContentHeight: Int {
        get {
            return Int(gtk_scrolled_window_get_min_content_height(opaquePointer))
        }
        set {
            gtk_scrolled_window_set_min_content_height(opaquePointer, gint(newValue))
        }
    }

    public var maximumContentHeight: Int {
        get {
            return Int(gtk_scrolled_window_get_max_content_height(opaquePointer))
        }
        set {
            gtk_scrolled_window_set_max_content_height(opaquePointer, gint(newValue))
        }
    }

    public var propagateNaturalHeight: Bool {
        get {
            return gtk_scrolled_window_get_propagate_natural_height(opaquePointer).toBool()
        }
        set {
            gtk_scrolled_window_set_propagate_natural_height(opaquePointer, newValue.toGBoolean())
        }
    }

    public var propagateNaturalWidth: Bool {
        get {
            return gtk_scrolled_window_get_propagate_natural_width(opaquePointer).toBool()
        }
        set {
            gtk_scrolled_window_set_propagate_natural_width(opaquePointer, newValue.toGBoolean())
        }
    }

    public func setChild(_ child: Widget) {
        self.child?.parentWidget = nil
        self.child = child
        gtk_scrolled_window_set_child(opaquePointer, child.widgetPointer)
        child.parentWidget = self
    }

    public func removeChild() {
        gtk_scrolled_window_set_child(opaquePointer, nil)
        child?.parentWidget = nil
        child = nil
    }

    public func getChild() -> Widget? {
        return child
    }
}
