//
//  Copyright © 2017 Tomas Linhart. All rights reserved.
//

import CGtk

public class HeaderBar: Widget {
    var widgets: [Widget] = []

    public override init() {
        super.init()

        widgetPointer = gtk_header_bar_new()
    }

    private var _customTitle: Widget?
    public var customTitle: Widget? {
        get {
            return _customTitle
        }
        set {
            _customTitle = newValue
            gtk_header_bar_set_title_widget(opaquePointer, newValue?.widgetPointer)
        }
    }

    @GObjectProperty(named: "decoration-layout") public var decorationLayout: String?

    public func packChild(atStart child: Widget) {
        widgets.append(child)
        gtk_header_bar_pack_start(opaquePointer, child.widgetPointer)
    }

    public func packChild(atEnd child: Widget) {
        widgets.append(child)
        gtk_header_bar_pack_end(opaquePointer, child.widgetPointer)
    }
}
