import CGtk

// TODO: This Picker implementation should be able to be cleaned
//   up immensely. Especially once ViewContent and View are combined.

// TODO: Move this elsewhere
public class Box<T> {
    var wrappedValue: T

    init(_ value: T) {
        wrappedValue = value
    }
}

/// Custom view content storage is required to store the previous set
/// of options to avoid infinite loops caused by repeatedly setting
/// options. Every time the options change, the selected index gets
/// updated, and then the view gets updated. If the view update causes
/// the index to be updated every single time, then an infinite loop
/// occurs. Using the view content as the children is possible as this
/// is just a simple way to store persistent data in the view graph.
public struct PickerViewContent: ViewContent, ViewGraphNodeChildren {
    public typealias Children = Self
    public typealias Content = Self

    var lastOptions: Box<[String]?>

    public var widgets: [GtkWidget] = []

    public init(from content: Content) {
        self = content
    }

    init(lastOptions: [String]?) {
        self.lastOptions = Box(lastOptions)
    }

    // Children will share the same Box as the content, so no need to update.
    public func update(with content: Content) {}
}

/// A picker view.
public struct Picker<Value: Equatable>: View {
    public typealias Content = PickerViewContent
    
    public var body = PickerViewContent(lastOptions: nil)

    /// The string to be shown in the text view.
    private var options: [Value]
    /// Specifies whether the text should be wrapped if wider than its container.
    private var value: Binding<Value?>

    /// Creates a new text view with the given content.
    public init(of options: [Value], selection value: Binding<Value?>) {
        self.options = options
        self.value = value
    }

    public func asWidget(_ children: PickerViewContent.Children) -> GtkDropDown {
        // TODO: Figure out why it crashes when given an empty array of strings
        let optionStrings = options.map({ "\($0)" })
        let widget = GtkDropDown(strings: optionStrings)
        children.lastOptions.wrappedValue = optionStrings

        let options = options
        widget.notifySelected = { [weak widget] in
            guard let widget = widget else {
                return
            }

            if Int(widget.selected) >= options.count {
                self.value.wrappedValue = nil
            } else {
                self.value.wrappedValue = options[Int(widget.selected)]
            }
        }
        return widget
    }

    public func update(_ widget: GtkDropDown, children: PickerViewContent.Children) {
        let index: Int
        if let selectedOption = value.wrappedValue {
            index =
                options.firstIndex { option in
                    return option == selectedOption
                } ?? Int(GTK_INVALID_LIST_POSITION)
        } else {
            index = Int(GTK_INVALID_LIST_POSITION)
        }

        if widget.selected != index {
            widget.selected = index
        }

        let options = options.map({ "\($0)" })
        if options != children.lastOptions.wrappedValue {
            widget.model = gtk_string_list_new(
                UnsafePointer(
                    options
                        .map({ UnsafePointer($0.unsafeUTF8Copy().baseAddress) })
                        .unsafeCopy()
                        .baseAddress
                )
            )
            children.lastOptions.wrappedValue = options
        }
    }
}
