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

    public var selectable: Bool {
        get {
            return gtk_label_get_selectable(opaquePointer) == 1
        }
        set {
            gtk_label_set_selectable(opaquePointer, newValue ? 1 : 0)
        }
    }

    public var justification: Justification {
        get {
            return gtk_label_get_justify(opaquePointer).toJustification()
        }
        set {
            gtk_label_set_justify(opaquePointer, newValue.toGtkJustification())
        }
    }

    public var lineWrap: Bool {
        get {
            return gtk_label_get_wrap(opaquePointer).toBool()
        }
        set {
            gtk_label_set_wrap(opaquePointer, newValue.toGBoolean())
        }
    }

    public var lineWrapMode: WrapMode {
        get {
            return gtk_label_get_wrap_mode(opaquePointer).toWrapMode()
        }
        set {
            gtk_label_set_wrap_mode(opaquePointer, newValue.toPangoWrapMode())
        }
    }
}
