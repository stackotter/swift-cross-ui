
public protocol ViewGraphNodeChildren {
    associatedtype Content: ViewContent where Content.Children == Self
    
    var widgets: [AnyWidget] { get }

    init<Backend: AppBackend>(from content: Content, backend: Backend)

    func update<Backend: AppBackend>(with content: Content, backend: Backend)
}

public struct EmptyViewGraphNodeChildren: ViewGraphNodeChildren {
    public let widgets: [AnyWidget] = []

    public init<Backend: AppBackend>(from content: EmptyViewContent, backend: Backend) {}

    public func update<Backend: AppBackend>(with content: EmptyViewContent, backend: Backend) {}
}


public struct ViewGraphNodeChildren1<Child0: View>: ViewGraphNodeChildren {
    public typealias Content = ViewContent1<Child0>
    
    public var widgets: [AnyWidget] {
        return [
                child0.widget,
        ]
    }

    public var child0: AnyViewGraphNode<Child0>

    public init<Backend: AppBackend>(from content: Content, backend: Backend) {
        self.child0 = AnyViewGraphNode(for: content.view0, backend: backend)
    }

    public func update<Backend: AppBackend>(with content: Content, backend: Backend) {
        child0.update(with: content.view0)
    }
}

public struct ViewGraphNodeChildren2<Child0: View, Child1: View>: ViewGraphNodeChildren {
    public typealias Content = ViewContent2<Child0, Child1>
    
    public var widgets: [AnyWidget] {
        return [
                child0.widget,
                child1.widget,
        ]
    }

    public var child0: AnyViewGraphNode<Child0>
    public var child1: AnyViewGraphNode<Child1>

    public init<Backend: AppBackend>(from content: Content, backend: Backend) {
        self.child0 = AnyViewGraphNode(for: content.view0, backend: backend)
        self.child1 = AnyViewGraphNode(for: content.view1, backend: backend)
    }

    public func update<Backend: AppBackend>(with content: Content, backend: Backend) {
        child0.update(with: content.view0)
        child1.update(with: content.view1)
    }
}

public struct ViewGraphNodeChildren3<Child0: View, Child1: View, Child2: View>: ViewGraphNodeChildren {
    public typealias Content = ViewContent3<Child0, Child1, Child2>
    
    public var widgets: [AnyWidget] {
        return [
                child0.widget,
                child1.widget,
                child2.widget,
        ]
    }

    public var child0: AnyViewGraphNode<Child0>
    public var child1: AnyViewGraphNode<Child1>
    public var child2: AnyViewGraphNode<Child2>

    public init<Backend: AppBackend>(from content: Content, backend: Backend) {
        self.child0 = AnyViewGraphNode(for: content.view0, backend: backend)
        self.child1 = AnyViewGraphNode(for: content.view1, backend: backend)
        self.child2 = AnyViewGraphNode(for: content.view2, backend: backend)
    }

    public func update<Backend: AppBackend>(with content: Content, backend: Backend) {
        child0.update(with: content.view0)
        child1.update(with: content.view1)
        child2.update(with: content.view2)
    }
}

public struct ViewGraphNodeChildren4<Child0: View, Child1: View, Child2: View, Child3: View>: ViewGraphNodeChildren {
    public typealias Content = ViewContent4<Child0, Child1, Child2, Child3>
    
    public var widgets: [AnyWidget] {
        return [
                child0.widget,
                child1.widget,
                child2.widget,
                child3.widget,
        ]
    }

    public var child0: AnyViewGraphNode<Child0>
    public var child1: AnyViewGraphNode<Child1>
    public var child2: AnyViewGraphNode<Child2>
    public var child3: AnyViewGraphNode<Child3>

    public init<Backend: AppBackend>(from content: Content, backend: Backend) {
        self.child0 = AnyViewGraphNode(for: content.view0, backend: backend)
        self.child1 = AnyViewGraphNode(for: content.view1, backend: backend)
        self.child2 = AnyViewGraphNode(for: content.view2, backend: backend)
        self.child3 = AnyViewGraphNode(for: content.view3, backend: backend)
    }

    public func update<Backend: AppBackend>(with content: Content, backend: Backend) {
        child0.update(with: content.view0)
        child1.update(with: content.view1)
        child2.update(with: content.view2)
        child3.update(with: content.view3)
    }
}

public struct ViewGraphNodeChildren5<Child0: View, Child1: View, Child2: View, Child3: View, Child4: View>: ViewGraphNodeChildren {
    public typealias Content = ViewContent5<Child0, Child1, Child2, Child3, Child4>
    
    public var widgets: [AnyWidget] {
        return [
                child0.widget,
                child1.widget,
                child2.widget,
                child3.widget,
                child4.widget,
        ]
    }

    public var child0: AnyViewGraphNode<Child0>
    public var child1: AnyViewGraphNode<Child1>
    public var child2: AnyViewGraphNode<Child2>
    public var child3: AnyViewGraphNode<Child3>
    public var child4: AnyViewGraphNode<Child4>

    public init<Backend: AppBackend>(from content: Content, backend: Backend) {
        self.child0 = AnyViewGraphNode(for: content.view0, backend: backend)
        self.child1 = AnyViewGraphNode(for: content.view1, backend: backend)
        self.child2 = AnyViewGraphNode(for: content.view2, backend: backend)
        self.child3 = AnyViewGraphNode(for: content.view3, backend: backend)
        self.child4 = AnyViewGraphNode(for: content.view4, backend: backend)
    }

    public func update<Backend: AppBackend>(with content: Content, backend: Backend) {
        child0.update(with: content.view0)
        child1.update(with: content.view1)
        child2.update(with: content.view2)
        child3.update(with: content.view3)
        child4.update(with: content.view4)
    }
}

public struct ViewGraphNodeChildren6<Child0: View, Child1: View, Child2: View, Child3: View, Child4: View, Child5: View>: ViewGraphNodeChildren {
    public typealias Content = ViewContent6<Child0, Child1, Child2, Child3, Child4, Child5>
    
    public var widgets: [AnyWidget] {
        return [
                child0.widget,
                child1.widget,
                child2.widget,
                child3.widget,
                child4.widget,
                child5.widget,
        ]
    }

    public var child0: AnyViewGraphNode<Child0>
    public var child1: AnyViewGraphNode<Child1>
    public var child2: AnyViewGraphNode<Child2>
    public var child3: AnyViewGraphNode<Child3>
    public var child4: AnyViewGraphNode<Child4>
    public var child5: AnyViewGraphNode<Child5>

    public init<Backend: AppBackend>(from content: Content, backend: Backend) {
        self.child0 = AnyViewGraphNode(for: content.view0, backend: backend)
        self.child1 = AnyViewGraphNode(for: content.view1, backend: backend)
        self.child2 = AnyViewGraphNode(for: content.view2, backend: backend)
        self.child3 = AnyViewGraphNode(for: content.view3, backend: backend)
        self.child4 = AnyViewGraphNode(for: content.view4, backend: backend)
        self.child5 = AnyViewGraphNode(for: content.view5, backend: backend)
    }

    public func update<Backend: AppBackend>(with content: Content, backend: Backend) {
        child0.update(with: content.view0)
        child1.update(with: content.view1)
        child2.update(with: content.view2)
        child3.update(with: content.view3)
        child4.update(with: content.view4)
        child5.update(with: content.view5)
    }
}

public struct ViewGraphNodeChildren7<Child0: View, Child1: View, Child2: View, Child3: View, Child4: View, Child5: View, Child6: View>: ViewGraphNodeChildren {
    public typealias Content = ViewContent7<Child0, Child1, Child2, Child3, Child4, Child5, Child6>
    
    public var widgets: [AnyWidget] {
        return [
                child0.widget,
                child1.widget,
                child2.widget,
                child3.widget,
                child4.widget,
                child5.widget,
                child6.widget,
        ]
    }

    public var child0: AnyViewGraphNode<Child0>
    public var child1: AnyViewGraphNode<Child1>
    public var child2: AnyViewGraphNode<Child2>
    public var child3: AnyViewGraphNode<Child3>
    public var child4: AnyViewGraphNode<Child4>
    public var child5: AnyViewGraphNode<Child5>
    public var child6: AnyViewGraphNode<Child6>

    public init<Backend: AppBackend>(from content: Content, backend: Backend) {
        self.child0 = AnyViewGraphNode(for: content.view0, backend: backend)
        self.child1 = AnyViewGraphNode(for: content.view1, backend: backend)
        self.child2 = AnyViewGraphNode(for: content.view2, backend: backend)
        self.child3 = AnyViewGraphNode(for: content.view3, backend: backend)
        self.child4 = AnyViewGraphNode(for: content.view4, backend: backend)
        self.child5 = AnyViewGraphNode(for: content.view5, backend: backend)
        self.child6 = AnyViewGraphNode(for: content.view6, backend: backend)
    }

    public func update<Backend: AppBackend>(with content: Content, backend: Backend) {
        child0.update(with: content.view0)
        child1.update(with: content.view1)
        child2.update(with: content.view2)
        child3.update(with: content.view3)
        child4.update(with: content.view4)
        child5.update(with: content.view5)
        child6.update(with: content.view6)
    }
}

public struct ViewGraphNodeChildren8<Child0: View, Child1: View, Child2: View, Child3: View, Child4: View, Child5: View, Child6: View, Child7: View>: ViewGraphNodeChildren {
    public typealias Content = ViewContent8<Child0, Child1, Child2, Child3, Child4, Child5, Child6, Child7>
    
    public var widgets: [AnyWidget] {
        return [
                child0.widget,
                child1.widget,
                child2.widget,
                child3.widget,
                child4.widget,
                child5.widget,
                child6.widget,
                child7.widget,
        ]
    }

    public var child0: AnyViewGraphNode<Child0>
    public var child1: AnyViewGraphNode<Child1>
    public var child2: AnyViewGraphNode<Child2>
    public var child3: AnyViewGraphNode<Child3>
    public var child4: AnyViewGraphNode<Child4>
    public var child5: AnyViewGraphNode<Child5>
    public var child6: AnyViewGraphNode<Child6>
    public var child7: AnyViewGraphNode<Child7>

    public init<Backend: AppBackend>(from content: Content, backend: Backend) {
        self.child0 = AnyViewGraphNode(for: content.view0, backend: backend)
        self.child1 = AnyViewGraphNode(for: content.view1, backend: backend)
        self.child2 = AnyViewGraphNode(for: content.view2, backend: backend)
        self.child3 = AnyViewGraphNode(for: content.view3, backend: backend)
        self.child4 = AnyViewGraphNode(for: content.view4, backend: backend)
        self.child5 = AnyViewGraphNode(for: content.view5, backend: backend)
        self.child6 = AnyViewGraphNode(for: content.view6, backend: backend)
        self.child7 = AnyViewGraphNode(for: content.view7, backend: backend)
    }

    public func update<Backend: AppBackend>(with content: Content, backend: Backend) {
        child0.update(with: content.view0)
        child1.update(with: content.view1)
        child2.update(with: content.view2)
        child3.update(with: content.view3)
        child4.update(with: content.view4)
        child5.update(with: content.view5)
        child6.update(with: content.view6)
        child7.update(with: content.view7)
    }
}

public struct ViewGraphNodeChildren9<Child0: View, Child1: View, Child2: View, Child3: View, Child4: View, Child5: View, Child6: View, Child7: View, Child8: View>: ViewGraphNodeChildren {
    public typealias Content = ViewContent9<Child0, Child1, Child2, Child3, Child4, Child5, Child6, Child7, Child8>
    
    public var widgets: [AnyWidget] {
        return [
                child0.widget,
                child1.widget,
                child2.widget,
                child3.widget,
                child4.widget,
                child5.widget,
                child6.widget,
                child7.widget,
                child8.widget,
        ]
    }

    public var child0: AnyViewGraphNode<Child0>
    public var child1: AnyViewGraphNode<Child1>
    public var child2: AnyViewGraphNode<Child2>
    public var child3: AnyViewGraphNode<Child3>
    public var child4: AnyViewGraphNode<Child4>
    public var child5: AnyViewGraphNode<Child5>
    public var child6: AnyViewGraphNode<Child6>
    public var child7: AnyViewGraphNode<Child7>
    public var child8: AnyViewGraphNode<Child8>

    public init<Backend: AppBackend>(from content: Content, backend: Backend) {
        self.child0 = AnyViewGraphNode(for: content.view0, backend: backend)
        self.child1 = AnyViewGraphNode(for: content.view1, backend: backend)
        self.child2 = AnyViewGraphNode(for: content.view2, backend: backend)
        self.child3 = AnyViewGraphNode(for: content.view3, backend: backend)
        self.child4 = AnyViewGraphNode(for: content.view4, backend: backend)
        self.child5 = AnyViewGraphNode(for: content.view5, backend: backend)
        self.child6 = AnyViewGraphNode(for: content.view6, backend: backend)
        self.child7 = AnyViewGraphNode(for: content.view7, backend: backend)
        self.child8 = AnyViewGraphNode(for: content.view8, backend: backend)
    }

    public func update<Backend: AppBackend>(with content: Content, backend: Backend) {
        child0.update(with: content.view0)
        child1.update(with: content.view1)
        child2.update(with: content.view2)
        child3.update(with: content.view3)
        child4.update(with: content.view4)
        child5.update(with: content.view5)
        child6.update(with: content.view6)
        child7.update(with: content.view7)
        child8.update(with: content.view8)
    }
}

public struct ViewGraphNodeChildren10<Child0: View, Child1: View, Child2: View, Child3: View, Child4: View, Child5: View, Child6: View, Child7: View, Child8: View, Child9: View>: ViewGraphNodeChildren {
    public typealias Content = ViewContent10<Child0, Child1, Child2, Child3, Child4, Child5, Child6, Child7, Child8, Child9>
    
    public var widgets: [AnyWidget] {
        return [
                child0.widget,
                child1.widget,
                child2.widget,
                child3.widget,
                child4.widget,
                child5.widget,
                child6.widget,
                child7.widget,
                child8.widget,
                child9.widget,
        ]
    }

    public var child0: AnyViewGraphNode<Child0>
    public var child1: AnyViewGraphNode<Child1>
    public var child2: AnyViewGraphNode<Child2>
    public var child3: AnyViewGraphNode<Child3>
    public var child4: AnyViewGraphNode<Child4>
    public var child5: AnyViewGraphNode<Child5>
    public var child6: AnyViewGraphNode<Child6>
    public var child7: AnyViewGraphNode<Child7>
    public var child8: AnyViewGraphNode<Child8>
    public var child9: AnyViewGraphNode<Child9>

    public init<Backend: AppBackend>(from content: Content, backend: Backend) {
        self.child0 = AnyViewGraphNode(for: content.view0, backend: backend)
        self.child1 = AnyViewGraphNode(for: content.view1, backend: backend)
        self.child2 = AnyViewGraphNode(for: content.view2, backend: backend)
        self.child3 = AnyViewGraphNode(for: content.view3, backend: backend)
        self.child4 = AnyViewGraphNode(for: content.view4, backend: backend)
        self.child5 = AnyViewGraphNode(for: content.view5, backend: backend)
        self.child6 = AnyViewGraphNode(for: content.view6, backend: backend)
        self.child7 = AnyViewGraphNode(for: content.view7, backend: backend)
        self.child8 = AnyViewGraphNode(for: content.view8, backend: backend)
        self.child9 = AnyViewGraphNode(for: content.view9, backend: backend)
    }

    public func update<Backend: AppBackend>(with content: Content, backend: Backend) {
        child0.update(with: content.view0)
        child1.update(with: content.view1)
        child2.update(with: content.view2)
        child3.update(with: content.view3)
        child4.update(with: content.view4)
        child5.update(with: content.view5)
        child6.update(with: content.view6)
        child7.update(with: content.view7)
        child8.update(with: content.view8)
        child9.update(with: content.view9)
    }
}
