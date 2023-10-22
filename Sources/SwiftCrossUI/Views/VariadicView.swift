

public struct VariadicView1<View0: View>: ContainerView {
    public typealias Content = EmptyView
    public typealias NodeChildren = ViewGraphNodeChildren1<View0>
    public typealias State = EmptyState

    public var view0: View0

    public var body = EmptyView()

    public init(_ view0: View0) {
        self.view0 = view0
    }

    public func asChildren<Backend: AppBackend>(backend: Backend) -> NodeChildren {
        return NodeChildren(
            view0,
            backend: backend
        )
    }

    public func updateChildren<Backend: AppBackend>(_ children: NodeChildren, backend: Backend) {
        children.child0.update(with: view0)
    }

    public func asWidget<Backend: AppBackend>(_ children: [Backend.Widget], backend: Backend) -> Backend.Widget {
        let container = backend.createPassthroughVStack(spacing: 0)
        backend.addChildren(children, toPassthroughVStack: container)
        return container
    }

    public func update<Backend: AppBackend>(_ widget: Backend.Widget, children: [Backend.Widget], backend: Backend) {
        print("Updating variadic view")
        backend.updatePassthroughVStack(widget)
        print("Updated variadic view")
    }    
}

public struct VariadicView2<View0: View, View1: View>: ContainerView {
    public typealias Content = EmptyView
    public typealias NodeChildren = ViewGraphNodeChildren2<View0, View1>
    public typealias State = EmptyState

    public var view0: View0
    public var view1: View1

    public var body = EmptyView()

    public init(_ view0: View0, _ view1: View1) {
        self.view0 = view0
        self.view1 = view1
    }

    public func asChildren<Backend: AppBackend>(backend: Backend) -> NodeChildren {
        return NodeChildren(
            view0,
            view1,
            backend: backend
        )
    }

    public func updateChildren<Backend: AppBackend>(_ children: NodeChildren, backend: Backend) {
        children.child0.update(with: view0)
        children.child1.update(with: view1)
    }

    public func asWidget<Backend: AppBackend>(_ children: [Backend.Widget], backend: Backend) -> Backend.Widget {
        let container = backend.createPassthroughVStack(spacing: 0)
        backend.addChildren(children, toPassthroughVStack: container)
        return container
    }

    public func update<Backend: AppBackend>(_ widget: Backend.Widget, children: [Backend.Widget], backend: Backend) {
        print("Updating variadic view")
        backend.updatePassthroughVStack(widget)
        print("Updated variadic view")
    }    
}

public struct VariadicView3<View0: View, View1: View, View2: View>: ContainerView {
    public typealias Content = EmptyView
    public typealias NodeChildren = ViewGraphNodeChildren3<View0, View1, View2>
    public typealias State = EmptyState

    public var view0: View0
    public var view1: View1
    public var view2: View2

    public var body = EmptyView()

    public init(_ view0: View0, _ view1: View1, _ view2: View2) {
        self.view0 = view0
        self.view1 = view1
        self.view2 = view2
    }

    public func asChildren<Backend: AppBackend>(backend: Backend) -> NodeChildren {
        return NodeChildren(
            view0,
            view1,
            view2,
            backend: backend
        )
    }

    public func updateChildren<Backend: AppBackend>(_ children: NodeChildren, backend: Backend) {
        children.child0.update(with: view0)
        children.child1.update(with: view1)
        children.child2.update(with: view2)
    }

    public func asWidget<Backend: AppBackend>(_ children: [Backend.Widget], backend: Backend) -> Backend.Widget {
        let container = backend.createPassthroughVStack(spacing: 0)
        backend.addChildren(children, toPassthroughVStack: container)
        return container
    }

    public func update<Backend: AppBackend>(_ widget: Backend.Widget, children: [Backend.Widget], backend: Backend) {
        print("Updating variadic view")
        backend.updatePassthroughVStack(widget)
        print("Updated variadic view")
    }    
}

public struct VariadicView4<View0: View, View1: View, View2: View, View3: View>: ContainerView {
    public typealias Content = EmptyView
    public typealias NodeChildren = ViewGraphNodeChildren4<View0, View1, View2, View3>
    public typealias State = EmptyState

    public var view0: View0
    public var view1: View1
    public var view2: View2
    public var view3: View3

    public var body = EmptyView()

    public init(_ view0: View0, _ view1: View1, _ view2: View2, _ view3: View3) {
        self.view0 = view0
        self.view1 = view1
        self.view2 = view2
        self.view3 = view3
    }

    public func asChildren<Backend: AppBackend>(backend: Backend) -> NodeChildren {
        return NodeChildren(
            view0,
            view1,
            view2,
            view3,
            backend: backend
        )
    }

    public func updateChildren<Backend: AppBackend>(_ children: NodeChildren, backend: Backend) {
        children.child0.update(with: view0)
        children.child1.update(with: view1)
        children.child2.update(with: view2)
        children.child3.update(with: view3)
    }

    public func asWidget<Backend: AppBackend>(_ children: [Backend.Widget], backend: Backend) -> Backend.Widget {
        let container = backend.createPassthroughVStack(spacing: 0)
        backend.addChildren(children, toPassthroughVStack: container)
        return container
    }

    public func update<Backend: AppBackend>(_ widget: Backend.Widget, children: [Backend.Widget], backend: Backend) {
        print("Updating variadic view")
        backend.updatePassthroughVStack(widget)
        print("Updated variadic view")
    }    
}

public struct VariadicView5<View0: View, View1: View, View2: View, View3: View, View4: View>: ContainerView {
    public typealias Content = EmptyView
    public typealias NodeChildren = ViewGraphNodeChildren5<View0, View1, View2, View3, View4>
    public typealias State = EmptyState

    public var view0: View0
    public var view1: View1
    public var view2: View2
    public var view3: View3
    public var view4: View4

    public var body = EmptyView()

    public init(_ view0: View0, _ view1: View1, _ view2: View2, _ view3: View3, _ view4: View4) {
        self.view0 = view0
        self.view1 = view1
        self.view2 = view2
        self.view3 = view3
        self.view4 = view4
    }

    public func asChildren<Backend: AppBackend>(backend: Backend) -> NodeChildren {
        return NodeChildren(
            view0,
            view1,
            view2,
            view3,
            view4,
            backend: backend
        )
    }

    public func updateChildren<Backend: AppBackend>(_ children: NodeChildren, backend: Backend) {
        children.child0.update(with: view0)
        children.child1.update(with: view1)
        children.child2.update(with: view2)
        children.child3.update(with: view3)
        children.child4.update(with: view4)
    }

    public func asWidget<Backend: AppBackend>(_ children: [Backend.Widget], backend: Backend) -> Backend.Widget {
        let container = backend.createPassthroughVStack(spacing: 0)
        backend.addChildren(children, toPassthroughVStack: container)
        return container
    }

    public func update<Backend: AppBackend>(_ widget: Backend.Widget, children: [Backend.Widget], backend: Backend) {
        print("Updating variadic view")
        backend.updatePassthroughVStack(widget)
        print("Updated variadic view")
    }    
}

public struct VariadicView6<View0: View, View1: View, View2: View, View3: View, View4: View, View5: View>: ContainerView {
    public typealias Content = EmptyView
    public typealias NodeChildren = ViewGraphNodeChildren6<View0, View1, View2, View3, View4, View5>
    public typealias State = EmptyState

    public var view0: View0
    public var view1: View1
    public var view2: View2
    public var view3: View3
    public var view4: View4
    public var view5: View5

    public var body = EmptyView()

    public init(_ view0: View0, _ view1: View1, _ view2: View2, _ view3: View3, _ view4: View4, _ view5: View5) {
        self.view0 = view0
        self.view1 = view1
        self.view2 = view2
        self.view3 = view3
        self.view4 = view4
        self.view5 = view5
    }

    public func asChildren<Backend: AppBackend>(backend: Backend) -> NodeChildren {
        return NodeChildren(
            view0,
            view1,
            view2,
            view3,
            view4,
            view5,
            backend: backend
        )
    }

    public func updateChildren<Backend: AppBackend>(_ children: NodeChildren, backend: Backend) {
        children.child0.update(with: view0)
        children.child1.update(with: view1)
        children.child2.update(with: view2)
        children.child3.update(with: view3)
        children.child4.update(with: view4)
        children.child5.update(with: view5)
    }

    public func asWidget<Backend: AppBackend>(_ children: [Backend.Widget], backend: Backend) -> Backend.Widget {
        let container = backend.createPassthroughVStack(spacing: 0)
        backend.addChildren(children, toPassthroughVStack: container)
        return container
    }

    public func update<Backend: AppBackend>(_ widget: Backend.Widget, children: [Backend.Widget], backend: Backend) {
        print("Updating variadic view")
        backend.updatePassthroughVStack(widget)
        print("Updated variadic view")
    }    
}

public struct VariadicView7<View0: View, View1: View, View2: View, View3: View, View4: View, View5: View, View6: View>: ContainerView {
    public typealias Content = EmptyView
    public typealias NodeChildren = ViewGraphNodeChildren7<View0, View1, View2, View3, View4, View5, View6>
    public typealias State = EmptyState

    public var view0: View0
    public var view1: View1
    public var view2: View2
    public var view3: View3
    public var view4: View4
    public var view5: View5
    public var view6: View6

    public var body = EmptyView()

    public init(_ view0: View0, _ view1: View1, _ view2: View2, _ view3: View3, _ view4: View4, _ view5: View5, _ view6: View6) {
        self.view0 = view0
        self.view1 = view1
        self.view2 = view2
        self.view3 = view3
        self.view4 = view4
        self.view5 = view5
        self.view6 = view6
    }

    public func asChildren<Backend: AppBackend>(backend: Backend) -> NodeChildren {
        return NodeChildren(
            view0,
            view1,
            view2,
            view3,
            view4,
            view5,
            view6,
            backend: backend
        )
    }

    public func updateChildren<Backend: AppBackend>(_ children: NodeChildren, backend: Backend) {
        children.child0.update(with: view0)
        children.child1.update(with: view1)
        children.child2.update(with: view2)
        children.child3.update(with: view3)
        children.child4.update(with: view4)
        children.child5.update(with: view5)
        children.child6.update(with: view6)
    }

    public func asWidget<Backend: AppBackend>(_ children: [Backend.Widget], backend: Backend) -> Backend.Widget {
        let container = backend.createPassthroughVStack(spacing: 0)
        backend.addChildren(children, toPassthroughVStack: container)
        return container
    }

    public func update<Backend: AppBackend>(_ widget: Backend.Widget, children: [Backend.Widget], backend: Backend) {
        print("Updating variadic view")
        backend.updatePassthroughVStack(widget)
        print("Updated variadic view")
    }    
}

public struct VariadicView8<View0: View, View1: View, View2: View, View3: View, View4: View, View5: View, View6: View, View7: View>: ContainerView {
    public typealias Content = EmptyView
    public typealias NodeChildren = ViewGraphNodeChildren8<View0, View1, View2, View3, View4, View5, View6, View7>
    public typealias State = EmptyState

    public var view0: View0
    public var view1: View1
    public var view2: View2
    public var view3: View3
    public var view4: View4
    public var view5: View5
    public var view6: View6
    public var view7: View7

    public var body = EmptyView()

    public init(_ view0: View0, _ view1: View1, _ view2: View2, _ view3: View3, _ view4: View4, _ view5: View5, _ view6: View6, _ view7: View7) {
        self.view0 = view0
        self.view1 = view1
        self.view2 = view2
        self.view3 = view3
        self.view4 = view4
        self.view5 = view5
        self.view6 = view6
        self.view7 = view7
    }

    public func asChildren<Backend: AppBackend>(backend: Backend) -> NodeChildren {
        return NodeChildren(
            view0,
            view1,
            view2,
            view3,
            view4,
            view5,
            view6,
            view7,
            backend: backend
        )
    }

    public func updateChildren<Backend: AppBackend>(_ children: NodeChildren, backend: Backend) {
        children.child0.update(with: view0)
        children.child1.update(with: view1)
        children.child2.update(with: view2)
        children.child3.update(with: view3)
        children.child4.update(with: view4)
        children.child5.update(with: view5)
        children.child6.update(with: view6)
        children.child7.update(with: view7)
    }

    public func asWidget<Backend: AppBackend>(_ children: [Backend.Widget], backend: Backend) -> Backend.Widget {
        let container = backend.createPassthroughVStack(spacing: 0)
        backend.addChildren(children, toPassthroughVStack: container)
        return container
    }

    public func update<Backend: AppBackend>(_ widget: Backend.Widget, children: [Backend.Widget], backend: Backend) {
        print("Updating variadic view")
        backend.updatePassthroughVStack(widget)
        print("Updated variadic view")
    }    
}

public struct VariadicView9<View0: View, View1: View, View2: View, View3: View, View4: View, View5: View, View6: View, View7: View, View8: View>: ContainerView {
    public typealias Content = EmptyView
    public typealias NodeChildren = ViewGraphNodeChildren9<View0, View1, View2, View3, View4, View5, View6, View7, View8>
    public typealias State = EmptyState

    public var view0: View0
    public var view1: View1
    public var view2: View2
    public var view3: View3
    public var view4: View4
    public var view5: View5
    public var view6: View6
    public var view7: View7
    public var view8: View8

    public var body = EmptyView()

    public init(_ view0: View0, _ view1: View1, _ view2: View2, _ view3: View3, _ view4: View4, _ view5: View5, _ view6: View6, _ view7: View7, _ view8: View8) {
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

    public func asChildren<Backend: AppBackend>(backend: Backend) -> NodeChildren {
        return NodeChildren(
            view0,
            view1,
            view2,
            view3,
            view4,
            view5,
            view6,
            view7,
            view8,
            backend: backend
        )
    }

    public func updateChildren<Backend: AppBackend>(_ children: NodeChildren, backend: Backend) {
        children.child0.update(with: view0)
        children.child1.update(with: view1)
        children.child2.update(with: view2)
        children.child3.update(with: view3)
        children.child4.update(with: view4)
        children.child5.update(with: view5)
        children.child6.update(with: view6)
        children.child7.update(with: view7)
        children.child8.update(with: view8)
    }

    public func asWidget<Backend: AppBackend>(_ children: [Backend.Widget], backend: Backend) -> Backend.Widget {
        let container = backend.createPassthroughVStack(spacing: 0)
        backend.addChildren(children, toPassthroughVStack: container)
        return container
    }

    public func update<Backend: AppBackend>(_ widget: Backend.Widget, children: [Backend.Widget], backend: Backend) {
        print("Updating variadic view")
        backend.updatePassthroughVStack(widget)
        print("Updated variadic view")
    }    
}

public struct VariadicView10<View0: View, View1: View, View2: View, View3: View, View4: View, View5: View, View6: View, View7: View, View8: View, View9: View>: ContainerView {
    public typealias Content = EmptyView
    public typealias NodeChildren = ViewGraphNodeChildren10<View0, View1, View2, View3, View4, View5, View6, View7, View8, View9>
    public typealias State = EmptyState

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

    public var body = EmptyView()

    public init(_ view0: View0, _ view1: View1, _ view2: View2, _ view3: View3, _ view4: View4, _ view5: View5, _ view6: View6, _ view7: View7, _ view8: View8, _ view9: View9) {
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

    public func asChildren<Backend: AppBackend>(backend: Backend) -> NodeChildren {
        return NodeChildren(
            view0,
            view1,
            view2,
            view3,
            view4,
            view5,
            view6,
            view7,
            view8,
            view9,
            backend: backend
        )
    }

    public func updateChildren<Backend: AppBackend>(_ children: NodeChildren, backend: Backend) {
        children.child0.update(with: view0)
        children.child1.update(with: view1)
        children.child2.update(with: view2)
        children.child3.update(with: view3)
        children.child4.update(with: view4)
        children.child5.update(with: view5)
        children.child6.update(with: view6)
        children.child7.update(with: view7)
        children.child8.update(with: view8)
        children.child9.update(with: view9)
    }

    public func asWidget<Backend: AppBackend>(_ children: [Backend.Widget], backend: Backend) -> Backend.Widget {
        let container = backend.createPassthroughVStack(spacing: 0)
        backend.addChildren(children, toPassthroughVStack: container)
        return container
    }

    public func update<Backend: AppBackend>(_ widget: Backend.Widget, children: [Backend.Widget], backend: Backend) {
        print("Updating variadic view")
        backend.updatePassthroughVStack(widget)
        print("Updated variadic view")
    }    
}
