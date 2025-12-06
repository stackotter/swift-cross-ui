import CGtk

extension SpinButton {
    public func setRange(min: Double, max: Double) {
        gtk_spin_button_set_range(opaquePointer, min, max)
    }
}
