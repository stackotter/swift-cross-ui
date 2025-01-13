import SwiftCrossUI
import UIKit

final class ButtonWidget: WrapperWidget<UIButton> {
    var onTap: (() -> Void)?

    @objc
    func buttonTapped() {
        onTap?()
    }

    init() {
        let type: UIButton.ButtonType
        let event: UIControl.Event
        #if os(tvOS)
            type = .system
            event = .primaryActionTriggered
        #else
            type = .custom
            event = .touchUpInside
        #endif
        super.init(child: UIButton(type: type))
        child.addTarget(self, action: #selector(buttonTapped), for: event)
    }
}

final class TextFieldWidget: WrapperWidget<UITextField>, UITextFieldDelegate {
    var onChange: ((String) -> Void)?
    var onSubmit: (() -> Void)?

    @objc
    func textChanged() {
        onChange?(child.text ?? "")
    }

    init() {
        super.init(child: UITextField())

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textChanged),
            name: UITextField.textDidChangeNotification,
            object: child
        )
        child.delegate = self
    }

    func textFieldShouldReturn(_: UITextField) -> Bool {
        onSubmit?()
        return false
    }
}

@available(tvOS, unavailable)
@available(macCatalyst, unavailable)
final class PickerWidget: WrapperWidget<UIPickerView>, UIPickerViewDataSource,
    UIPickerViewDelegate
{
    var options: [String] = [] {
        didSet {
            child.reloadComponent(0)
        }
    }
    var onSelect: ((Int?) -> Void)?

    init() {
        super.init(child: UIPickerView())

        child.dataSource = self
        child.delegate = self

        child.selectRow(0, inComponent: 0, animated: false)
    }

    func numberOfComponents(in _: UIPickerView) -> Int {
        1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        options.count + 1
    }

    // For some reason, if compiling for tvOS, the compiler complains if I even attempt
    // to define these methods.
    #if os(iOS)
        func pickerView(
            _: UIPickerView,
            titleForRow row: Int,
            forComponent _: Int
        ) -> String? {
            switch row {
                case 0:
                    ""
                case 1...options.count:
                    options[row - 1]
                default:
                    nil
            }
        }

        func pickerView(
            _: UIPickerView,
            didSelectRow row: Int,
            inComponent _: Int
        ) {
            onSelect?(row > 0 ? row - 1 : nil)
        }
    #endif
}

#if os(tvOS)
    final class SwitchWidget: WrapperWidget<UISegmentedControl> {
        var onChange: ((Bool) -> Void)?

        @objc
        func switchFlipped() {
            onChange?(child.selectedSegmentIndex == 1)
        }

        init() {
            // TODO: localization?
            super.init(
                child: UISegmentedControl(items: [
                    "OFF" as NSString,
                    "ON" as NSString,
                ]))

            child.addTarget(self, action: #selector(switchFlipped), for: .valueChanged)
        }

        func setOn(_ on: Bool) {
            child.selectedSegmentIndex = on ? 1 : 0
        }
    }
#else
    final class SwitchWidget: WrapperWidget<UISwitch> {
        var onChange: ((Bool) -> Void)?

        @objc
        func switchFlipped() {
            onChange?(child.isOn)
        }

        init() {
            super.init(child: UISwitch())

            // On iOS 14 and later, UISwitch can be either a switch or a checkbox (and I believe
            // it's a checkbox by default on Mac Catalyst). We have no control over this on
            // iOS 13, but when possible, prefer a switch.
            if #available(iOS 14, macCatalyst 14, *) {
                child.preferredStyle = .sliding
            }

            child.addTarget(self, action: #selector(switchFlipped), for: .valueChanged)
        }

        func setOn(_ on: Bool) {
            child.setOn(on, animated: true)
        }
    }
#endif

final class ClickableWidget: WrapperWidget<BaseWidget> {
    private var gestureRecognizer: UITapGestureRecognizer!
    var onClick: (() -> Void)?

    override init(child: BaseWidget) {
        super.init(child: child)

        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTouched))
        gestureRecognizer.cancelsTouchesInView = true
        child.addGestureRecognizer(gestureRecognizer)
    }

    @objc
    func viewTouched() {
        onClick?()
    }
}

@available(tvOS, unavailable)
final class SliderWidget: WrapperWidget<UISlider> {
    var onChange: ((Double) -> Void)?

    private var _decimalPlaces = 17
    var decimalPlaces: Int {
        get { _decimalPlaces }
        set {
            _decimalPlaces = max(0, min(newValue, 17))
        }
    }

    @objc
    func sliderMoved() {
        onChange?(
            (Double(child.value) * pow(10.0, Double(decimalPlaces)))
                .rounded(.toNearestOrEven)
                / pow(10.0, Double(decimalPlaces))
        )
    }

    init() {
        super.init(child: UISlider())
        child.addTarget(self, action: #selector(sliderMoved), for: .valueChanged)
    }
}

extension UIKitBackend {
    public func createButton() -> Widget {
        ButtonWidget()
    }

    public func updateButton(
        _ button: Widget,
        label: String,
        action: @escaping () -> Void,
        environment: EnvironmentValues
    ) {
        let buttonWidget = button as! ButtonWidget

        // tvOS's buttons change foreground color when focused. If we set an
        // attributed string for `.normal` we also have to set another for
        // `.focused` with a colour that's readable on a white background.
        // However, with that approach the label's color animates too slowly
        // and all round looks quite sloppy. Therefore, it's safest to just
        // ignore foreground color for buttons on tvOS until we have a better
        // solution.
        #if os(tvOS)
            buttonWidget.child.setTitle(label, for: .normal)
        #else
            buttonWidget.child.setAttributedTitle(
                UIKitBackend.attributedString(
                    text: label,
                    environment: environment,
                    defaultForegroundColor: .link
                ),
                for: .normal
            )
        #endif

        buttonWidget.onTap = action
    }

    public func createTextField() -> Widget {
        TextFieldWidget()
    }

    public func updateTextField(
        _ textField: Widget,
        placeholder: String,
        environment: EnvironmentValues,
        onChange: @escaping (String) -> Void,
        onSubmit: @escaping () -> Void
    ) {
        let textFieldWidget = textField as! TextFieldWidget

        textFieldWidget.child.placeholder = placeholder
        textFieldWidget.child.font = environment.font.uiFont
        textFieldWidget.child.textColor = UIColor(color: environment.suggestedForegroundColor)
        textFieldWidget.onChange = onChange
        textFieldWidget.onSubmit = onSubmit
    }

    public func setContent(ofTextField textField: Widget, to content: String) {
        let textFieldWidget = textField as! TextFieldWidget

        textFieldWidget.child.text = content
    }

    public func getContent(ofTextField textField: Widget) -> String {
        let textFieldWidget = textField as! TextFieldWidget

        return textFieldWidget.child.text ?? ""
    }

    #if os(iOS) && !targetEnvironment(macCatalyst)
        public func createPicker() -> Widget {
            PickerWidget()
        }

        public func updatePicker(
            _ picker: Widget,
            options: [String],
            environment: EnvironmentValues,
            onChange: @escaping (Int?) -> Void
        ) {
            let pickerWidget = picker as! PickerWidget
            pickerWidget.onSelect = onChange
            pickerWidget.options = options
        }

        public func setSelectedOption(ofPicker picker: Widget, to selectedOption: Int?) {
            let pickerWidget = picker as! PickerWidget
            pickerWidget.child.selectRow(
                (selectedOption ?? -1) + 1, inComponent: 0, animated: false)
        }
    #endif

    public func createSwitch() -> Widget {
        SwitchWidget()
    }

    public func updateSwitch(_ switchWidget: Widget, onChange: @escaping (Bool) -> Void) {
        let wrapper = switchWidget as! SwitchWidget
        wrapper.onChange = onChange
    }

    public func setState(ofSwitch switchWidget: Widget, to state: Bool) {
        let wrapper = switchWidget as! SwitchWidget
        wrapper.setOn(state)
    }

    public func createClickTarget(wrapping child: Widget) -> Widget {
        ClickableWidget(child: child)
    }

    public func updateClickTarget(
        _ clickTarget: Widget,
        clickHandler handleClick: @escaping () -> Void
    ) {
        let wrapper = clickTarget as! ClickableWidget
        wrapper.onClick = handleClick
    }

    #if os(iOS)
        public func createSlider() -> Widget {
            SliderWidget()
        }

        public func updateSlider(
            _ slider: Widget,
            minimum: Double,
            maximum: Double,
            decimalPlaces: Int,
            onChange: @escaping (Double) -> Void
        ) {
            let sliderWidget = slider as! SliderWidget
            sliderWidget.child.minimumValue = Float(minimum)
            sliderWidget.child.maximumValue = Float(maximum)
            sliderWidget.onChange = onChange
            sliderWidget.decimalPlaces = decimalPlaces
        }

        public func setValue(ofSlider slider: Widget, to value: Double) {
            let sliderWidget = slider as! SliderWidget
            sliderWidget.child.setValue(Float(value), animated: true)
        }
    #endif
}
