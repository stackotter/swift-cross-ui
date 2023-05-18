/// A view used to manage a child view's size. It is preferred to use the `frame` modifier available
/// on all views (which uses this behind the scenes).
public struct FrameView<Child: View>: View {
    public var body: ViewContent1<Child>

    public var minimumWidth: Int?
    public var maximumWidth: Int?
    public var minimumHeight: Int?
    public var maximumHeight: Int?

    public init(_ child: Child, height: Int) {
        // TODO: Figure out how to get width working (seems to get ignored)
        body = ViewContent1(child)
        minimumHeight = height
        maximumHeight = height
    }

    public init(_ child: Child, minimumHeight: Int?, maximumHeight: Int?) {
        body = ViewContent1(child)
        self.minimumHeight = minimumHeight
        self.maximumHeight = maximumHeight
    }

    public func asWidget(_ children: ViewGraphNodeChildren1<Child>) -> GtkScrolledWindow {
        let widget = GtkScrolledWindow()
        let box = GtkBox(orientation: .vertical, spacing: 0)
        for child in children.widgets {
            box.add(child)
        }
        widget.setChild(box)
        return widget
    }

    public func update(_ widget: GtkScrolledWindow, children: ViewGraphNodeChildren1<Child>) {
        if let minimumWidth = minimumWidth {
            widget.minimumContentWidth = minimumWidth
        }
        if let maximumWidth = maximumWidth {
            widget.maximumContentWidth = maximumWidth
        }
        if let minimumHeight = minimumHeight {
            widget.minimumContentHeight = minimumHeight
        }
        if let maximumHeight = maximumHeight {
            widget.maximumContentHeight = maximumHeight
        }
    }
}
