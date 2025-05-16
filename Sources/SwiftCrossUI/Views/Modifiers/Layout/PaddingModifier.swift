extension View {
    /// Adds padding to a view. If `amount` is `nil`, then a backend-specific default value
    /// is used. Separate from ``View/padding(_:_:)`` because overload resolution didn't
    /// like the double default parameters.
    public func padding(_ amount: Int? = nil) -> some View {
        return padding(.all, amount)
    }

    /// Adds padding to a view. If `amount` is `nil`, then a backend-specific
    /// default value is used.
    public func padding(_ edges: Edge.Set = .all, _ amount: Int? = nil) -> some View {
        let insets = EdgeInsets.Internal(edges: edges, amount: amount)
        return PaddingModifierView(body: TupleView1(self), insets: insets)
    }

    /// Adds padding to a view with a different amount for each edge.
    public func padding(_ insets: EdgeInsets) -> some View {
        return PaddingModifierView(body: TupleView1(self), insets: EdgeInsets.Internal(insets))
    }
}

/// Insets for the sides of a rectangle. Generally used to represent view padding.
public struct EdgeInsets: Equatable {
    public var top: Int
    public var bottom: Int
    public var leading: Int
    public var trailing: Int

    /// The total inset along each axis.
    var axisTotals: SIMD2<Int> {
        SIMD2(
            leading + trailing,
            top + bottom
        )
    }

    /// Constructs edge insets from individual insets.
    public init(top: Int = 0, bottom: Int = 0, leading: Int = 0, trailing: Int = 0) {
        self.top = top
        self.bottom = bottom
        self.leading = leading
        self.trailing = trailing
    }

    init(_ insets: Internal, defaultAmount: Int) {
        top = insets.top ?? defaultAmount
        bottom = insets.bottom ?? defaultAmount
        leading = insets.leading ?? defaultAmount
        trailing = insets.trailing ?? defaultAmount
    }

    struct Internal {
        var top: Int?
        var bottom: Int?
        var leading: Int?
        var trailing: Int?
    }
}

extension EdgeInsets.Internal {
    init(edges: Edge.Set, amount: Int?) {
        self.top = edges.contains(.top) ? amount : 0
        self.bottom = edges.contains(.bottom) ? amount : 0
        self.leading = edges.contains(.leading) ? amount : 0
        self.trailing = edges.contains(.trailing) ? amount : 0
    }

    init(_ insets: EdgeInsets) {
        top = insets.top
        bottom = insets.bottom
        leading = insets.leading
        trailing = insets.trailing
    }
}

/// The implementation for the ``View/padding(_:_:)`` modifier.
struct PaddingModifierView<Child: View>: TypeSafeView {
    var body: TupleView1<Child>

    /// The insets for each edge.
    var insets: EdgeInsets.Internal

    func children<Backend: AppBackend>(
        backend: Backend,
        snapshots: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment: EnvironmentValues
    ) -> TupleViewChildren1<Child> {
        body.children(backend: backend, snapshots: snapshots, environment: environment)
    }

    func asWidget<Backend: AppBackend>(
        _ children: TupleViewChildren1<Child>,
        backend: Backend
    ) -> Backend.Widget {
        let container = backend.createContainer()
        backend.addChild(children.child0.widget.into(), to: container)
        return container
    }

    func update<Backend: AppBackend>(
        _ container: Backend.Widget,
        children: TupleViewChildren1<Child>,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        let insets = EdgeInsets(insets, defaultAmount: backend.defaultPaddingAmount)

        let childResult = children.child0.update(
            with: body.view0,
            proposedSize: SIMD2(
                max(proposedSize.x - insets.leading - insets.trailing, 0),
                max(proposedSize.y - insets.top - insets.bottom, 0)
            ),
            environment: environment,
            dryRun: dryRun
        )
        let childSize = childResult.size

        let paddingSize = SIMD2(insets.leading + insets.trailing, insets.top + insets.bottom)
        let size =
            SIMD2(
                childSize.size.x,
                childSize.size.y
            ) &+ paddingSize
        if !dryRun {
            backend.setSize(of: container, to: size)
            backend.setPosition(ofChildAt: 0, in: container, to: SIMD2(insets.leading, insets.top))
        }

        return ViewUpdateResult(
            size: ViewSize(
                size: size,
                idealSize: childSize.idealSize &+ paddingSize,
                idealWidthForProposedHeight: childSize.idealWidthForProposedHeight + paddingSize.x,
                idealHeightForProposedWidth: childSize.idealHeightForProposedWidth + paddingSize.y,
                minimumWidth: childSize.minimumWidth + paddingSize.x,
                minimumHeight: childSize.minimumHeight + paddingSize.y,
                maximumWidth: childSize.maximumWidth + Double(paddingSize.x),
                maximumHeight: childSize.maximumHeight + Double(paddingSize.y)
            ),
            childResults: [childResult]
        )
    }
}
