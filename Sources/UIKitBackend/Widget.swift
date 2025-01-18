import UIKit

public protocol WidgetProtocol: UIResponder {
    var x: Int { get set }
    var y: Int { get set }
    var width: Int { get set }
    var height: Int { get set }
    
    var view: UIView! { get }
    var controller: UIViewController? { get }
    
    var childWidgets: [any WidgetProtocol] { get set }
    var parentWidget: (any WidgetProtocol)? { get }
    
    func add(toWidget other: some WidgetProtocol)
    func removeFromParentWidget()
}

extension UIKitBackend {
    public typealias Widget = any WidgetProtocol
}

fileprivate protocol WidgetProtocolHelpers: WidgetProtocol {
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
        // scroll views.
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
    
    func add(toWidget other: some WidgetProtocol) {
        if parentWidget === other { return }
        removeFromParentWidget()
        
        other.view.addSubview(self)
        parentWidget = other
        other.childWidgets.append(self)
    }
    
    func removeFromParentWidget() {
        if let parentWidget {
            parentWidget.childWidgets.remove(at: parentWidget.childWidgets.firstIndex { $0 === self }!)
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
    
    func add(toWidget other: some WidgetProtocol) {
        if parentWidget === other { return }
        removeFromParentWidget()
        
        other.view.addSubview(view)
        
        if let otherController = other.controller {
            otherController.addChild(self)
            didMove(toParent: otherController)
        }
        
        parentWidget = other
        other.childWidgets.append(self)
    }
    
    func removeFromParentWidget() {
        if let parentWidget {
            parentWidget.childWidgets.remove(at: parentWidget.childWidgets.firstIndex { $0 === self }!)
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
        child.add(toWidget: self)
    }
}
