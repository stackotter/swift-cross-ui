import CGtk3

public class Viewport: Bin {
    var child: Widget?

    public override init() {
        super.init()
        widgetPointer = gtk_viewport_new(nil, nil)
    }
}
