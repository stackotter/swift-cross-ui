//
//  UIKitBackend+Control.swift
//  swift-cross-ui
//
//  Created by William Baker on 1/10/25.
//

import SwiftCrossUI
import UIKit

internal final class ButtonWidget: WrapperWidget<UIButton> {
    var onTap: (() -> Void)?

    @objc
    func buttonTapped() {
        onTap?()
    }

    init() {
        super.init(child: UIButton())
        child.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }
}

internal final class TextFieldWidget: WrapperWidget<UITextField>, UITextFieldDelegate {
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

internal final class PickerWidget: WrapperWidget<UIPickerView>, UIPickerViewDataSource,
    UIPickerViewDelegate
{
    var options: [String] = [] {
        didSet {
            child.reloadComponent(0)
        }
    }
    var onSelect: ((Int) -> Void)?

    init() {
        super.init(child: UIPickerView())

        child.dataSource = self
        child.delegate = self
    }

    func numberOfComponents(in _: UIPickerView) -> Int {
        1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        options.count
    }

    func pickerView(
        _: UIPickerView,
        titleForRow row: Int,
        forComponent _: Int
    ) -> String? {
        options.indices ~= row ? options[row] : nil
    }

    func pickerView(
        _: UIPickerView,
        didSelectRow row: Int,
        inComponent _: Int
    ) {
        onSelect?(row)
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
        buttonWidget.child.setAttributedTitle(
            UIKitBackend.attributedString(text: label, environment: environment),
            for: .normal
        )
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
        guard let selectedOption else { return }
        let pickerWidget = picker as! PickerWidget
        pickerWidget.child.selectRow(selectedOption, inComponent: 0, animated: false)
    }
}
