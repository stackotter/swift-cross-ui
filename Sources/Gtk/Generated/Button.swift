import CGtk

public class Button: Widget {
    override public init() {
        super.init()
        widgetPointer = gtk_button_new()
    }

    public init(iconName: String) {
        super.init()
        widgetPointer = gtk_button_new_from_icon_name(iconName)
    }

    public init(label: String) {
        super.init()
        widgetPointer = gtk_button_new_with_label(label)
    }

    public init(mnemonic label: String) {
        super.init()
        widgetPointer = gtk_button_new_with_mnemonic(label)
    }

    override func didMoveToParent() {
        super.didMoveToParent()

        addSignal(name: "activate") { [weak self] in
            guard let self = self else { return }
            self.activate?(self)
        }

        addSignal(name: "clicked") { [weak self] in
            guard let self = self else { return }
            self.clicked?(self)
        }
    }

    public var hasFrame: Bool {
        get {
            return gtk_button_get_has_frame(castedPointer()).toBool()
        }
        set {
            gtk_button_set_has_frame(castedPointer(), newValue.toGBoolean())
        }
    }

    public var iconName: String? {
        get {
            return gtk_button_get_icon_name(castedPointer()).map(String.init(cString:))
        }
        set {
            gtk_button_set_icon_name(castedPointer(), newValue)
        }
    }

    public var label: String? {
        get {
            return gtk_button_get_label(castedPointer()).map(String.init(cString:))
        }
        set {
            gtk_button_set_label(castedPointer(), newValue)
        }
    }

    public var useUnderline: Bool {
        get {
            return gtk_button_get_use_underline(castedPointer()).toBool()
        }
        set {
            gtk_button_set_use_underline(castedPointer(), newValue.toGBoolean())
        }
    }

    public var activate: ((Button) -> Void)?

    public var clicked: ((Button) -> Void)?
}
