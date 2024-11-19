import CGtk3

public class Viewport: Bin {
    public override init() {
        super.init()
        widgetPointer = gtk_viewport_new(nil, nil)
    }
}
