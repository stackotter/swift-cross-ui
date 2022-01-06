import SwiftGtkUI

struct RootView: View {
    var body: [Component] = [
        .button(Button(text: "Hello world")),
        .hStack(HStack(children: [
            .button(Button(text: "Left")),
            .button(Button(text: "Right"))
        ]))
    ]
}

runApp(RootView())
