import SwiftCrossUI
import UIKit

extension UIKitBackend {
    public final class Menu {
        var uiMenu: UIMenu?
    }

    public func createPopoverMenu() -> Menu {
        return Menu()
    }

    @available(tvOS 14, *)
    static func buildMenu(
        content: ResolvedMenu,
        label: String,
        identifier: UIMenu.Identifier? = nil
    ) -> UIMenu {
        var children: [UIMenuElement] = []
        for item in content.items {
            switch item {
                case .button(let label, let action):
                    let uiAction = if let action {
                        UIAction(title: label) { _ in action() }
                    } else {
                        UIAction(title: label, attributes: .disabled) { _ in }
                    }
                    children.append(uiAction)
                case .toggle(let label, let value, let onChange):
                    children.append(
                        UIAction(title: label, state: value ? .on : .off) { action in
                            onChange(!action.state.isOn)
                        }
                    )
                case .separator:
                    children = [UIMenu(title: "", options: .displayInline, children: children)]
                case .submenu(let submenu):
                    children.append(buildMenu(content: submenu.content, label: submenu.label))
            }
        }

        return UIMenu(title: label, identifier: identifier, children: children)
    }

    public func updatePopoverMenu(
        _ menu: Menu,
        content: ResolvedMenu,
        environment _: EnvironmentValues
    ) {
        if #available(iOS 14, macCatalyst 14, tvOS 17, *) {
            menu.uiMenu = UIKitBackend.buildMenu(content: content, label: "")
        } else {
            preconditionFailure("Current OS is too old to support menu buttons.")
        }
    }

    public func updateButton(
        _ button: Widget,
        label: String,
        menu: Menu,
        environment: EnvironmentValues
    ) {
        if #available(iOS 14, macCatalyst 14, tvOS 17, *) {
            let buttonWidget = button as! ButtonWidget
            buttonWidget.child.isEnabled = environment.isEnabled
            setButtonTitle(buttonWidget, label, environment: environment)
            buttonWidget.child.menu = menu.uiMenu
            buttonWidget.child.showsMenuAsPrimaryAction = true
        } else {
            preconditionFailure("Current OS is too old to support menu buttons.")
        }
    }

    public func setApplicationMenu(_ submenus: [ResolvedMenu.Submenu]) {
        #if targetEnvironment(macCatalyst)
            let appDelegate = UIApplication.shared.delegate as! ApplicationDelegate
            appDelegate.menu = submenus
        #else
            // Once keyboard shortcuts are implemented, it might be possible to do them on more
            // platforms than just Mac Catalyst. For now, this is a no-op.
            logger.notice("ignoring \(#function) call")
        #endif
    }
}

extension UIMenuElement.State {
    var isOn: Bool {
        get { self == .on }
        set { self = newValue ? .on : .off }
    }
}
