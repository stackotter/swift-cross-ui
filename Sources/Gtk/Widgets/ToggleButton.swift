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

    @GObjectProperty(named: "active") public var active: Bool

    public var toggled: ((ToggleButton) -> Void)?
}
