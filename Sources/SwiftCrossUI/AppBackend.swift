public protocol AppBackend {
    typealias Widget = GtkWidget

    init(appIdentifier: String)

    func run<AppRoot: App>(
        _ app: AppRoot,
        _ setViewGraph: @escaping (ViewGraph<AppRoot>) -> Void
    ) where AppRoot.Backend == Self

    func createVStack(spacing: Int) -> Widget
    func addChild(_ child: Widget, toVStack container: Widget)
    func setSpacing(ofVStack widget: Widget, to spacing: Int)

    func createHStack(spacing: Int) -> Widget
    func addChild(_ child: Widget, toHStack container: Widget)
    func setSpacing(ofHStack widget: Widget, to spacing: Int)

    func createPassthroughVStack(spacing: Int) -> Widget
    func addChild(_ child: Widget, toPassthroughVStack container: Widget)

    func createEitherContainer(initiallyContaining child: Widget) -> Widget
    func setChild(ofEitherContainer container: Widget, to widget: Widget)

    func createPaddingContainer(for child: Widget) -> Widget
    func getChild(ofPaddingContainer container: Widget) -> Widget
    func setPadding(
        ofPaddingContainer container: Widget,
        top: Int,
        bottom: Int,
        leading: Int,
        trailing: Int
    )

    func createScrollContainer(for child: Widget) -> Widget

    func createButton(label: String, action: @escaping () -> Void) -> Widget
    func setLabel(ofButton button: Widget, to label: String)
    func setAction(ofButton button: Widget, to action: @escaping () -> Void)

    func createTextView(content: String, shouldWrap: Bool) -> Widget
    func setContent(ofTextView textView: Widget, to content: String)
    func setWrap(ofTextView textView: Widget, to shouldWrap: Bool)

    func createImageView(filePath: String) -> Widget
    func setFilePath(ofImageView imageView: Widget, to filePath: String)

    func createSpacer(
        expandHorizontally: Bool, expandVertically: Bool
    ) -> Widget
    func setExpandHorizontally(ofSpacer spacer: Widget, to expandHorizontally: Bool)
    func setExpandVertically(ofSpacer spacer: Widget, to expandVertically: Bool)

    func getInheritedOrientation(of widget: Widget) -> InheritedOrientation?

    func createSlider(
        minimum: Double,
        maximum: Double,
        value: Double,
        decimalPlaces: Int,
        onChange: @escaping (Double) -> Void
    ) -> Widget
    func setMinimum(ofSlider slider: Widget, to minimum: Double)
    func setMaximum(ofSlider slider: Widget, to maximum: Double)
    func setValue(ofSlider slider: Widget, to value: Double)
    func setDecimalPlaces(ofSlider slider: Widget, to decimalPlaces: Int)
    func setOnChange(ofSlider slider: Widget, to onChange: @escaping (Double) -> Void)

    func createTextField(
        content: String, placeholder: String, onChange: @escaping (String) -> Void
    ) -> Widget
    func setContent(ofTextField textField: Widget, to content: String)
    func setPlaceholder(ofTextField textField: Widget, to placeholder: String)
    func setOnChange(ofTextField textField: Widget, to onChange: @escaping (String) -> Void)
    func getContent(ofTextField textField: Widget) -> String
}

public enum InheritedOrientation {
    case vertical
    case horizontal
}

// TODO: Add back debug names for Gtk widgets (for debugging)
public struct GtkBackend: AppBackend {
    public typealias Widget = GtkWidget

    var gtkApp: GtkApplication

    public init(appIdentifier: String) {
        gtkApp = GtkApplication(applicationId: appIdentifier)
    }

    public func run<AppRoot: App>(
        _ app: AppRoot,
        _ setViewGraph: @escaping (ViewGraph<AppRoot>) -> Void
    ) where AppRoot.Backend == Self {
        gtkApp.run { window in
            window.title = app.windowProperties.title
            if let size = app.windowProperties.defaultSize {
                window.defaultSize = GtkSize(
                    width: size.width,
                    height: size.height
                )
            }
            window.resizable = app.windowProperties.resizable

            // The view graph must be stored after creation to avoid it getting released
            let viewGraph = ViewGraph(for: app, backend: self)
            setViewGraph(viewGraph)

            window.setChild(viewGraph.rootNode.widget)

            window.show()
        }
    }

    public func createVStack(spacing: Int) -> GtkWidget {
        return GtkBox(orientation: .vertical, spacing: spacing)
    }

    public func addChild(_ child: GtkWidget, toVStack container: GtkWidget) {
        (container as! GtkBox).add(child)
    }

    public func setSpacing(ofVStack container: GtkWidget, to spacing: Int) {
        (container as! GtkBox).spacing = spacing
    }

    public func createHStack(spacing: Int) -> GtkWidget {
        return GtkBox(orientation: .horizontal, spacing: spacing)
    }

    public func addChild(_ child: GtkWidget, toHStack container: GtkWidget) {
        (container as! GtkBox).add(child)
    }

    public func setSpacing(ofHStack container: GtkWidget, to spacing: Int) {
        (container as! GtkBox).spacing = spacing
    }

    public func createPassthroughVStack(spacing: Int) -> GtkWidget {
        return GtkSectionBox(orientation: .vertical, spacing: spacing)
    }

    public func addChild(_ child: GtkWidget, toPassthroughVStack container: GtkWidget) {
        (container as! GtkSectionBox).add(child)
    }

    public func createEitherContainer(initiallyContaining child: GtkWidget) -> GtkWidget {
        let box = GtkModifierBox()
        box.setChild(child)
        return box
    }

    public func setChild(ofEitherContainer container: GtkWidget, to widget: GtkWidget) {
        (container as! GtkModifierBox).setChild(widget)
    }

    public func createPaddingContainer(for child: GtkWidget) -> GtkWidget {
        let box = GtkModifierBox()
        box.setChild(child)
        return box
    }

    public func getChild(ofPaddingContainer container: Widget) -> GtkWidget {
        return (container as! GtkModifierBox).child!
    }

    public func setPadding(
        ofPaddingContainer container: GtkWidget,
        top: Int,
        bottom: Int,
        leading: Int,
        trailing: Int
    ) {
        let container = container as! GtkModifierBox
        container.marginTop = top
        container.marginBottom = bottom
        container.marginStart = leading
        container.marginEnd = trailing
    }

    public func createScrollContainer(for child: GtkWidget) -> GtkWidget {
        let scrolledWindow = GtkScrolledWindow()
        scrolledWindow.setChild(child)
        scrolledWindow.propagateNaturalHeight = true
        return scrolledWindow
    }

    public func createButton(label: String, action: @escaping () -> Void) -> GtkWidget {
        let button = GtkButton()
        button.label = label
        button.clicked = { _ in action() }
        return button
    }

    public func setLabel(ofButton button: GtkWidget, to label: String) {
        (button as! GtkButton).label = label
    }

    public func setAction(ofButton button: GtkWidget, to action: @escaping () -> Void) {
        (button as! GtkButton).clicked = { _ in action() }
    }

    public func createTextView(content: String, shouldWrap: Bool) -> GtkWidget {
        let label = GtkLabel(string: content)
        label.lineWrapMode = .wordCharacter
        label.horizontalAlignment = .start
        label.wrap = shouldWrap
        return label
    }

    public func setContent(ofTextView textView: GtkWidget, to content: String) {
        (textView as! GtkLabel).label = content
    }

    public func setWrap(ofTextView textView: GtkWidget, to shouldWrap: Bool) {
        (textView as! GtkLabel).wrap = shouldWrap
    }

    public func createImageView(filePath: String) -> GtkWidget {
        return GtkImage(filename: filePath)
    }

    public func setFilePath(ofImageView imageView: GtkWidget, to filePath: String) {
        (imageView as! GtkImage).setPath(filePath)
    }

    public func createSpacer(
        expandHorizontally: Bool, expandVertically: Bool
    ) -> Widget {
        let box = GtkModifierBox()
        box.expandHorizontally = expandHorizontally
        box.expandVertically = expandVertically
        return box
    }

    public func setExpandHorizontally(ofSpacer spacer: GtkWidget, to expandHorizontally: Bool) {
        (spacer as! GtkModifierBox).expandHorizontally = expandHorizontally
    }

    public func setExpandVertically(ofSpacer spacer: GtkWidget, to expandVertically: Bool) {
        (spacer as! GtkModifierBox).expandVertically = expandVertically
    }

    public func getInheritedOrientation(of widget: GtkWidget) -> InheritedOrientation? {
        let parent = widget.firstNonModifierParent() as? GtkBox
        switch parent?.orientation {
            case .vertical:
                return .vertical
            case .horizontal:
                return .horizontal
            case nil:
                return nil
        }
    }

    public func createSlider(
        minimum: Double,
        maximum: Double,
        value: Double,
        decimalPlaces: Int,
        onChange: @escaping (Double) -> Void
    ) -> GtkWidget {
        let scale = GtkScale()
        scale.expandHorizontally = true
        scale.minimum = minimum
        scale.maximum = maximum
        scale.value = value
        scale.digits = decimalPlaces
        scale.valueChanged = { widget in
            onChange(widget.value)
        }
        return scale
    }

    public func setMinimum(ofSlider slider: GtkWidget, to minimum: Double) {
        (slider as! GtkScale).minimum = minimum
    }

    public func setMaximum(ofSlider slider: GtkWidget, to maximum: Double) {
        (slider as! GtkScale).maximum = maximum
    }

    public func setValue(ofSlider slider: GtkWidget, to value: Double) {
        (slider as! GtkScale).value = value
    }

    public func setDecimalPlaces(ofSlider slider: GtkWidget, to decimalPlaces: Int) {
        (slider as! GtkScale).digits = decimalPlaces
    }

    public func setOnChange(ofSlider slider: GtkWidget, to onChange: @escaping (Double) -> Void) {
        (slider as! GtkScale).valueChanged = { widget in
            onChange(widget.value)
        }
    }

    public func createTextField(
        content: String, placeholder: String, onChange: @escaping (String) -> Void
    ) -> GtkWidget {
        let textField = GtkEntry()
        textField.text = content
        textField.placeholderText = placeholder
        textField.changed = { widget in
            onChange(widget.text)
        }
        return textField
    }

    public func setContent(ofTextField textField: GtkWidget, to content: String) {
        (textField as! GtkEntry).text = content
    }

    public func setPlaceholder(ofTextField textField: GtkWidget, to placeholder: String) {
        (textField as! GtkEntry).placeholderText = placeholder
    }

    public func setOnChange(
        ofTextField textField: GtkWidget, to onChange: @escaping (String) -> Void
    ) {
        (textField as! GtkEntry).changed = { widget in
            onChange(widget.text)
        }
    }

    public func getContent(ofTextField textField: Widget) -> String {
        return (textField as! GtkEntry).text
    }
}

extension AppBackend {
    public func addChildren(_ children: [Widget], toVStack container: Widget) {
        for child in children {
            addChild(child, toVStack: container)
        }
    }

    public func addChildren(_ children: [AnyWidget], toVStack container: Widget) {
        for child in children {
            addChild(child.into(), toVStack: container)
        }
    }

    public func addChildren(_ children: [Widget], toHStack container: Widget) {
        for child in children {
            addChild(child, toHStack: container)
        }
    }

    public func addChildren(_ children: [AnyWidget], toHStack container: Widget) {
        for child in children {
            addChild(child.into(), toHStack: container)
        }
    }

    public func addChildren(_ children: [Widget], toPassthroughVStack container: Widget) {
        for child in children {
            addChild(child, toPassthroughVStack: container)
        }
    }

    public func addChildren(_ children: [AnyWidget], toPassthroughVStack container: Widget) {
        for child in children {
            addChild(child.into(), toPassthroughVStack: container)
        }
    }
}
