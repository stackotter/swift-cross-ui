// TODO: Remove View conformance from ViewContent because it's just a bit of a hack to get
// _EitherView and _OptionalView working.
public protocol ViewContent: View {
    associatedtype Children: ViewGraphNodeChildren where Children.Content == Self
}

extension ViewContent where Content == Self, State == EmptyState {
    public var body: Self {
        return self
    }

    public func asWidget(_ children: Children) -> GtkSectionBox {
        let box = GtkSectionBox(orientation: .vertical, spacing: 0).debugName(Self.self)
        for widget in children.widgets {
            box.add(widget)
        }
        return box
    }

    public func update(_ widget: GtkSectionBox, children: Children) {
        widget.update()
    }
}

public struct EmptyViewContent: ViewContent {
    public typealias Children = EmptyViewGraphNodeChildren

    public init() {}
}

public struct ViewContent1<View0: View> {
    public var view0: View0

    public init(_ view0: View0) {
        self.view0 = view0
    }
}

extension ViewContent1: ViewContent {
    public typealias Children = ViewGraphNodeChildren1<View0>
}

public struct ViewContent2<View0: View, View1: View> {
    public var view0: View0
    public var view1: View1

    public init(_ view0: View0, _ view1: View1) {
        self.view0 = view0
        self.view1 = view1
    }
}

extension ViewContent2: ViewContent {
    public typealias Children = ViewGraphNodeChildren2<View0, View1>
}

public struct ViewContent3<View0: View, View1: View, View2: View> {
    public var view0: View0
    public var view1: View1
    public var view2: View2

    public init(_ view0: View0, _ view1: View1, _ view2: View2) {
        self.view0 = view0
        self.view1 = view1
        self.view2 = view2
    }
}

extension ViewContent3: ViewContent {
    public typealias Children = ViewGraphNodeChildren3<View0, View1, View2>
}

public struct ViewContent4<View0: View, View1: View, View2: View, View3: View> {
    public var view0: View0
    public var view1: View1
    public var view2: View2
    public var view3: View3

    public init(_ view0: View0, _ view1: View1, _ view2: View2, _ view3: View3) {
        self.view0 = view0
        self.view1 = view1
        self.view2 = view2
        self.view3 = view3
    }
}

extension ViewContent4: ViewContent {
    public typealias Children = ViewGraphNodeChildren4<View0, View1, View2, View3>
}

public struct ViewContent5<View0: View, View1: View, View2: View, View3: View, View4: View> {
    public var view0: View0
    public var view1: View1
    public var view2: View2
    public var view3: View3
    public var view4: View4

    public init(_ view0: View0, _ view1: View1, _ view2: View2, _ view3: View3, _ view4: View4) {
        self.view0 = view0
        self.view1 = view1
        self.view2 = view2
        self.view3 = view3
        self.view4 = view4
    }
}

extension ViewContent5: ViewContent {
    public typealias Children = ViewGraphNodeChildren5<View0, View1, View2, View3, View4>
}

public struct ViewContent6<
    View0: View, View1: View, View2: View, View3: View, View4: View, View5: View
> {
    public var view0: View0
    public var view1: View1
    public var view2: View2
    public var view3: View3
    public var view4: View4
    public var view5: View5

    public init(
        _ view0: View0, _ view1: View1, _ view2: View2, _ view3: View3, _ view4: View4,
        _ view5: View5
    ) {
        self.view0 = view0
        self.view1 = view1
        self.view2 = view2
        self.view3 = view3
        self.view4 = view4
        self.view5 = view5
    }
}

extension ViewContent6: ViewContent {
    public typealias Children = ViewGraphNodeChildren6<View0, View1, View2, View3, View4, View5>
}

public struct ViewContent7<
    View0: View, View1: View, View2: View, View3: View, View4: View, View5: View, View6: View
> {
    public var view0: View0
    public var view1: View1
    public var view2: View2
    public var view3: View3
    public var view4: View4
    public var view5: View5
    public var view6: View6

    public init(
        _ view0: View0, _ view1: View1, _ view2: View2, _ view3: View3, _ view4: View4,
        _ view5: View5, _ view6: View6
    ) {
        self.view0 = view0
        self.view1 = view1
        self.view2 = view2
        self.view3 = view3
        self.view4 = view4
        self.view5 = view5
        self.view6 = view6
    }
}

extension ViewContent7: ViewContent {
    public typealias Children = ViewGraphNodeChildren7<
        View0, View1, View2, View3, View4, View5, View6
    >
}

public struct ViewContent8<
    View0: View, View1: View, View2: View, View3: View, View4: View, View5: View, View6: View,
    View7: View
> {
    public var view0: View0
    public var view1: View1
    public var view2: View2
    public var view3: View3
    public var view4: View4
    public var view5: View5
    public var view6: View6
    public var view7: View7

    public init(
        _ view0: View0, _ view1: View1, _ view2: View2, _ view3: View3, _ view4: View4,
        _ view5: View5, _ view6: View6, _ view7: View7
    ) {
        self.view0 = view0
        self.view1 = view1
        self.view2 = view2
        self.view3 = view3
        self.view4 = view4
        self.view5 = view5
        self.view6 = view6
        self.view7 = view7
    }
}

extension ViewContent8: ViewContent {
    public typealias Children = ViewGraphNodeChildren8<
        View0, View1, View2, View3, View4, View5, View6, View7
    >
}

public struct ViewContent9<
    View0: View, View1: View, View2: View, View3: View, View4: View, View5: View, View6: View,
    View7: View, View8: View
> {
    public var view0: View0
    public var view1: View1
    public var view2: View2
    public var view3: View3
    public var view4: View4
    public var view5: View5
    public var view6: View6
    public var view7: View7
    public var view8: View8

    public init(
        _ view0: View0, _ view1: View1, _ view2: View2, _ view3: View3, _ view4: View4,
        _ view5: View5, _ view6: View6, _ view7: View7, _ view8: View8
    ) {
        self.view0 = view0
        self.view1 = view1
        self.view2 = view2
        self.view3 = view3
        self.view4 = view4
        self.view5 = view5
        self.view6 = view6
        self.view7 = view7
        self.view8 = view8
    }
}

extension ViewContent9: ViewContent {
    public typealias Children = ViewGraphNodeChildren9<
        View0, View1, View2, View3, View4, View5, View6, View7, View8
    >
}

public struct ViewContent10<
    View0: View, View1: View, View2: View, View3: View, View4: View, View5: View, View6: View,
    View7: View, View8: View, View9: View
> {
    public var view0: View0
    public var view1: View1
    public var view2: View2
    public var view3: View3
    public var view4: View4
    public var view5: View5
    public var view6: View6
    public var view7: View7
    public var view8: View8
    public var view9: View9

    public init(
        _ view0: View0, _ view1: View1, _ view2: View2, _ view3: View3, _ view4: View4,
        _ view5: View5, _ view6: View6, _ view7: View7, _ view8: View8, _ view9: View9
    ) {
        self.view0 = view0
        self.view1 = view1
        self.view2 = view2
        self.view3 = view3
        self.view4 = view4
        self.view5 = view5
        self.view6 = view6
        self.view7 = view7
        self.view8 = view8
        self.view9 = view9
    }
}

extension ViewContent10: ViewContent {
    public typealias Children = ViewGraphNodeChildren10<
        View0, View1, View2, View3, View4, View5, View6, View7, View8, View9
    >
}
