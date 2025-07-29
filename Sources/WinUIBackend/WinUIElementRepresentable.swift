import WinUI
import WindowsFoundation
import SwiftCrossUI

// Many force tries are required for the WinUI backend but we don't really want them
// anywhere else so just disable the lint rule at a file level.
// swiftlint:disable force_try

public struct WinUIElementRepresentableContext<Coordinator> {
    public let coordinator: Coordinator
    public internal(set) var environment: EnvironmentValues
}

/// A wrapper that you use to integrate a WinUI element into your SwiftCrossUI
/// view hierarchy.
public protocol WinUIElementRepresentable: View where Content == Never {
    /// The underlying Gtk widget.
    associatedtype WinUIElementType: WinUI.FrameworkElement
    /// A type providing persistent storage for representable implementations.
    associatedtype Coordinator = Void

    /// Create the initial element instance.
    @MainActor
    func makeWinUIElement(
        context: WinUIElementRepresentableContext<Coordinator>
    ) -> WinUIElementType

    /// Update the widget with new values.
    /// - Parameters:
    ///   - winUIElement: The element to update.
    ///   - context: The context, including the coordinator and potentially new
    ///     environment values.
    /// - Note: This may be called even when `context` has not changed.
    @MainActor
    func updateWinUIElement(
        _ winUIElement: WinUIElementType,
        context: WinUIElementRepresentableContext<Coordinator>
    )

    /// Make the coordinator for this element.
    ///
    /// The coordinator is used when the element needs to communicate changes to
    /// the rest of the view hierarchy (i.e. through bindings), and is often the
    /// element's delegate.
    @MainActor
    func makeCoordinator() -> Coordinator

    /// Compute the element's size.
    /// - Parameters:
    ///   - proposal: The proposed frame for the element to render in.
    ///   - winUIElement: The element being queried for its preferred size.
    ///   - context: The context, including the coordinator and environment values.
    /// - Returns: Information about the element's size. The
    ///   ``SwiftCrossUI/ViewSize/size`` property is what frame the element will
    ///   actually be rendered with if the current layout pass is not a dry run,
    ///   while the other properties are used to inform the layout engine how
    ///   big or small the element can be. The ``SwiftCrossUI/ViewSize/idealSize``
    ///   property should not vary with the `proposal`, and should only depend
    ///   on the element's contents. Pass `nil` for the maximum width/height if
    ///   the element has no maximum size (and therefore may occupy the entire
    ///   screen).
    func determineViewSize(
        for proposal: SIMD2<Int>,
        winUIElement: WinUIElementType,
        context: WinUIElementRepresentableContext<Coordinator>
    ) -> ViewSize

    /// Called to clean up the element when it's removed.
    ///
    /// The default implementation does nothing.
    /// - Parameters:
    ///   - gtkElement: The element being dismantled.
    ///   - coordinator: The coordinator.
    static func dismantleWinUIElement(_ winUIElement: WinUIElementType, coordinator: Coordinator)
}

extension WinUIElementRepresentable {
    public static func dismantleWinUIElement(_: WinUIElementType, coordinator _: Coordinator) {
        // no-op
    }

    public func determineViewSize(
        for proposal: SIMD2<Int>,
        winUIElement: WinUIElementType,
        context _: WinUIElementRepresentableContext<Coordinator>
    ) -> ViewSize {
        let idealSize = WinUIBackend.naturalSize(of: winUIElement)

        let adjustment: SIMD2<Int> = WinUIBackend.sizeCorrection(for: winUIElement)

        let widthAllocation = WindowsFoundation.Size(
            width: Float(proposal.x),
            height: .infinity
        )
        try! winUIElement.measure(widthAllocation)
        let sizeThatFitsWidth = winUIElement.desiredSize

        let heightAllocation = WindowsFoundation.Size(
            width: .infinity,
            height: Float(proposal.y)
        )
        try! winUIElement.measure(heightAllocation)
        let sizeThatFitsHeight =  winUIElement.desiredSize

        let minimumHeightAllocation = WindowsFoundation.Size(
            width: Float(proposal.x),
            height: 0
        )
        try! winUIElement.measure(minimumHeightAllocation)
        let minimumHeightForWidth = winUIElement.desiredSize.height

        let minimumWidthAllocation = WindowsFoundation.Size(
            width: 0,
            height: Float(proposal.y)
        )
        try! winUIElement.measure(minimumWidthAllocation)
        let minimumWidthForHeight = winUIElement.desiredSize.width

        return ViewSize(
            size: SIMD2(
                Int(sizeThatFitsWidth.width.rounded(.up)),
                Int(sizeThatFitsWidth.height.rounded(.up))
            ) &+ adjustment,
            idealSize: idealSize,
            idealWidthForProposedHeight:
                Int(sizeThatFitsHeight.width.rounded(.up)) + adjustment.x,
            idealHeightForProposedWidth:
                Int(sizeThatFitsWidth.height.rounded(.up)) + adjustment.y,
            minimumWidth: Int(minimumHeightForWidth.rounded(.up)) + adjustment.x,
            minimumHeight: Int(minimumWidthForHeight.rounded(.up)) + adjustment.y,
            maximumWidth: nil,
            maximumHeight: nil
        )
    }
}

extension View where Self: WinUIElementRepresentable {
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
            fatalError("WinUIElementRepresentable requested by \(Backend.self)")
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
        guard let backend = backend as? WinUIBackend else {
            fatalError("WinUIElementRepresentable updated by \(Backend.self)")
        }

        let representingWidget = widget as! RepresentingWidget<Self>
        if let child = representingWidget.child,
            let savedSize = representingWidget.savedSize
        {
            child.width = savedSize.x
            child.height = savedSize.y
        }
        representingWidget.update(with: environment)

        let size = representingWidget.representable.determineViewSize(
            for: proposedSize,
            winUIElement: representingWidget.child!,
            context: representingWidget.context!
        )

        if !dryRun {
            backend.setSize(of: representingWidget, to: size.size)
            representingWidget.savedSize = SIMD2(
                representingWidget.child!.width,
                representingWidget.child!.height
            )
            backend.setSize(of: representingWidget.child!, to: size.size)
        }

        return ViewUpdateResult.leafView(size: size)
    }
}

extension WinUIElementRepresentable where Coordinator == Void {
    public func makeCoordinator() {
        return ()
    }
}

/// Exists to handle `deinit`, the rest of the stuff is just in here cause
/// it's a convenient location.
@MainActor
final class RepresentingWidget<Representable: WinUIElementRepresentable>: WinUI.Canvas {
    var representable: Representable
    var context: WinUIElementRepresentableContext<Representable.Coordinator>?
    var savedSize: SIMD2<Double>?

    init(representable: Representable) {
        self.representable = representable
        super.init()
    }

    var child: Representable.WinUIElementType?

    func update(with environment: EnvironmentValues) {
        if var context, let child {
            context.environment = environment
            representable.updateWinUIElement(child, context: context)
            self.context = context
        } else {
            let context = WinUIElementRepresentableContext(
                coordinator: representable.makeCoordinator(),
                environment: environment
            )
            let child = representable.makeWinUIElement(context: context)
            children.append(child)
            representable.updateWinUIElement(child, context: context)
            self.child = child
            self.context = context
        }
    }

    deinit {
        if let context, let child {
            Representable.dismantleWinUIElement(child, coordinator: context.coordinator)
        }
    }
}
