import CGtk

public class Scale: Widget {
    public override init() {
        super.init()
        widgetPointer = gtk_scale_new(Orientation.horizontal.toGtk(), nil)
        expandHorizontally = true
    }

    override func didMoveToParent() {
        super.didMoveToParent()

        addSignal(name: "value-changed") { [weak self] in
            guard let self = self else { return }
            self.changed?(self)
        }
    }

    public var value: Double {  // has no property
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

    @GObjectProperty(named: "digits") public var decimalPlaces: Int

    public var changed: ((Scale) -> Void)?
}
