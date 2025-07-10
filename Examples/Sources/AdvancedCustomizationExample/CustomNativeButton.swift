struct CustomNativeButton {
    typealias Coordinator = Void

    var label: String
}

#if canImport(GtkBackend)
    import GtkBackend
    import Gtk

    extension CustomNativeButton: GtkWidgetRepresentable {
        func makeGtkWidget(context: GtkWidgetRepresentableContext<Coordinator>) -> Gtk.Button {
            Gtk.Button()
        }

        func updateGtkWidget(
            _ button: Gtk.Button,
            context: GtkWidgetRepresentableContext<Coordinator>
        ) {
            button.label = label
            button.css.clear()
            button.css.set(properties: [.backgroundColor(.init(1, 0, 1, 1))])
        }
    }
#endif

#if canImport(Gtk3Backend)
    import Gtk3Backend
    import Gtk3

    extension CustomNativeButton: Gtk3WidgetRepresentable {
        func makeGtk3Widget(context: Gtk3WidgetRepresentableContext<Coordinator>) -> Gtk3.Button {
            Gtk3.Button()
        }

        func updateGtk3Widget(
            _ button: Gtk3.Button,
            context: Gtk3WidgetRepresentableContext<Coordinator>
        ) {
            button.label = label
            button.css.clear()
            button.css.set(properties: [.backgroundColor(.init(1, 0, 1, 1))])
        }
    }
#endif

#if canImport(AppKitBackend)
    import AppKitBackend
    import AppKit

    extension CustomNativeButton: NSViewRepresentable {
        func makeNSView(context: NSViewRepresentableContext<Coordinator>) -> NSButton {
            NSButton()
        }

        func updateNSView(
            _ button: NSButton,
            context: NSViewRepresentableContext<Coordinator>
        ) {
            button.title = label
            button.bezelColor = .magenta
        }
    }
#endif

#if canImport(UIKitBackend)
    import UIKitBackend
    import UIKit

    extension CustomNativeButton: UIViewRepresentable {
        func makeUIView(context: UIViewRepresentableContext<Coordinator>) -> UIButton {
            UIButton()
        }

        func updateUIView(
            _ button: UIButton,
            context: UIViewRepresentableContext<Coordinator>
        ) {
            button.setTitle(label, for: .normal)
            if #available(iOS 15.0, *) {
                button.configuration = .bordered()
            }
        }
    }
#endif

#if canImport(WinUIBackend)
    import WinUIBackend
    import WinUI
    import UWP

    extension CustomNativeButton: WinUIElementRepresentable {
        func makeWinUIElement(
            context: WinUIElementRepresentableContext<Coordinator>
        ) -> WinUI.Button {
            WinUI.Button()
        }

        func updateWinUIElement(
            _ button: WinUI.Button,
            context: WinUIElementRepresentableContext<Coordinator>
        ) {
            let block = TextBlock()
            block.text = label
            button.content = block
            let brush = WinUI.SolidColorBrush()
            brush.color = UWP.Color(a: 255, r: 255, g: 0, b: 255)
            button.background = brush
        }
    }
#endif
