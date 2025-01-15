import SwiftCrossUI
import UIKit

public struct UIViewRepresentableContext<Coordinator> {
    public let coordinator: Coordinator
    public internal(set) var environment: EnvironmentValues
}

public protocol UIViewRepresentable: View
where Content == Never {
    associatedtype UIViewType: UIView
    associatedtype Coordinator = Void

    /// Create the initial UIView instance.
    func makeUIView(context: UIViewRepresentableContext<Coordinator>) -> UIViewType

    /// Update the view with new values.
    /// - Parameters:
    ///   - uiView: The view to update.
    ///   - context: The context, including the coordinator and potentially new environment
    ///   values.
    /// - Note: This may be called even when `context` has not changed.
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<Coordinator>)

    /// Make the coordinator for this view.
    ///
    /// The coordinator is used when the view needs to communicate changes to the rest of
    /// the view hierarchy (i.e. through bindings), and is often the view's delegate.
    func makeCoordinator() -> Coordinator

    /// Compute the view's preferred size.
    /// - Parameters:
    ///   - proposal: The proposed frame for the view to render in.
    ///   - uiVIew: The view being queried for its preferred size.
    ///   - context: The context, including the coordinator and environment values.
    /// - Returns: The preferred size for the view, ideally one that fits within `proposal`,
    /// or `nil` to use a default size for this view.
    func sizeThatFits(
        _ proposal: CGSize, uiView: UIViewType, context: UIViewRepresentableContext<Coordinator>
    ) -> CGSize?

    /// Called to clean up the view when it's removed.
    /// - Parameters:
    ///   - uiVIew: The view being queried for its preferred size.
    ///   - coordinator: The coordinator.
    ///
    /// The default implementation does nothing.
    static func dismantleUIView(_ uiView: UIViewType, coordinator: Coordinator)
}

extension UIViewRepresentable {
    public static func dismantleUIView(_: UIViewType, coordinator _: Coordinator) {
        // no-op
    }

    public func sizeThatFits(
        _ proposal: CGSize, uiView: UIViewType, context _: UIViewRepresentableContext<Coordinator>
    ) -> CGSize? {
        // For many growable views, such as WKWebView, sizeThatFits just returns the current
        // size -- which is 0 x 0 on first render. So, check if the view can grow to fill
        // the available space first.
        let intrinsicContentSize = uiView.intrinsicContentSize
        if intrinsicContentSize.width < 0.0 || intrinsicContentSize.height < 0.0 {
            return nil
        }
        return uiView.sizeThatFits(proposal)
    }
}

extension View
where Self: UIViewRepresentable {
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
            fatalError("UIViewRepresentable requested by \(Backend.self)")
        }
    }

    public func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children _: any ViewGraphNodeChildren,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend _: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        let representingWidget = widget as! RepresentingWidget<Self>
        representingWidget.updateContext(environment: environment)

        let preferredSize =
            representingWidget.representable.sizeThatFits(
                CGSize(width: proposedSize.x, height: proposedSize.y),
                uiView: representingWidget.subview,
                context: representingWidget.context!
            ) ?? representingWidget.subview.intrinsicContentSize

        let roundedSize = SIMD2(
            Int(preferredSize.width.rounded(.awayFromZero)),
            Int(preferredSize.height.rounded(.awayFromZero)))

        // Not only does -1 x -1 mean "grow to fill", UIKit allows you to return -1 for only one axis!
        let size = ViewSize(
            size: SIMD2(
                roundedSize.x < 0 ? proposedSize.x : min(proposedSize.x, roundedSize.x),
                roundedSize.y < 0 ? proposedSize.y : min(proposedSize.y, roundedSize.y)
            ),
            idealSize: SIMD2(
                roundedSize.x < 0 ? proposedSize.x : roundedSize.x,
                roundedSize.y < 0 ? proposedSize.y : roundedSize.y
            ),
            minimumWidth: roundedSize.x > proposedSize.x ? roundedSize.x : 0,
            minimumHeight: roundedSize.y > proposedSize.y ? roundedSize.y : 0,
            maximumWidth: nil,
            maximumHeight: nil
        )

        if !dryRun {
            representingWidget.width = size.size.x
            representingWidget.height = size.size.y
        }

        return ViewUpdateResult.leafView(size: size)
    }
}

extension UIViewRepresentable
where Coordinator == Void {
    public func makeCoordinator() {
        return ()
    }
}

final class RepresentingWidget<Representable: UIViewRepresentable>: BaseWidget {
    var representable: Representable
    var context: UIViewRepresentableContext<Representable.Coordinator>?

    lazy var subview: Representable.UIViewType = {
        let view = representable.makeUIView(context: context!)

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

    func updateContext(environment: EnvironmentValues) {
        if context == nil {
            context = .init(coordinator: representable.makeCoordinator(), environment: environment)
        } else {
            context!.environment = environment
            representable.updateUIView(subview, context: context!)
        }
    }

    init(representable: Representable) {
        self.representable = representable
        super.init()
    }

    deinit {
        if let context {
            Representable.dismantleUIView(subview, coordinator: context.coordinator)
        }
    }
}
