// extension View {
//     /// Sets the color of the foreground elements displayed by this view.
//     public func foregroundColor(_ color: Color) -> some View {
//         return ForegroundView(
//             self,
//             color: color
//         )
//     }
// }

// /// The implementation for the ``View/foregroundColor(_:)`` view modifier.
// struct ForegroundView<Child: View>: TypeSafeView {
//     var body: VariadicView1<Child>

//     /// The foreground color to use.
//     var color: Color

//     /// Wraps a child view and sets a specific foreground color.
//     init(_ child: Child, color: Color) {
//         self.body = VariadicView1(child)
//         self.color = color
//     }

//     func asWidget<Backend: AppBackend>(
//         _ children: ViewGraphNodeChildren1<Child>,
//         backend: Backend
//     ) -> Backend.Widget {
//         return backend.createStyleContainer(for: children.child0.widget.into())
//     }

//     func update<Backend: AppBackend>(
//         _ widget: Backend.Widget,
//         children: ViewGraphNodeChildren1<Child>,
//         backend: Backend
//     ) {
//         backend.setForegroundColor(ofStyleContainer: widget, to: color)
//     }
// }
