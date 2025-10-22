extension View {
    /// Presents a conditional modal overlay. `onDismiss` gets invoked when the sheet is dismissed.
    public func sheet<SheetContent: View>(
        isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> SheetContent
    ) -> some View {
        SheetModifier(
            isPresented: isPresented,
            body: TupleView1(self),
            onDismiss: onDismiss,
            sheetContent: content
        )
    }
}

struct SheetModifier<Content: View, SheetContent: View>: TypeSafeView {
    typealias Children = SheetModifierViewChildren<Content, SheetContent>

    var isPresented: Binding<Bool>
    var body: TupleView1<Content>
    var onDismiss: (() -> Void)?
    var sheetContent: () -> SheetContent

    var sheet: Any?

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: EnvironmentValues
    ) -> Children {
        let bodyViewGraphNode = ViewGraphNode(
            for: body.view0,
            backend: backend,
            environment: environment
        )
        let bodyNode = AnyViewGraphNode(bodyViewGraphNode)

        return SheetModifierViewChildren(
            childNode: bodyNode,
            sheetContentNode: nil,
            sheet: nil
        )
    }

    func asWidget<Backend: AppBackend>(
        _ children: Children,
        backend: Backend
    ) -> Backend.Widget {
        children.childNode.widget.into()
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: Children,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        let childResult = children.childNode.update(
            with: body.view0,
            proposedSize: proposedSize,
            environment: environment,
            dryRun: dryRun
        )

        if isPresented.wrappedValue && children.sheet == nil {
            let sheetViewGraphNode = ViewGraphNode(
                for: sheetContent(),
                backend: backend,
                environment: environment
            )
            let sheetContentNode = AnyViewGraphNode(sheetViewGraphNode)
            children.sheetContentNode = sheetContentNode

            let sheet = backend.createSheet(
                content: children.sheetContentNode!.widget.into()
            )

            let dismissAction = DismissAction(action: { [isPresented] in
                isPresented.wrappedValue = false
            })
            let sheetEnvironment = environment.with(\.dismiss, dismissAction)

            let result = children.sheetContentNode!.update(
                with: sheetContent(),
                proposedSize: SIMD2(x: 10_000, y: 0),
                environment: sheetEnvironment,
                dryRun: false
            )

            backend.updateSheet(
                sheet,
                size: result.size.size,
                onDismiss: { handleDismiss(children: children) }
            )

            let preferences = result.preferences

            // MARK: Sheet Presentation Preferences
            if let cornerRadius = preferences.presentationCornerRadius {
                backend.setPresentationCornerRadius(of: sheet, to: cornerRadius)
            }

            if let detents = preferences.presentationDetents {
                backend.setPresentationDetents(of: sheet, to: detents)
            }

            if let presentationDragIndicatorVisibility = preferences
                .presentationDragIndicatorVisibility
            {
                backend.setPresentationDragIndicatorVisibility(
                    of: sheet, to: presentationDragIndicatorVisibility)
            }

            if let presentationBackground = preferences.presentationBackground {
                backend.setPresentationBackground(of: sheet, to: presentationBackground)
            }

            if let interactiveDismissDisabled = preferences.interactiveDismissDisabled {
                backend.setInteractiveDismissDisabled(for: sheet, to: interactiveDismissDisabled)
            }

            backend.showSheet(
                sheet,
                window: environment.window! as! Backend.Window
            )
            children.sheet = sheet
        } else if !isPresented.wrappedValue && children.sheet != nil {
            backend.dismissSheet(
                children.sheet as! Backend.Sheet,
                window: environment.window! as! Backend.Window
            )
            children.sheet = nil
            children.sheetContentNode = nil
        }
        return childResult
    }

    func handleDismiss(children: Children) {
        onDismiss?()
        isPresented.wrappedValue = false
    }
}

class SheetModifierViewChildren<Child: View, SheetContent: View>: ViewGraphNodeChildren {
    var widgets: [AnyWidget] {
        [childNode.widget]
    }

    var erasedNodes: [ErasedViewGraphNode] {
        var nodes: [ErasedViewGraphNode] = [ErasedViewGraphNode(wrapping: childNode)]
        if let sheetContentNode = sheetContentNode {
            nodes.append(ErasedViewGraphNode(wrapping: sheetContentNode))
        }
        return nodes
    }

    var childNode: AnyViewGraphNode<Child>
    var sheetContentNode: AnyViewGraphNode<SheetContent>?
    var sheet: Any?

    init(
        childNode: AnyViewGraphNode<Child>,
        sheetContentNode: AnyViewGraphNode<SheetContent>?,
        sheet: Any?
    ) {
        self.childNode = childNode
        self.sheetContentNode = sheetContentNode
        self.sheet = sheet
    }
}
