// extension View {
//     /// Adds a specific padding amount to each edge of this view.
//     public func padding(_ amount: Int) -> some View {
//         return PaddingModifierView(body: VariadicView1(self), edges: .all, padding: amount)
//     }

//     /// Adds an equal padding amount to specific edges of this view.
//     public func padding(_ edges: Edge.Set, _ amount: Int) -> some View {
//         return PaddingModifierView(body: VariadicView1(self), edges: edges, padding: amount)
//     }
// }

// /// The implementation for the ``View/padding(_:_:)`` and ``View/padding(_:)`` view modifiers.
// struct PaddingModifierView<Child: View>: TypeSafeView {
//     var body: VariadicView1<Child>

//     /// The edges on which to apply padding.
//     var edges: Edge.Set
//     /// The amount of padding to apply to the child view.
//     var padding: Int

//     func asWidget<Backend: AppBackend>(
//         _ children: ViewGraphNodeChildren1<Child>,
//         backend: Backend
//     ) -> Backend.Widget {
//         return backend.createPaddingContainer(for: children.child0.widget.into())
//     }

//     func update<Backend: AppBackend>(
//         _ container: Backend.Widget,
//         children: ViewGraphNodeChildren1<Child>,
//         backend: Backend
//     ) {
//         backend.setPadding(
//             ofPaddingContainer: container,
//             top: edges.contains(.top) ? padding : 0,
//             bottom: edges.contains(.bottom) ? padding : 0,
//             leading: edges.contains(.leading) ? padding : 0,
//             trailing: edges.contains(.trailing) ? padding : 0
//         )
//     }
// }
