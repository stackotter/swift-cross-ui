import Gtk3
import SwiftCrossUI

public struct Gtk3WidgetRepresentableContext<Coordinator> {
    public let coordinator: Coordinator
    public internal(set) var environment: EnvironmentValues
}

/// A wrapper that you use to integrate a Gtk 3 widget into your SwiftCrossUI
/// view hierarchy.
public protocol Gtk3WidgetRepresentable: View where Content == Never {
    /// The underlying Gtk 3 widget.
    associatedtype Gtk3WidgetType: Gtk3.Widget
    /// A type providing persistent storage for representable implementations.
    associatedtype Coordinator = Void

    /// Create the initial `Gtk3.Widget` instance.
    @MainActor
    func makeGtk3Widget(context: Gtk3WidgetRepresentableContext<Coordinator>) -> Gtk3WidgetType

    /// Update the widget with new values.
    /// - Parameters:
    ///   - gtkWidget: The widget to update.
    ///   - context: The context, including the coordinator and potentially new
    ///     environment values.
    /// - Note: This may be called even when `context` has not changed.
    @MainActor
    func updateGtk3Widget(
        _ gtkWidget: Gtk3WidgetType,
        context: Gtk3WidgetRepresentableContext<Coordinator>
    )

    /// Make the coordinator for this widget.
    ///
    /// The coordinator is used when the widget needs to communicate changes to
    /// the rest of the view hierarchy (i.e. through bindings), and is often the
    /// widget's delegate.
    @MainActor
    func makeCoordinator() -> Coordinator

    /// Compute the widget's size.
    ///
    /// The default implementation uses `gtkWidget.naturalSize()` with a
    /// temporarily disabled size request (`SIMD2(-1, -1)`) to determine the
    /// widget's ideal size, and `Gtk3.Widget.measure` to measure the widget's
    /// actual size and minimum size.
    /// - Parameters:
    ///   - proposal: The proposed frame for the widget to render in.
    ///   - gtkWidget: The widget being queried for its preferred size.
    ///   - context: The context, including the coordinator and environment values.
    /// - Returns: Information about the widget's size. The
    ///   ``SwiftCrossUI/ViewSize/size`` property is what frame the widget will
    ///   actually be rendered with if the current layout pass is not a dry run,
    ///   while the other properties are used to inform the layout engine how
    ///   big or small the widget can be. The ``SwiftCrossUI/ViewSize/idealSize``
    ///   property should not vary with the `proposal`, and should only depend
    ///   on the widget's contents. Pass `nil` for the maximum width/height if
    ///   the widget has no maximum size (and therefore may occupy the entire
    ///   screen).
    func determineViewSize(
        for proposal: SIMD2<Int>,
        gtkWidget: Gtk3WidgetType,
        context: Gtk3WidgetRepresentableContext<Coordinator>
    ) -> ViewSize

    /// Called to clean up the widget when it's removed.
    ///
    /// The default implementation does nothing.
    /// - Parameters:
    ///   - gtkWidget: The widget being dismantled.
    ///   - coordinator: The coordinator.
    static func dismantleGtk3Widget(_ gtkWidget: Gtk3WidgetType, coordinator: Coordinator)
}

extension Gtk3WidgetRepresentable {
    public static func dismantleGtk3Widget(_: Gtk3WidgetType, coordinator _: Coordinator) {
        // no-op
    }

    public func determineViewSize(
        for proposal: SIMD2<Int>,
        gtkWidget: Gtk3WidgetType,
        context _: Gtk3WidgetRepresentableContext<Coordinator>
    ) -> ViewSize {
        let (idealWidth, idealHeight) = gtkWidget.getNaturalSize()
        let idealSize = SIMD2(idealWidth, idealHeight)

        let sizeThatFitsWidth = gtkWidget.measure(
            orientation: .vertical,
            forPerpendicularSize: proposal.x
        )
        let sizeThatFitsHeight = gtkWidget.measure(
            orientation: .horizontal,
            forPerpendicularSize: proposal.y
        )

        return ViewSize(
            size: SIMD2(
                proposal.x,
                sizeThatFitsWidth.natural
            ),
            idealSize: idealSize,
            idealWidthForProposedHeight: sizeThatFitsHeight.natural,
            idealHeightForProposedWidth: sizeThatFitsWidth.natural,
            minimumWidth: sizeThatFitsHeight.minimum,
            minimumHeight: sizeThatFitsWidth.minimum,
            maximumWidth: nil,
            maximumHeight: nil
        )
    }
}

extension View where Self: Gtk3WidgetRepresentable {
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
            fatalError("Gtk3WidgetRepresentable requested by \(Backend.self)")
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
        guard let backend = backend as? Gtk3Backend else {
            fatalError("Gtk3RepresentableRepresentable updated by \(Backend.self)")
        }

        let representingWidget = widget as! RepresentingWidget<Self>
        if let child = representingWidget.child,
            let savedSizeRequest = representingWidget.savedSizeRequest
        {
            backend.setSize(of: child, to: savedSizeRequest)
        }
        representingWidget.update(with: environment)

        let size = representingWidget.representable.determineViewSize(
            for: proposedSize,
            gtkWidget: representingWidget.child!,
            context: representingWidget.context!
        )

        if !dryRun {
            backend.setSize(of: representingWidget, to: size.size)
            let sizeRequest = representingWidget.child!.getSizeRequest()
            representingWidget.savedSizeRequest = SIMD2(
                sizeRequest.width,
                sizeRequest.height
            )
            backend.setSize(of: representingWidget.child!, to: size.size)
        }

        return ViewUpdateResult.leafView(size: size)
    }
}

extension Gtk3WidgetRepresentable where Coordinator == Void {
    public func makeCoordinator() {
        return ()
    }
}

/// Exists to handle `deinit`, the rest of the stuff is just in here cause
/// it's a convenient location.
@MainActor
final class RepresentingWidget<Representable: Gtk3WidgetRepresentable>: Gtk3.Fixed {
    var representable: Representable
    var context: Gtk3WidgetRepresentableContext<Representable.Coordinator>?
    var savedSizeRequest: SIMD2<Int>?

    init(representable: Representable) {
        self.representable = representable
        super.init()
    }

    var child: Representable.Gtk3WidgetType?

    func update(with environment: EnvironmentValues) {
        if var context, let child {
            context.environment = environment
            representable.updateGtk3Widget(child, context: context)
            self.context = context
        } else {
            let context = Gtk3WidgetRepresentableContext(
                coordinator: representable.makeCoordinator(),
                environment: environment
            )
            let child = representable.makeGtk3Widget(context: context)
            put(child, x: 0, y: 0)
            child.show()
            representable.updateGtk3Widget(child, context: context)
            self.child = child
            self.context = context
        }
    }

    deinit {
        if let context, let child {
            Representable.dismantleGtk3Widget(child, coordinator: context.coordinator)
        }
    }
}
