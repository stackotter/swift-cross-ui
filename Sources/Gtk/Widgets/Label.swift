//
//  Copyright © 2015 Tomas Linhart. All rights reserved.
//

import CGtk

public class Label: Widget {
    public init(text: String? = nil) {
        super.init()
        if let text = text {
            widgetPointer = gtk_label_new(text)
        } else {
            widgetPointer = gtk_label_new(nil)
        }
        horizontalAlignment = .start
    }

    public var text: String? {
        get {
            return String(cString: gtk_label_get_text(opaquePointer))
        }
        set {
            if let text = newValue {
                gtk_label_set_text(opaquePointer, text)
            } else {
                gtk_label_set_text(opaquePointer, nil)
            }
        }
    }

    @GObjectProperty(named: "selectable") public var selectable: Bool

    public var justification: Justification {
        get {
            return gtk_label_get_justify(opaquePointer).toJustification()
        }
        set {
            gtk_label_set_justify(opaquePointer, newValue.toGtkJustification())
        }
    }

    @GObjectProperty(named: "wrap") public var lineWrap: Bool

    public var lineWrapMode: WrapMode {
        get {
            return gtk_label_get_wrap_mode(opaquePointer).toWrapMode()
        }
        set {
            gtk_label_set_wrap_mode(opaquePointer, newValue.toPangoWrapMode())
        }
    }
}
