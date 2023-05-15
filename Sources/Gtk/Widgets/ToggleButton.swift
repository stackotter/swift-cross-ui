//
//  Copyright © 2017 Tomas Linhart. All rights reserved.
//

import CGtk

public class ToggleButton: Button {
    public override init() {
        super.init()

        widgetPointer = gtk_toggle_button_new()
    }

    public override init(label: String) {
        super.init()

        widgetPointer = gtk_toggle_button_new_with_label(label)
    }

    public init(mnemonicLabel label: String) {
        super.init()

        widgetPointer = gtk_toggle_button_new_with_mnemonic(label)
    }

    override func didMoveToParent() {
        super.didMoveToParent()

        addSignal(name: "toggled") { [weak self] in
            guard let self = self else { return }
            self.toggled?(self)
        }
    }

    public var active: Bool {
        get {
            return gtk_toggle_button_get_active(castedPointer()).toBool()
        }
        set {
            gtk_toggle_button_set_active(castedPointer(), newValue.toGBoolean())
        }
    }

    public var toggled: ((ToggleButton) -> Void)?
}
