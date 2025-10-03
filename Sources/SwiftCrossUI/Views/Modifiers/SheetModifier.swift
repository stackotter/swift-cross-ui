extension View {
    /// presents a conditional modal overlay
    /// onDismiss optional handler gets executed before
    /// dismissing the sheet
    public func sheet<SheetContent: View>(
        isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> SheetContent
    ) -> some View {
        SheetModifier(
            isPresented: isPresented, body: TupleView1(self), onDismiss: onDismiss,
            sheetContent: content)
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

        let sheetViewGraphNode = ViewGraphNode(
            for: sheetContent(),
            backend: backend,
            environment: environment
        )
        let sheetContentNode = AnyViewGraphNode(sheetViewGraphNode)

        return SheetModifierViewChildren(
            childNode: bodyNode,
            sheetContentNode: sheetContentNode,
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
            let sheet = backend.createSheet()

            let dryRunResult = children.sheetContentNode.update(
                with: sheetContent(),
                proposedSize: sheet.size,
                environment: environment,
                dryRun: true
            )

            let preferences = dryRunResult.preferences

            let _ = children.sheetContentNode.update(
                with: sheetContent(),
                proposedSize: sheet.size,
                environment: environment,
                dryRun: false
            )

            backend.updateSheet(
                sheet,
                content: children.sheetContentNode.widget.into(),
                onDismiss: handleDismiss
            )

            // Apply presentation preferences to the sheet
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

            backend.showSheet(
                sheet,
                window: .some(environment.window! as! Backend.Window)
            )
            children.sheet = sheet
        } else if !isPresented.wrappedValue && children.sheet != nil {
            backend.dismissSheet(
                children.sheet as! Backend.Sheet,
                window: .some(environment.window! as! Backend.Window)
            )
            children.sheet = nil
        }
        return childResult
    }

    func handleDismiss() {
        onDismiss?()
        isPresented.wrappedValue = false
    }
}

class SheetModifierViewChildren<Child: View, SheetContent: View>: ViewGraphNodeChildren {
    var widgets: [AnyWidget] {
        [childNode.widget]
    }

    var erasedNodes: [ErasedViewGraphNode] {
        [ErasedViewGraphNode(wrapping: childNode), ErasedViewGraphNode(wrapping: sheetContentNode)]
    }

    var childNode: AnyViewGraphNode<Child>
    var sheetContentNode: AnyViewGraphNode<SheetContent>
    var sheet: Any?

    init(
        childNode: AnyViewGraphNode<Child>,
        sheetContentNode: AnyViewGraphNode<SheetContent>,
        sheet: Any?
    ) {
        self.childNode = childNode
        self.sheetContentNode = sheetContentNode
        self.sheet = sheet
    }
}
