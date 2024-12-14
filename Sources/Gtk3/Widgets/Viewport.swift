import CGtk3

public class Viewport: Bin {
    public convenience init() {
        self.init(gtk_viewport_new(nil, nil))
    }
}
