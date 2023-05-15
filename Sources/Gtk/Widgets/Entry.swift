import CGtk

/// Essentially just a one-line text input. No clue why Gtk calls it an entry.
public class Entry: Widget {
    public override init() {
        super.init()

        widgetPointer = gtk_entry_new()
    }

    public convenience init(placeholder: String) {
        self.init()
        gtk_entry_set_placeholder_text(castedPointer(), placeholder)
    }

    override func didMoveToParent() {
        super.didMoveToParent()

        addSignal(name: "changed") { [weak self] in
            guard let self = self else { return }
            self.changed?(self)
        }
    }

    public var text: String {
        get {
            String(cString: gtk_entry_buffer_get_text(gtk_entry_get_buffer(castedPointer())))
        }
        set {
            // Ensure that an infinite loop isn't created by something setting from the `changed`
            // signal handler.
            guard newValue != text else {
                return
            }

            newValue.withCString { pointer in
                // TODO: Ensure that the character count is correct (should be number of bytes not number of
                // characters).
                gtk_entry_buffer_set_text(
                    gtk_entry_get_buffer(castedPointer()),
                    pointer,
                    Int32(newValue.utf8.count)
                )
            }
        }
    }

    public var placeholder: String {
        get {
            String(cString: gtk_entry_get_placeholder_text(castedPointer()))
        }
        set {
            gtk_entry_set_placeholder_text(castedPointer(), newValue)
        }
    }

    public var changed: ((Entry) -> Void)?
}
