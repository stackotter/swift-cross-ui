// TODO: Find a way to get rid of this if possible. Required for getting onto the correct main thread from `Publisher`
var currentBackend: (any AppBackend)!

public protocol AppBackend {
    associatedtype Widget

    init(appIdentifier: String)

    func run<AppRoot: App>(
        _ app: AppRoot,
        _ setViewGraph: @escaping (ViewGraph<AppRoot>) -> Void
    ) where AppRoot.Backend == Self

    func runInMainThread(action: @escaping () -> Void)

    func show(_ widget: Widget)

    func createVStack(spacing: Int) -> Widget
    func addChild(_ child: Widget, toVStack container: Widget)
    func setSpacing(ofVStack widget: Widget, to spacing: Int)

    func createHStack(spacing: Int) -> Widget
    func addChild(_ child: Widget, toHStack container: Widget)
    func setSpacing(ofHStack widget: Widget, to spacing: Int)

    func createPassthroughVStack(spacing: Int) -> Widget
    func addChild(_ child: Widget, toPassthroughVStack container: Widget)
    func updatePassthroughVStack(_ vStack: Widget)

    func createEitherContainer(initiallyContaining child: Widget?) -> Widget
    func setChild(ofEitherContainer container: Widget, to widget: Widget?)

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

    func createListView() -> Widget
    func addChild(_ child: Widget, toListView listView: Widget)
    func removeChild(_ child: Widget, fromListView listView: Widget)

    // TODO: Perhaps all views should have this just in-case backends need to add additional logic?
    func updateListView(_ listView: Widget)

    func createOneOfContainer() -> Widget
    func addChild(_ child: Widget, toOneOfContainer container: Widget)
    func removeChild(_ child: Widget, fromOneOfContainer container: Widget)
    func setVisibleChild(ofOneOfContainer container: Widget, to child: Widget)

    func createSplitView(leadingChild: Widget, trailingChild: Widget) -> Widget

    func createPicker(
        options: [String], selectedOption: Int?, onChange: @escaping (Int?) -> Void
    ) -> Widget
    func setOptions(ofPicker picker: Widget, to options: [String])
    func setSelectedOption(ofPicker picker: Widget, to selectedOption: Int?)
    func setOnChange(ofPicker picker: Widget, to onChange: @escaping (Int?) -> Void)

    func createFrameContainer(for child: Widget, minWidth: Int, minHeight: Int) -> Widget
    func setMinWidth(ofFrameContainer container: Widget, to minWidth: Int)
    func setMinHeight(ofFrameContainer container: Widget, to minHeight: Int)

    func createForegroundColorContainer(for child: Widget, color: Color) -> Widget
    func setForegroundColor(ofForegroundColorContainer container: Widget, to color: Color)
}

public enum InheritedOrientation {
    case vertical
    case horizontal
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

extension AppBackend {
    public func show(_ widget: Widget) {
        fatalError("show not implemented")
    }

    public func createVStack(spacing: Int) -> Widget {
        fatalError("createVStack not implemented")
    }
    public func addChild(_ child: Widget, toVStack container: Widget) {
        fatalError("addChild not implemented")
    }
    public func setSpacing(ofVStack widget: Widget, to spacing: Int) {
        fatalError("setSpacing not implemented")
    }

    public func createHStack(spacing: Int) -> Widget {
        fatalError("createHStack not implemented")
    }
    public func addChild(_ child: Widget, toHStack container: Widget) {
        fatalError("addChild not implemented")
    }
    public func setSpacing(ofHStack widget: Widget, to spacing: Int) {
        fatalError("setSpacing not implemented")
    }

    public func createPassthroughVStack(spacing: Int) -> Widget {
        fatalError("createPassthroughVStack not implemented")
    }
    public func addChild(_ child: Widget, toPassthroughVStack container: Widget) {
        fatalError("addChild not implemented")
    }
    public func updatePassthroughVStack(_ vStack: Widget) {
        fatalError("updatePassthroughVStack not implemented")
    }

    public func createEitherContainer(initiallyContaining child: Widget?) -> Widget {
        fatalError("createEitherContainer not implemented")
    }
    public func setChild(ofEitherContainer container: Widget, to widget: Widget?) {
        fatalError("setChild not implemented")
    }

    public func createPaddingContainer(for child: Widget) -> Widget {
        fatalError("createPaddingContainer not implemented")
    }
    public func getChild(ofPaddingContainer container: Widget) -> Widget {
        fatalError("getChild not implemented")
    }
    public func setPadding(
        ofPaddingContainer container: Widget,
        top: Int,
        bottom: Int,
        leading: Int,
        trailing: Int
    ) {
        fatalError("setPadding not implemented")
    }

    public func createScrollContainer(for child: Widget) -> Widget {
        fatalError("createScrollContainer not implemented")
    }

    public func createButton(label: String, action: @escaping () -> Void) -> Widget {
        fatalError("createButton not implemented")
    }
    public func setLabel(ofButton button: Widget, to label: String) {
        fatalError("setLabel not implemented")
    }
    public func setAction(ofButton button: Widget, to action: @escaping () -> Void) {
        fatalError("setAction not implemented")
    }

    public func createTextView(content: String, shouldWrap: Bool) -> Widget {
        fatalError("createTextView not implemented")
    }
    public func setContent(ofTextView textView: Widget, to content: String) {
        fatalError("setContent not implemented")
    }
    public func setWrap(ofTextView textView: Widget, to shouldWrap: Bool) {
        fatalError("setWrap not implemented")
    }

    public func createImageView(filePath: String) -> Widget {
        fatalError("createImageView not implemented")
    }
    public func setFilePath(ofImageView imageView: Widget, to filePath: String) {
        fatalError("setFilePath not implemented")
    }

    public func createSpacer(
        expandHorizontally: Bool, expandVertically: Bool
    ) -> Widget {
        fatalError("Widget  not implemented")
    }
    public func setExpandHorizontally(ofSpacer spacer: Widget, to expandHorizontally: Bool) {
        fatalError("setExpandHorizontally not implemented")
    }
    public func setExpandVertically(ofSpacer spacer: Widget, to expandVertically: Bool) {
        fatalError("setExpandVertically not implemented")
    }

    public func getInheritedOrientation(of widget: Widget) -> InheritedOrientation? {
        fatalError("getInheritedOrientation not implemented")
    }

    public func createSlider(
        minimum: Double,
        maximum: Double,
        value: Double,
        decimalPlaces: Int,
        onChange: @escaping (Double) -> Void
    ) -> Widget {
        fatalError("createSlider not implemented")
    }
    public func setMinimum(ofSlider slider: Widget, to minimum: Double) {
        fatalError("setMinimum not implemented")
    }
    public func setMaximum(ofSlider slider: Widget, to maximum: Double) {
        fatalError("setMaximum not implemented")
    }
    public func setValue(ofSlider slider: Widget, to value: Double) {
        fatalError("setValue not implemented")
    }
    public func setDecimalPlaces(ofSlider slider: Widget, to decimalPlaces: Int) {
        fatalError("setDecimalPlaces not implemented")
    }
    public func setOnChange(ofSlider slider: Widget, to onChange: @escaping (Double) -> Void) {
        fatalError("setOnChange not implemented")
    }

    public func createTextField(
        content: String, placeholder: String, onChange: @escaping (String) -> Void
    ) -> Widget {
        fatalError("createTextField not implemented")
    }
    public func setContent(ofTextField textField: Widget, to content: String) {
        fatalError("setContent not implemented")
    }
    public func setPlaceholder(ofTextField textField: Widget, to placeholder: String) {
        fatalError("setPlaceholder not implemented")
    }
    public func setOnChange(ofTextField textField: Widget, to onChange: @escaping (String) -> Void)
    {
        fatalError("setOnChange not implemented")
    }
    public func getContent(ofTextField textField: Widget) -> String {
        fatalError("getContent not implemented")
    }

    public func createListView() -> Widget {
        fatalError("createListView not implemented")
    }
    public func addChild(_ child: Widget, toListView listView: Widget) {
        fatalError("addChild not implemented")
    }
    public func removeChild(_ child: Widget, fromListView listView: Widget) {
        fatalError("removeChild not implemented")
    }

    // TODO: Perhaps all views should have this just in-case backends need to add additional logic?
    public func updateListView(_ listView: Widget) {
        fatalError("updateListView not implemented")
    }

    public func createOneOfContainer() -> Widget {
        fatalError("createOneOfContainer not implemented")
    }
    public func addChild(_ child: Widget, toOneOfContainer container: Widget) {
        fatalError("addChild not implemented")
    }
    public func removeChild(_ child: Widget, fromOneOfContainer container: Widget) {
        fatalError("removeChild not implemented")
    }
    public func setVisibleChild(ofOneOfContainer container: Widget, to child: Widget) {
        fatalError("setVisibleChild not implemented")
    }

    public func createSplitView(leadingChild: Widget, trailingChild: Widget) -> Widget {
        fatalError("createSplitView not implemented")
    }

    public func createPicker(
        options: [String], selectedOption: Int?, onChange: @escaping (Int?) -> Void
    ) -> Widget {
        fatalError("createPicker not implemented")
    }
    public func setOptions(ofPicker picker: Widget, to options: [String]) {
        fatalError("setOptions not implemented")
    }
    public func setSelectedOption(ofPicker picker: Widget, to selectedOption: Int?) {
        fatalError("setSelectedOption not implemented")
    }
    public func setOnChange(ofPicker picker: Widget, to onChange: @escaping (Int?) -> Void) {
        fatalError("setOnChange not implemented")
    }

    public func createFrameContainer(for child: Widget, minWidth: Int, minHeight: Int) -> Widget {
        fatalError("createFrameContainer not implemented")
    }
    public func setMinWidth(ofFrameContainer container: Widget, to minWidth: Int) {
        fatalError("setMinWidth not implemented")
    }
    public func setMinHeight(ofFrameContainer container: Widget, to minHeight: Int) {
        fatalError("setMinHeight not implemented")
    }

    public func createForegroundColorContainer(for child: Widget, color: Color) -> Widget {
        fatalError("createForegroundColorContainer not implemented")
    }
    public func setForegroundColor(ofForegroundColorContainer container: Widget, to color: Color) {
        fatalError("setForegroundColor not implemented")
    }
}
