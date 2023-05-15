import CGtk

public class Scale: Widget {
    public override init() {
        super.init()
        widgetPointer = gtk_scale_new(Orientation.horizontal.toGtkOrientation(), nil)
    }

    override func didMoveToParent() {
        super.didMoveToParent()

        addSignal(name: "value-changed") { [weak self] in
            guard let self = self else { return }
            self.changed?(self)
        }
    }

    public var value: Double {
        get {
            return gtk_range_get_value(castedPointer())
        }
        set {
            gtk_range_set_value(castedPointer(), newValue)
        }
    }

    public var minimum: Double {
        get {
            let adjustment = gtk_range_get_adjustment(castedPointer())
            return gtk_adjustment_get_lower(adjustment)
        }
        set {
            let adjustment = gtk_range_get_adjustment(castedPointer())
            gtk_adjustment_set_lower(adjustment, newValue)
        }
    }

    public var maximum: Double {
        get {
            let adjustment = gtk_range_get_adjustment(castedPointer())
            return gtk_adjustment_get_upper(adjustment)
        }
        set {
            let adjustment = gtk_range_get_adjustment(castedPointer())
            gtk_adjustment_set_upper(adjustment, newValue)
        }
    }

    public var decimalPlaces: Int {
        get {
            return Int(gtk_scale_get_digits(castedPointer()))
        }
        set {
            gtk_scale_set_digits(castedPointer(), gint(newValue))
        }
    }

    public var changed: ((Scale) -> Void)?
}
