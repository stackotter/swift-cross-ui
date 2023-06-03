import CGtk

open class Paned: Widget, Orientable {
    public init(orientation: Orientation) {
        super.init()
        widgetPointer = gtk_paned_new(orientation.toGtkOrientation())
    }

    public var startChild: Widget? {
        didSet {
            oldValue?.parentWidget = nil
            gtk_paned_set_start_child(opaquePointer, startChild?.castedPointer())
            startChild?.parentWidget = self
        }
    }

    public var endChild: Widget? {
        didSet {
            oldValue?.parentWidget = nil
            gtk_paned_set_end_child(opaquePointer, endChild?.castedPointer())
            endChild?.parentWidget = self
        }
    }

    public var position: Int {
        get {
            Int(gtk_paned_get_position(opaquePointer))
        }
        set {
            gtk_paned_set_position(opaquePointer, gint(newValue))
        }
    }

    public var shrinkStartChild: Bool {
        get {
            gtk_paned_get_shrink_start_child(opaquePointer).toBool()
        }
        set {
            gtk_paned_set_shrink_start_child(opaquePointer, newValue.toGBoolean())
        }
    }

    public var shrinkEndChild: Bool {
        get {
            gtk_paned_get_shrink_end_child(opaquePointer).toBool()
        }
        set {
            gtk_paned_set_shrink_end_child(opaquePointer, newValue.toGBoolean())
        }
    }
}
