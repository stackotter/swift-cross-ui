import CGtk

extension Scale {
    public convenience init(_ orientation: Orientation = .horizontal) {
        self.init(orientation: orientation.toGtk(), adjustment: nil)
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
}
