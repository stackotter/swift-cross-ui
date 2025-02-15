import AppKit

public class BaseWidget: NSView {
    private var leftConstraint: NSLayoutConstraint?
    private var topConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?

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

    init() {
        super.init(frame: .zero)

        self.translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) is not used for this view")
    }

    private func updateLeftConstraint() {
        leftConstraint?.isActive = false
        guard let superview else { return }
        leftConstraint = self.leftAnchor.constraint(
            equalTo: superview.safeAreaLayoutGuide.leftAnchor, constant: CGFloat(x))
        leftConstraint!.isActive = true
    }

    private func updateTopConstraint() {
        topConstraint?.isActive = false
        guard let superview else { return }
        topConstraint = self.topAnchor.constraint(
            equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: CGFloat(y))
        topConstraint!.isActive = true
    }

    private func updateWidthConstraint() {
        widthConstraint?.isActive = false
        widthConstraint = self.widthAnchor.constraint(equalToConstant: CGFloat(width))
        widthConstraint!.isActive = true
    }

    private func updateHeightConstraint() {
        heightConstraint?.isActive = false
        heightConstraint = self.heightAnchor.constraint(equalToConstant: CGFloat(height))
        heightConstraint!.isActive = true
    }

    public override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()

        updateLeftConstraint()
        updateTopConstraint()
    }
}

class WrapperWidget<View: NSView>: BaseWidget {
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
