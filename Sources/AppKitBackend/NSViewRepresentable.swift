import AppKit
import SwiftCrossUI

public struct NSViewRepresentableContext<Coordinator> {
    public let coordinator: Coordinator
    public internal(set) var environment: EnvironmentValues
}

/// A wrapper that you use to integrate an AppKit view into your SwiftCrossUI
/// view hierarchy.
public protocol NSViewRepresentable: View where Content == Never {
    /// The underlying AppKit view.
    associatedtype NSViewType: NSView
    /// A type providing persistent storage for representable implementations.
    associatedtype Coordinator = Void

    /// Create the initial NSView instance.
    @MainActor
    func makeNSView(context: NSViewRepresentableContext<Coordinator>) -> NSViewType

    /// Update the view with new values.
    /// - Parameters:
    ///   - nsView: The view to update.
    ///   - context: The context, including the coordinator and potentially new
    ///     environment values.
    /// - Note: This may be called even when `context` has not changed.
    @MainActor
    func updateNSView(
        _ nsView: NSViewType,
        context: NSViewRepresentableContext<Coordinator>
    )

    /// Make the coordinator for this view.
    ///
    /// The coordinator is used when the view needs to communicate changes to
    /// the rest of the view hierarchy (i.e. through bindings), and is often the
    /// view's delegate.
    @MainActor
    func makeCoordinator() -> Coordinator

    /// Compute the view's size.
    ///
    /// The default implementation uses `nsView.intrinsicContentSize` and
    /// `nsView.sizeThatFits(_:)` to determine the return value.
    /// - Parameters:
    ///   - proposal: The proposed frame for the view to render in.
    ///   - nsVIew: The view being queried for its preferred size.
    ///   - context: The context, including the coordinator and environment values.
    /// - Returns: Information about the view's size. The ``SwiftCrossUI/ViewSize/size``
    ///   property is what frame the view will actually be rendered with if the
    ///   current layout pass is not a dry run, while the other properties are
    ///   used to inform the layout engine how big or small the view can be. The
    ///   ``SwiftCrossUI/ViewSize/idealSize`` property should not vary with the
    ///   `proposal`, and should only depend on the view's contents. Pass `nil`
    ///   for the maximum width/height if the view has no maximum size (and
    ///   therefore may occupy the entire screen).
    func determineViewSize(
        for proposal: SIMD2<Int>,
        nsView: NSViewType,
        context: NSViewRepresentableContext<Coordinator>
    ) -> ViewSize

    /// Called to clean up the view when it's removed.
    ///
    /// This method is called after all AppKit lifecycle methods, such as
    /// `nsView.didMoveToSuperview()`. The default implementation does nothing.
    /// - Parameters:
    ///   - nsView: The view being dismantled.
    ///   - coordinator: The coordinator.
    static func dismantleNSView(_ nsView: NSViewType, coordinator: Coordinator)
}

extension NSViewRepresentable {
    public static func dismantleNSView(_: NSViewType, coordinator _: Coordinator) {
        // no-op
    }

    public func determineViewSize(
        for proposal: SIMD2<Int>,
        nsView: NSViewType,
        context _: NSViewRepresentableContext<Coordinator>
    ) -> ViewSize {
        let intrinsicSize = nsView.intrinsicContentSize
        let sizeThatFits = nsView.fittingSize

        let roundedSizeThatFits = SIMD2(
            Int(sizeThatFits.width.rounded(.up)),
            Int(sizeThatFits.height.rounded(.up))
        )
        let roundedIntrinsicSize = SIMD2(
            Int(intrinsicSize.width.rounded(.awayFromZero)),
            Int(intrinsicSize.height.rounded(.awayFromZero))
        )

        return ViewSize(
            size: SIMD2(
                intrinsicSize.width < 0.0
                    ? proposal.x
                    : max(min(proposal.x, roundedSizeThatFits.x), roundedIntrinsicSize.x),
                intrinsicSize.height < 0.0
                    ? proposal.y
                    : max(min(proposal.y, roundedSizeThatFits.y), roundedIntrinsicSize.y)
            ),
            // The 10 here is a somewhat arbitrary constant value so that it's always the same.
            // See also `Color` and `Picker`, which use the same constant.
            idealSize: SIMD2(
                intrinsicSize.width < 0.0 ? 10 : roundedIntrinsicSize.x,
                intrinsicSize.height < 0.0 ? 10 : roundedIntrinsicSize.y
            ),
            // We don't have a nice way of measuring these, so just set them to the
            // view's minimum sizes along each dimension to at least be correct.
            idealWidthForProposedHeight: max(0, roundedSizeThatFits.x),
            idealHeightForProposedWidth: max(0, roundedSizeThatFits.y),
            minimumWidth: max(0, roundedIntrinsicSize.x),
            minimumHeight: max(0, roundedIntrinsicSize.y),
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

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        guard let backend = backend as? AppKitBackend else {
            fatalError("NSViewRepresentable updated by \(Backend.self)")
        }

        let representingWidget = widget as! RepresentingWidget<Self>
        representingWidget.update(with: environment)

        // We need to do this for `fittingSize` to work correctly (it takes all
        // constraints into account).
        backend.setSize(of: representingWidget, to: proposedSize)
        let size = representingWidget.representable.determineViewSize(
            for: proposedSize,
            nsView: representingWidget.subview,
            context: representingWidget.context!
        )

        if !dryRun {
            backend.setSize(of: representingWidget, to: size.size)
        }

        return ViewUpdateResult.leafView(size: size)
    }
}

extension NSViewRepresentable where Coordinator == Void {
    public func makeCoordinator() {
        return ()
    }
}

/// Exists to handle `deinit`, the rest of the stuff is just in here cause
/// it's a convenient location.
final class RepresentingWidget<Representable: NSViewRepresentable>: NSView {
    var representable: Representable
    var context: NSViewRepresentableContext<Representable.Coordinator>?

    init(representable: Representable) {
        self.representable = representable
        super.init(frame: .zero)

        self.translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not used for this view")
    }

    lazy var subview: Representable.NSViewType = {
        let view = representable.makeNSView(context: context!)

        self.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])

        return view
    }()

    func update(with environment: EnvironmentValues) {
        if var context {
            context.environment = environment
            representable.updateNSView(subview, context: context)
            self.context = context
        } else {
            let context = NSViewRepresentableContext(
                coordinator: representable.makeCoordinator(),
                environment: environment
            )
            self.context = context
            representable.updateNSView(subview, context: context)
        }
    }

    deinit {
        if let context {
            Representable.dismantleNSView(subview, coordinator: context.coordinator)
        }
    }
}
