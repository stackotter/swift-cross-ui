//
//  Copyright © 2015 Tomas Linhart. All rights reserved.
//

import CGtk

open class Button: Widget {
    public override init() {
        super.init()
        widgetPointer = gtk_button_new()
    }

    public init(label: String) {
        super.init()
        widgetPointer = gtk_button_new_with_label(label)
    }

    override func didMoveToParent() {
        super.didMoveToParent()

        addSignal(name: "clicked") { [weak self] in
            guard let self = self else { return }
            self.clicked?(self)
        }
    }

    public var label: String? {
        get {
            return String(cString: gtk_button_get_label(castedPointer()))
        }
        set {
            if let title = newValue {
                gtk_button_set_label(castedPointer(), title)
            } else {
                gtk_button_set_label(castedPointer(), nil)
            }
        }
    }

    public var clicked: ((Button) -> Void)?
}
