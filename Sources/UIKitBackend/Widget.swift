import UIKit

public protocol WidgetProtocol: UIResponder {
    var x: Int { get set }
    var y: Int { get set }
    var width: Int { get set }
    var height: Int { get set }

    var view: UIView! { get }
    var controller: UIViewController? { get }

    var childWidgets: [any WidgetProtocol] { get set }
    var parentWidget: (any WidgetProtocol)? { get set }

    func add(childWidget: some WidgetProtocol)
    func removeFromParentWidget()
}

extension UIKitBackend {
    public typealias Widget = any WidgetProtocol
}

private protocol WidgetProtocolHelpers: WidgetProtocol {
    var leftConstraint: NSLayoutConstraint? { get set }
    var topConstraint: NSLayoutConstraint? { get set }
    var widthConstraint: NSLayoutConstraint? { get set }
    var heightConstraint: NSLayoutConstraint? { get set }
}

extension WidgetProtocolHelpers {
    func updateLeftConstraint() {
        leftConstraint?.isActive = false
        guard let superview = view.superview else { return }
        leftConstraint = view.leftAnchor.constraint(
            equalTo: superview.safeAreaLayoutGuide.leftAnchor, constant: CGFloat(x))
        // Set the constraint priority for leftConstraint (and topConstraint) to just under
        // "required" so that we don't get warnings about unsatisfiable constraints from
        // scroll views, which position relative to their contentLayoutGuide instead.
        // This *should* be high enough that it won't cause any problems unless there was
        // a constraint conflict anyways.
        leftConstraint!.priority = .init(UILayoutPriority.required.rawValue - 1.0)
        leftConstraint!.isActive = true
    }

    func updateTopConstraint() {
        topConstraint?.isActive = false
        guard let superview = view.superview else { return }
        topConstraint = view.topAnchor.constraint(
            equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: CGFloat(y))
        topConstraint!.priority = .init(UILayoutPriority.required.rawValue - 1.0)
        topConstraint!.isActive = true
    }

    func updateWidthConstraint() {
        widthConstraint?.isActive = false
        widthConstraint = view.widthAnchor.constraint(equalToConstant: CGFloat(width))
        widthConstraint!.isActive = true
    }

    func updateHeightConstraint() {
        heightConstraint?.isActive = false
        heightConstraint = view.heightAnchor.constraint(equalToConstant: CGFloat(height))
        heightConstraint!.isActive = true
    }
}

class BaseViewWidget: UIView, WidgetProtocolHelpers {
    fileprivate var leftConstraint: NSLayoutConstraint?
    fileprivate var topConstraint: NSLayoutConstraint?
    fileprivate var widthConstraint: NSLayoutConstraint?
    fileprivate var heightConstraint: NSLayoutConstraint?

    var x = 0 {
        didSet {
            if x != oldValue {
                updateLeftConstraint()
            }
        }
    }

    var y = 0 {
        didSet {
            if y != oldValue {
                updateTopConstraint()
            }
        }
    }

    var width = 0 {
        didSet {
            if width != oldValue {
                updateWidthConstraint()
            }
        }
    }

    var height = 0 {
        didSet {
            if height != oldValue {
                updateHeightConstraint()
            }
        }
    }

    var childWidgets: [any WidgetProtocol] = []
    weak var parentWidget: (any WidgetProtocol)?

    var view: UIView! { self }

    var controller: UIViewController? {
        var responder: UIResponder = self
        while let next = responder.next {
            if let controller = next as? UIViewController {
                return controller
            }
            responder = next
        }
        return nil
    }

    init() {
        super.init(frame: .zero)

        self.translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) is not used for this view")
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()

        updateLeftConstraint()
        updateTopConstraint()
    }

    func add(childWidget: some WidgetProtocol) {
        if childWidget.parentWidget === self { return }
        childWidget.removeFromParentWidget()

        let childController = childWidget.controller

        addSubview(childWidget.view)

        if let controller,
            let childController
        {
            controller.addChild(childController)
            childController.didMove(toParent: controller)
        }

        childWidgets.append(childWidget)
        childWidget.parentWidget = self
    }

    func removeFromParentWidget() {
        if let parentWidget {
            parentWidget.childWidgets.remove(
                at: parentWidget.childWidgets.firstIndex { $0 === self }!)
            self.parentWidget = nil
        }
        removeFromSuperview()
    }
}

class BaseControllerWidget: UIViewController, WidgetProtocolHelpers {
    fileprivate var leftConstraint: NSLayoutConstraint?
    fileprivate var topConstraint: NSLayoutConstraint?
    fileprivate var widthConstraint: NSLayoutConstraint?
    fileprivate var heightConstraint: NSLayoutConstraint?

    var x = 0 {
        didSet {
            if x != oldValue {
                updateLeftConstraint()
            }
        }
    }

    var y = 0 {
        didSet {
            if y != oldValue {
                updateTopConstraint()
            }
        }
    }

    var width = 0 {
        didSet {
            if width != oldValue {
                updateWidthConstraint()
            }
        }
    }

    var height = 0 {
        didSet {
            if height != oldValue {
                updateHeightConstraint()
            }
        }
    }

    var childWidgets: [any WidgetProtocol]
    weak var parentWidget: (any WidgetProtocol)?

    var controller: UIViewController? { self }

    init() {
        childWidgets = []
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not used for this view")
    }

    func add(childWidget: some WidgetProtocol) {
        if childWidget.parentWidget === self { return }
        childWidget.removeFromParentWidget()

        let childController = childWidget.controller

        view.addSubview(childWidget.view)

        if let childController {
            addChild(childController)
            childController.didMove(toParent: self)
        }

        childWidgets.append(childWidget)
        childWidget.parentWidget = self
    }

    func removeFromParentWidget() {
        if let parentWidget {
            parentWidget.childWidgets.remove(
                at: parentWidget.childWidgets.firstIndex { $0 === self }!)
            self.parentWidget = nil
        }
        if let parent {
            willMove(toParent: nil)
            removeFromParent()
        }
        view.removeFromSuperview()
    }
}

class WrapperWidget<View: UIView>: BaseViewWidget {
    init(child: View) {
        super.init()

        self.addSubview(child)
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.topAnchor.constraint(equalTo: self.topAnchor),
            child.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            child.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            child.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }

    override convenience init() {
        self.init(child: View(frame: .zero))
    }

    var child: View {
        subviews[0] as! View
    }

    override var intrinsicContentSize: CGSize {
        child.intrinsicContentSize
    }
}

class ContainerWidget: BaseControllerWidget {
    let child: any WidgetProtocol

    init(child: some WidgetProtocol) {
        self.child = child
        super.init()
        add(childWidget: child)
    }
}

class WrapperControllerWidget<Controller: UIViewController>: BaseControllerWidget {
    let child: Controller

    init(child: Controller) {
        self.child = child
        super.init()
    }

    override func loadView() {
        super.loadView()

        view.addSubview(child.view)
        addChild(child)

        child.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.view.topAnchor.constraint(equalTo: view.topAnchor),
            child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        child.didMove(toParent: self)
    }
}