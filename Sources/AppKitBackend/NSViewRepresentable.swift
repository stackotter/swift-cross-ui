import SwiftCrossUI
import AppKit

public struct NSViewRepresentableContext<Coordinator> {
    public let coordinator: Coordinator
    public internal(set) var environment: EnvironmentValues
}

public protocol NSViewRepresentable: View where Content == Never {
    associatedtype NSViewType: NSView
    associatedtype Coordinator = Void

    /// Create the initial NSView instance.
    @MainActor
    func makeNSView(context: NSViewRepresentableContext<Coordinator>) -> NSViewType

    /// Update the view with new values.
    /// - Parameters:
    ///   - nsView: The view to update.
    ///   - context: The context, including the coordinator and potentially new environment
    ///   values.
    /// - Note: This may be called even when `context` has not changed.
    @MainActor
    func updateNSView(_ nsView: NSViewType, context: NSViewRepresentableContext<Coordinator>)

    /// Make the coordinator for this view.
    ///
    /// The coordinator is used when the view needs to communicate changes to the rest of
    /// the view hierarchy (i.e. through bindings), and is often the view's delegate.
    @MainActor
    func makeCoordinator() -> Coordinator

    /// Compute the view's size.
    /// - Parameters:
    ///   - proposal: The proposed frame for the view to render in.
    ///   - nsVIew: The view being queried for its preferred size.
    ///   - context: The context, including the coordinator and environment values.
    /// - Returns: Information about the view's size. The ``SwiftCrossUI/ViewSize/size``
    /// property is what frame the view will actually be rendered with if the current layout
    /// pass is not a dry run, while the other properties are used to inform the layout engine
    /// how big or small the view can be. The ``SwiftCrossUI/ViewSize/idealSize`` property
    /// should not vary with the `proposal`, and should only depend on the view's contents.
    /// Pass `nil` for the maximum width/height if the view has no maximum size (and therefore
    /// may occupy the entire screen).
    ///
    /// The default implementation uses `nsView.intrinsicContentSize` and `nsView.sizeThatFits(_:)`
    /// to determine the return value.
    @MainActor
    func determineViewSize(
        for proposal: SIMD2<Int>, nsView: NSViewType,
        context: NSViewRepresentableContext<Coordinator>
    ) -> ViewSize

    /// Called to clean up the view when it's removed.
    /// - Parameters:
    ///   - nsVIew: The view being dismantled.
    ///   - coordinator: The coordinator.
    ///
    /// This method is called after all AppKit lifecycle methods, such as
    /// `nsView.didMoveToSuperview()`.
    ///
    /// The default implementation does nothing.
    static func dismantleNSView(_ nsView: NSViewType, coordinator: Coordinator)
}

extension NSViewRepresentable {
    public static func dismantleNSView(_: NSViewType, coordinator _: Coordinator) {
        // no-op
    }

    public func determineViewSize(
        for proposal: SIMD2<Int>, nsView: NSViewType,
        context _: NSViewRepresentableContext<Coordinator>
    ) -> ViewSize {
        let intrinsicSize = nsView.intrinsicContentSize
        let sizeThatFits = nsView.fittingSize

        let roundedSizeThatFits = SIMD2(
            Int(sizeThatFits.width.rounded(.up)),
            Int(sizeThatFits.height.rounded(.up)))
        let roundedIntrinsicSize = SIMD2(
            Int(intrinsicSize.width.rounded(.awayFromZero)),
            Int(intrinsicSize.height.rounded(.awayFromZero)))

        return ViewSize(
            size: SIMD2(
                intrinsicSize.width < 0.0 ? proposal.x : roundedSizeThatFits.x,
                intrinsicSize.height < 0.0 ? proposal.y : roundedSizeThatFits.y
            ),
            // The 10 here is a somewhat arbitrary constant value so that it's always the same.
            // See also `Color` and `Picker`, which use the same constant.
            idealSize: SIMD2(
                intrinsicSize.width < 0.0 ? 10 : roundedIntrinsicSize.x,
                intrinsicSize.height < 0.0 ? 10 : roundedIntrinsicSize.y
            ),
            minimumWidth: max(0, roundedIntrinsicSize.x),
            minimumHeight: max(0, roundedIntrinsicSize.x),
            maximumWidth: nil,
            maximumHeight: nil
        )
    }
}

extension View where Self: NSViewRepresentable {
    public var body: Never {
        preconditionFailure("This should never be called")
    }

    public func children<Backend: AppBackend>(
        backend _: Backend,
        snapshots _: [ViewGraphSnapshotter.NodeSnapshot]?,
        environment _: EnvironmentValues
    ) -> any ViewGraphNodeChildren {
        EmptyViewChildren()
    }

    public func layoutableChildren<Backend: AppBackend>(
        backend _: Backend,
        children _: any ViewGraphNodeChildren
    ) -> [LayoutSystem.LayoutableChild] {
        []
    }

    public func asWidget<Backend: AppBackend>(
        _: any ViewGraphNodeChildren,
        backend _: Backend
    ) -> Backend.Widget {
        if let widget = RepresentingWidget(representable: self) as? Backend.Widget {
            return widget
        } else {
            fatalError("NSViewRepresentable requested by \(Backend.self)")
        }
    }

    @MainActor
    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children _: any ViewGraphNodeChildren,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend _: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        let representingWidget = widget as! RepresentingWidget<Self>
        representingWidget.update(with: environment)

        let size =
            representingWidget.representable.determineViewSize(
                for: proposedSize,
                nsView: representingWidget.subview,
                context: representingWidget.context!
            )

        return ViewUpdateResult.leafView(size: size)
    }
}

extension NSViewRepresentable where Coordinator == Void {
    public func makeCoordinator() {
        return ()
    }
}


final class RepresentingWidget<Representable: NSViewRepresentable> {
    var representable: Representable
    var context: NSViewRepresentableContext<Representable.Coordinator>?

    @MainActor
    lazy var subview: Representable.NSViewType = {
        let view = representable.makeNSView(context: context!)

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    @MainActor
    func update(with environment: EnvironmentValues) {
        if context == nil {
            context = .init(coordinator: representable.makeCoordinator(), environment: environment)
        } else {
            context!.environment = environment
            representable.updateNSView(subview, context: context!)
        }
    }

    init(representable: Representable) {
        self.representable = representable
    }
}
