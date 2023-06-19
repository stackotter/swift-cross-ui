//
//  Copyright © 2015 Tomas Linhart. All rights reserved.
//

import Foundation
import Gtk

#if canImport(FileDialog)
    import FileDialog
#endif

let app = Application(applicationId: "com.tomaslinhart.swiftgtk.example")
app.run { window in
    window.title = "Hello World"
    window.defaultSize = Size(width: 400, height: 400)
    window.resizable = true

    let box = Box(orientation: .vertical, spacing: 0)

    let label = Label(string: "")
    label.selectable = true
    box.add(label)

    let slider = Scale(orientation: Orientation.horizontal.toGtk(), adjustment: nil)
    slider.minimum = 5
    slider.maximum = 10.5
    slider.value = 5.7
    box.add(slider)

    let entry = Entry()
    entry.placeholderText = "Test input"
    entry.changed = { entry in
        print(entry.text)
    }
    box.add(entry)

    let scrollable = ScrolledWindow()
    scrollable.maximumContentHeight = 100
    scrollable.minimumContentHeight = 100
    let viewport = Viewport()
    let content = Box(orientation: .vertical, spacing: 0)
    for i in 0..<20 {
        content.add(Label(string: "This is line number \(i)"))
    }
    viewport.setChild(content)
    scrollable.setChild(viewport)
    box.add(scrollable)

    let button = Button(label: "Press")
    button.label = "Press Me"
    button.clicked = { [weak label] _ in
        label?.label = "Oh, you pressed the button."

        let newWindow = Window()
        newWindow.title = "Just a window"
        newWindow.defaultSize = Size(width: 200, height: 200)

        let labelPressed = Label(string: "Oh, you pressed the button.")
        newWindow.setChild(labelPressed)
        newWindow.show()
    }

    box.add(button)

    let calendarButton = Button(label: "Calendar")
    calendarButton.clicked = { _ in
        let newWindow = Window()
        newWindow.title = "Just a window"
        newWindow.defaultSize = Size(width: 200, height: 200)

        let calendar = Calendar()
        calendar.year = 2000
        calendar.showHeading = true

        newWindow.setChild(calendar)
        newWindow.show()
    }

    box.add(calendarButton)

    let imageButton = Button(label: "Image")
    imageButton.clicked = { _ in
        let newWindow = Window()
        newWindow.title = "Just a window"
        newWindow.defaultSize = Size(width: 200, height: 200)

        let image = Image(filename: Bundle.module.bundleURL.appendingPathComponent("GTK.png").path)

        newWindow.setChild(image)
        newWindow.show()
    }
    box.add(imageButton)

    #if canImport(FileDialog)
        let fileButton = Button(label: "Select file")
        fileButton.label = "Select file"
        fileButton.clicked = { [weak label] _ in
            label?.label = "Selecting file"

            let dialog = FileDialog()
            dialog.title = "File dialog"
            dialog.acceptLabel = "Fire away"

            dialog.open { result in
                switch result {
                    case .success(let file):
                        label?.label = "Selected file: \(file.path)"
                    case .failure(let error):
                        label?.label = "Cancelled selection: \(error.localizedDescription)"
                }
            }
        }
        box.add(fileButton)
    #endif

    let textView = TextView()
    textView.backspace = { _ in
        print("backspace")
    }
    textView.copyClipboard = { _ in
        print("copyClipboard")
    }
    textView.cutClipboard = { _ in
        print("cutClipboard")
    }
    textView.pasteClipboard = { _ in
        print("pasteClipboard")
    }
    // textView.selectAll = { _, select in
    //     print(select ? "everything is selected" : "everything is unselected")
    // }

    box.add(textView)

    window.setChild(box)
    window.show()
}
