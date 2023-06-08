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

    @GObjectProperty(named: "label") public var label: String?

    public var clicked: ((Button) -> Void)?
}
