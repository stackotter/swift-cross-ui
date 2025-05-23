import SwiftCrossUI
import UIKit

protocol Picker: WidgetProtocol {
    func setOptions(to options: [String])
    func setChangeHandler(to onChange: @escaping (Int?) -> Void)
    func setSelectedOption(to index: Int?)
    func setEnabled(_ isEnabled: Bool)
}

@available(tvOS, unavailable)
final class UIPickerViewPicker: WrapperWidget<UIPickerView>, Picker, UIPickerViewDataSource,
    UIPickerViewDelegate
{
    private var options: [String] = []
    private var onSelect: ((Int?) -> Void)?

    init() {
        super.init(child: UIPickerView())

        child.dataSource = self
        child.delegate = self

        child.selectRow(0, inComponent: 0, animated: false)
    }

    func setOptions(to options: [String]) {
        self.options = options
        child.reloadComponent(0)
    }

    func setChangeHandler(to onChange: @escaping (Int?) -> Void) {
        onSelect = onChange
    }

    func setSelectedOption(to index: Int?) {
        child.selectRow(
            (index ?? -1) + 1, inComponent: 0, animated: false)
    }

    func setEnabled(_ isEnabled: Bool) {
        child.isUserInteractionEnabled = isEnabled
    }

    func numberOfComponents(in _: UIPickerView) -> Int {
        1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        options.count + 1
    }

    // For some reason, if compiling for tvOS, the compiler complains if I even attempt
    // to define these methods.
    #if !os(tvOS)
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

final class UITableViewPicker: WrapperWidget<UITableView>, Picker, UITableViewDelegate,
    UITableViewDataSource
{
    private static let reuseIdentifier =
        "__SwiftCrossUI_UIKitBackend_UITableViewPicker.reuseIdentifier"

    private var options: [String] = []
    private var onSelect: ((Int?) -> Void)?

    init() {
        super.init(child: UITableView(frame: .zero, style: .plain))

        child.delegate = self
        child.dataSource = self

        child.register(UITableViewCell.self, forCellReuseIdentifier: Self.reuseIdentifier)
    }

    func setOptions(to options: [String]) {
        self.options = options
        child.reloadData()
    }

    func setChangeHandler(to onChange: @escaping (Int?) -> Void) {
        onSelect = onChange
    }

    func setSelectedOption(to index: Int?) {
        if let index {
            child.selectRow(
                at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .middle)
        } else {
            child.selectRow(at: nil, animated: false, scrollPosition: .none)
        }
    }

    func setEnabled(_ isEnabled: Bool) {
        child.isUserInteractionEnabled = isEnabled
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Self.reuseIdentifier, for: indexPath)

        cell.textLabel!.text = options[indexPath.row]

        return cell
    }

    func tableView(
        _: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        onSelect?(indexPath.row)
    }
}

extension UIKitBackend {
    public func createPicker() -> Widget {
        #if targetEnvironment(macCatalyst)
            if #available(macCatalyst 14, *), UIDevice.current.userInterfaceIdiom == .mac {
                return UITableViewPicker()
            } else {
                return UIPickerViewPicker()
            }
        #elseif os(tvOS)
            return UITableViewPicker()
        #else
            return UIPickerViewPicker()
        #endif
    }

    public func updatePicker(
        _ picker: Widget,
        options: [String],
        environment: EnvironmentValues,
        onChange: @escaping (Int?) -> Void
    ) {
        let pickerWidget = picker as! any Picker
        pickerWidget.setEnabled(environment.isEnabled)
        pickerWidget.setChangeHandler(to: onChange)
        pickerWidget.setOptions(to: options)
    }

    public func setSelectedOption(ofPicker picker: Widget, to selectedOption: Int?) {
        let pickerWidget = picker as! any Picker
        pickerWidget.setSelectedOption(to: selectedOption)
    }
}
