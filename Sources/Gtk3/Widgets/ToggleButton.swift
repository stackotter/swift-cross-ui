import CGtk3

public class ToggleButton: Button {
    public convenience init() {
        self.init(gtk_toggle_button_new())
    }

    public convenience init(label: String) {
        self.init(gtk_toggle_button_new_with_label(label))
    }

    public convenience init(mnemonic label: String) {
        self.init(gtk_toggle_button_new_with_mnemonic(label))
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
