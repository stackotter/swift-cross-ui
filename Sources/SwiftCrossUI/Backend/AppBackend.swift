import Foundation

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

private func todo(_ message: String) -> Never {
    print(message)
    Foundation.exit(1)
}

extension AppBackend {
    public func show(_ widget: Widget) {
        todo("show not implemented")
    }

    public func createVStack(spacing: Int) -> Widget {
        todo("createVStack not implemented")
    }
    public func addChild(_ child: Widget, toVStack container: Widget) {
        todo("addChild not implemented")
    }
    public func setSpacing(ofVStack widget: Widget, to spacing: Int) {
        todo("setSpacing not implemented")
    }

    public func createHStack(spacing: Int) -> Widget {
        todo("createHStack not implemented")
    }
    public func addChild(_ child: Widget, toHStack container: Widget) {
        todo("addChild not implemented")
    }
    public func setSpacing(ofHStack widget: Widget, to spacing: Int) {
        todo("setSpacing not implemented")
    }

    public func createPassthroughVStack(spacing: Int) -> Widget {
        todo("createPassthroughVStack not implemented")
    }
    public func addChild(_ child: Widget, toPassthroughVStack container: Widget) {
        todo("addChild not implemented")
    }
    public func updatePassthroughVStack(_ vStack: Widget) {
        todo("updatePassthroughVStack not implemented")
    }

    public func createEitherContainer(initiallyContaining child: Widget?) -> Widget {
        todo("createEitherContainer not implemented")
    }
    public func setChild(ofEitherContainer container: Widget, to widget: Widget?) {
        todo("setChild not implemented")
    }

    public func createPaddingContainer(for child: Widget) -> Widget {
        todo("createPaddingContainer not implemented")
    }
    public func getChild(ofPaddingContainer container: Widget) -> Widget {
        todo("getChild not implemented")
    }
    public func setPadding(
        ofPaddingContainer container: Widget,
        top: Int,
        bottom: Int,
        leading: Int,
        trailing: Int
    ) {
        todo("setPadding not implemented")
    }

    public func createScrollContainer(for child: Widget) -> Widget {
        todo("createScrollContainer not implemented")
    }

    public func createButton(label: String, action: @escaping () -> Void) -> Widget {
        todo("createButton not implemented")
    }
    public func setLabel(ofButton button: Widget, to label: String) {
        todo("setLabel not implemented")
    }
    public func setAction(ofButton button: Widget, to action: @escaping () -> Void) {
        todo("setAction not implemented")
    }

    public func createTextView(content: String, shouldWrap: Bool) -> Widget {
        todo("createTextView not implemented")
    }
    public func setContent(ofTextView textView: Widget, to content: String) {
        todo("setContent not implemented")
    }
    public func setWrap(ofTextView textView: Widget, to shouldWrap: Bool) {
        todo("setWrap not implemented")
    }

    public func createImageView(filePath: String) -> Widget {
        todo("createImageView not implemented")
    }
    public func setFilePath(ofImageView imageView: Widget, to filePath: String) {
        todo("setFilePath not implemented")
    }

    public func createSpacer(
        expandHorizontally: Bool, expandVertically: Bool
    ) -> Widget {
        todo("Widget  not implemented")
    }
    public func setExpandHorizontally(ofSpacer spacer: Widget, to expandHorizontally: Bool) {
        todo("setExpandHorizontally not implemented")
    }
    public func setExpandVertically(ofSpacer spacer: Widget, to expandVertically: Bool) {
        todo("setExpandVertically not implemented")
    }

    public func getInheritedOrientation(of widget: Widget) -> InheritedOrientation? {
        todo("getInheritedOrientation not implemented")
    }

    public func createSlider(
        minimum: Double,
        maximum: Double,
        value: Double,
        decimalPlaces: Int,
        onChange: @escaping (Double) -> Void
    ) -> Widget {
        todo("createSlider not implemented")
    }
    public func setMinimum(ofSlider slider: Widget, to minimum: Double) {
        todo("setMinimum not implemented")
    }
    public func setMaximum(ofSlider slider: Widget, to maximum: Double) {
        todo("setMaximum not implemented")
    }
    public func setValue(ofSlider slider: Widget, to value: Double) {
        todo("setValue not implemented")
    }
    public func setDecimalPlaces(ofSlider slider: Widget, to decimalPlaces: Int) {
        todo("setDecimalPlaces not implemented")
    }
    public func setOnChange(ofSlider slider: Widget, to onChange: @escaping (Double) -> Void) {
        todo("setOnChange not implemented")
    }

    public func createTextField(
        content: String, placeholder: String, onChange: @escaping (String) -> Void
    ) -> Widget {
        todo("createTextField not implemented")
    }
    public func setContent(ofTextField textField: Widget, to content: String) {
        todo("setContent not implemented")
    }
    public func setPlaceholder(ofTextField textField: Widget, to placeholder: String) {
        todo("setPlaceholder not implemented")
    }
    public func setOnChange(ofTextField textField: Widget, to onChange: @escaping (String) -> Void)
    {
        todo("setOnChange not implemented")
    }
    public func getContent(ofTextField textField: Widget) -> String {
        todo("getContent not implemented")
    }

    public func createListView() -> Widget {
        todo("createListView not implemented")
    }
    public func addChild(_ child: Widget, toListView listView: Widget) {
        todo("addChild not implemented")
    }
    public func removeChild(_ child: Widget, fromListView listView: Widget) {
        todo("removeChild not implemented")
    }

    // TODO: Perhaps all views should have this just in-case backends need to add additional logic?
    public func updateListView(_ listView: Widget) {
        todo("updateListView not implemented")
    }

    public func createOneOfContainer() -> Widget {
        todo("createOneOfContainer not implemented")
    }
    public func addChild(_ child: Widget, toOneOfContainer container: Widget) {
        todo("addChild not implemented")
    }
    public func removeChild(_ child: Widget, fromOneOfContainer container: Widget) {
        todo("removeChild not implemented")
    }
    public func setVisibleChild(ofOneOfContainer container: Widget, to child: Widget) {
        todo("setVisibleChild not implemented")
    }

    public func createSplitView(leadingChild: Widget, trailingChild: Widget) -> Widget {
        todo("createSplitView not implemented")
    }

    public func createPicker(
        options: [String], selectedOption: Int?, onChange: @escaping (Int?) -> Void
    ) -> Widget {
        todo("createPicker not implemented")
    }
    public func setOptions(ofPicker picker: Widget, to options: [String]) {
        todo("setOptions not implemented")
    }
    public func setSelectedOption(ofPicker picker: Widget, to selectedOption: Int?) {
        todo("setSelectedOption not implemented")
    }
    public func setOnChange(ofPicker picker: Widget, to onChange: @escaping (Int?) -> Void) {
        todo("setOnChange not implemented")
    }

    public func createFrameContainer(for child: Widget, minWidth: Int, minHeight: Int) -> Widget {
        todo("createFrameContainer not implemented")
    }
    public func setMinWidth(ofFrameContainer container: Widget, to minWidth: Int) {
        todo("setMinWidth not implemented")
    }
    public func setMinHeight(ofFrameContainer container: Widget, to minHeight: Int) {
        todo("setMinHeight not implemented")
    }

    public func createForegroundColorContainer(for child: Widget, color: Color) -> Widget {
        todo("createForegroundColorContainer not implemented")
    }
    public func setForegroundColor(ofForegroundColorContainer container: Widget, to color: Color) {
        todo("setForegroundColor not implemented")
    }
}
