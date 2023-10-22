
public protocol ViewGraphNodeChildren {
    var widgets: [AnyWidget] { get }
}

public struct AnyContainerView {
    public let asChildren: () -> any ViewGraphNodeChildren
    public let updateChildren: (any ViewGraphNodeChildren) -> Void

    public init<V: ContainerView, Backend: AppBackend>(_ containerView: V, backend: Backend) {
        asChildren = {
            return containerView.asChildren(backend: backend)
        }

        updateChildren = { children in
            guard let children = children as? V.NodeChildren else {
                fatalError("Passed incorrect children type to container view for updating")
            }
            containerView.updateChildren(children, backend: backend)
        }
    }
}

public struct EmptyViewGraphNodeChildren: ViewGraphNodeChildren {
    public let widgets: [AnyWidget] = []

    public init() {}
}


public struct ViewGraphNodeChildren1<Child0: View>: ViewGraphNodeChildren {
    public var widgets: [AnyWidget] {
        return [
            child0.widget,
        ]
    }

    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child0: AnyViewGraphNode<Child0>

    public init<Backend: AppBackend>(
        _ child0: Child0,
        backend: Backend
    ) {
        self.child0 = AnyViewGraphNode(for: child0, backend: backend)
    }
}

public struct ViewGraphNodeChildren2<Child0: View, Child1: View>: ViewGraphNodeChildren {
    public var widgets: [AnyWidget] {
        return [
            child0.widget,
            child1.widget,
        ]
    }

    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child0: AnyViewGraphNode<Child0>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child1: AnyViewGraphNode<Child1>

    public init<Backend: AppBackend>(
        _ child0: Child0,
        _ child1: Child1,
        backend: Backend
    ) {
        self.child0 = AnyViewGraphNode(for: child0, backend: backend)
        self.child1 = AnyViewGraphNode(for: child1, backend: backend)
    }
}

public struct ViewGraphNodeChildren3<Child0: View, Child1: View, Child2: View>: ViewGraphNodeChildren {
    public var widgets: [AnyWidget] {
        return [
            child0.widget,
            child1.widget,
            child2.widget,
        ]
    }

    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child0: AnyViewGraphNode<Child0>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child1: AnyViewGraphNode<Child1>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child2: AnyViewGraphNode<Child2>

    public init<Backend: AppBackend>(
        _ child0: Child0,
        _ child1: Child1,
        _ child2: Child2,
        backend: Backend
    ) {
        self.child0 = AnyViewGraphNode(for: child0, backend: backend)
        self.child1 = AnyViewGraphNode(for: child1, backend: backend)
        self.child2 = AnyViewGraphNode(for: child2, backend: backend)
    }
}

public struct ViewGraphNodeChildren4<Child0: View, Child1: View, Child2: View, Child3: View>: ViewGraphNodeChildren {
    public var widgets: [AnyWidget] {
        return [
            child0.widget,
            child1.widget,
            child2.widget,
            child3.widget,
        ]
    }

    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child0: AnyViewGraphNode<Child0>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child1: AnyViewGraphNode<Child1>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child2: AnyViewGraphNode<Child2>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child3: AnyViewGraphNode<Child3>

    public init<Backend: AppBackend>(
        _ child0: Child0,
        _ child1: Child1,
        _ child2: Child2,
        _ child3: Child3,
        backend: Backend
    ) {
        self.child0 = AnyViewGraphNode(for: child0, backend: backend)
        self.child1 = AnyViewGraphNode(for: child1, backend: backend)
        self.child2 = AnyViewGraphNode(for: child2, backend: backend)
        self.child3 = AnyViewGraphNode(for: child3, backend: backend)
    }
}

public struct ViewGraphNodeChildren5<Child0: View, Child1: View, Child2: View, Child3: View, Child4: View>: ViewGraphNodeChildren {
    public var widgets: [AnyWidget] {
        return [
            child0.widget,
            child1.widget,
            child2.widget,
            child3.widget,
            child4.widget,
        ]
    }

    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child0: AnyViewGraphNode<Child0>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child1: AnyViewGraphNode<Child1>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child2: AnyViewGraphNode<Child2>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child3: AnyViewGraphNode<Child3>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child4: AnyViewGraphNode<Child4>

    public init<Backend: AppBackend>(
        _ child0: Child0,
        _ child1: Child1,
        _ child2: Child2,
        _ child3: Child3,
        _ child4: Child4,
        backend: Backend
    ) {
        self.child0 = AnyViewGraphNode(for: child0, backend: backend)
        self.child1 = AnyViewGraphNode(for: child1, backend: backend)
        self.child2 = AnyViewGraphNode(for: child2, backend: backend)
        self.child3 = AnyViewGraphNode(for: child3, backend: backend)
        self.child4 = AnyViewGraphNode(for: child4, backend: backend)
    }
}

public struct ViewGraphNodeChildren6<Child0: View, Child1: View, Child2: View, Child3: View, Child4: View, Child5: View>: ViewGraphNodeChildren {
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

    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child0: AnyViewGraphNode<Child0>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child1: AnyViewGraphNode<Child1>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child2: AnyViewGraphNode<Child2>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child3: AnyViewGraphNode<Child3>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child4: AnyViewGraphNode<Child4>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child5: AnyViewGraphNode<Child5>

    public init<Backend: AppBackend>(
        _ child0: Child0,
        _ child1: Child1,
        _ child2: Child2,
        _ child3: Child3,
        _ child4: Child4,
        _ child5: Child5,
        backend: Backend
    ) {
        self.child0 = AnyViewGraphNode(for: child0, backend: backend)
        self.child1 = AnyViewGraphNode(for: child1, backend: backend)
        self.child2 = AnyViewGraphNode(for: child2, backend: backend)
        self.child3 = AnyViewGraphNode(for: child3, backend: backend)
        self.child4 = AnyViewGraphNode(for: child4, backend: backend)
        self.child5 = AnyViewGraphNode(for: child5, backend: backend)
    }
}

public struct ViewGraphNodeChildren7<Child0: View, Child1: View, Child2: View, Child3: View, Child4: View, Child5: View, Child6: View>: ViewGraphNodeChildren {
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

    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child0: AnyViewGraphNode<Child0>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child1: AnyViewGraphNode<Child1>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child2: AnyViewGraphNode<Child2>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child3: AnyViewGraphNode<Child3>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child4: AnyViewGraphNode<Child4>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child5: AnyViewGraphNode<Child5>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child6: AnyViewGraphNode<Child6>

    public init<Backend: AppBackend>(
        _ child0: Child0,
        _ child1: Child1,
        _ child2: Child2,
        _ child3: Child3,
        _ child4: Child4,
        _ child5: Child5,
        _ child6: Child6,
        backend: Backend
    ) {
        self.child0 = AnyViewGraphNode(for: child0, backend: backend)
        self.child1 = AnyViewGraphNode(for: child1, backend: backend)
        self.child2 = AnyViewGraphNode(for: child2, backend: backend)
        self.child3 = AnyViewGraphNode(for: child3, backend: backend)
        self.child4 = AnyViewGraphNode(for: child4, backend: backend)
        self.child5 = AnyViewGraphNode(for: child5, backend: backend)
        self.child6 = AnyViewGraphNode(for: child6, backend: backend)
    }
}

public struct ViewGraphNodeChildren8<Child0: View, Child1: View, Child2: View, Child3: View, Child4: View, Child5: View, Child6: View, Child7: View>: ViewGraphNodeChildren {
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

    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child0: AnyViewGraphNode<Child0>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child1: AnyViewGraphNode<Child1>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child2: AnyViewGraphNode<Child2>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child3: AnyViewGraphNode<Child3>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child4: AnyViewGraphNode<Child4>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child5: AnyViewGraphNode<Child5>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child6: AnyViewGraphNode<Child6>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child7: AnyViewGraphNode<Child7>

    public init<Backend: AppBackend>(
        _ child0: Child0,
        _ child1: Child1,
        _ child2: Child2,
        _ child3: Child3,
        _ child4: Child4,
        _ child5: Child5,
        _ child6: Child6,
        _ child7: Child7,
        backend: Backend
    ) {
        self.child0 = AnyViewGraphNode(for: child0, backend: backend)
        self.child1 = AnyViewGraphNode(for: child1, backend: backend)
        self.child2 = AnyViewGraphNode(for: child2, backend: backend)
        self.child3 = AnyViewGraphNode(for: child3, backend: backend)
        self.child4 = AnyViewGraphNode(for: child4, backend: backend)
        self.child5 = AnyViewGraphNode(for: child5, backend: backend)
        self.child6 = AnyViewGraphNode(for: child6, backend: backend)
        self.child7 = AnyViewGraphNode(for: child7, backend: backend)
    }
}

public struct ViewGraphNodeChildren9<Child0: View, Child1: View, Child2: View, Child3: View, Child4: View, Child5: View, Child6: View, Child7: View, Child8: View>: ViewGraphNodeChildren {
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

    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child0: AnyViewGraphNode<Child0>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child1: AnyViewGraphNode<Child1>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child2: AnyViewGraphNode<Child2>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child3: AnyViewGraphNode<Child3>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child4: AnyViewGraphNode<Child4>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child5: AnyViewGraphNode<Child5>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child6: AnyViewGraphNode<Child6>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child7: AnyViewGraphNode<Child7>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child8: AnyViewGraphNode<Child8>

    public init<Backend: AppBackend>(
        _ child0: Child0,
        _ child1: Child1,
        _ child2: Child2,
        _ child3: Child3,
        _ child4: Child4,
        _ child5: Child5,
        _ child6: Child6,
        _ child7: Child7,
        _ child8: Child8,
        backend: Backend
    ) {
        self.child0 = AnyViewGraphNode(for: child0, backend: backend)
        self.child1 = AnyViewGraphNode(for: child1, backend: backend)
        self.child2 = AnyViewGraphNode(for: child2, backend: backend)
        self.child3 = AnyViewGraphNode(for: child3, backend: backend)
        self.child4 = AnyViewGraphNode(for: child4, backend: backend)
        self.child5 = AnyViewGraphNode(for: child5, backend: backend)
        self.child6 = AnyViewGraphNode(for: child6, backend: backend)
        self.child7 = AnyViewGraphNode(for: child7, backend: backend)
        self.child8 = AnyViewGraphNode(for: child8, backend: backend)
    }
}

public struct ViewGraphNodeChildren10<Child0: View, Child1: View, Child2: View, Child3: View, Child4: View, Child5: View, Child6: View, Child7: View, Child8: View, Child9: View>: ViewGraphNodeChildren {
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

    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child0: AnyViewGraphNode<Child0>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child1: AnyViewGraphNode<Child1>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child2: AnyViewGraphNode<Child2>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child3: AnyViewGraphNode<Child3>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child4: AnyViewGraphNode<Child4>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child5: AnyViewGraphNode<Child5>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child6: AnyViewGraphNode<Child6>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child7: AnyViewGraphNode<Child7>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child8: AnyViewGraphNode<Child8>
    /// ``AnyViewGraphNode`` is used instead of ``ViewGraphNode`` because otherwise the backend leaks into views.
    public var child9: AnyViewGraphNode<Child9>

    public init<Backend: AppBackend>(
        _ child0: Child0,
        _ child1: Child1,
        _ child2: Child2,
        _ child3: Child3,
        _ child4: Child4,
        _ child5: Child5,
        _ child6: Child6,
        _ child7: Child7,
        _ child8: Child8,
        _ child9: Child9,
        backend: Backend
    ) {
        self.child0 = AnyViewGraphNode(for: child0, backend: backend)
        self.child1 = AnyViewGraphNode(for: child1, backend: backend)
        self.child2 = AnyViewGraphNode(for: child2, backend: backend)
        self.child3 = AnyViewGraphNode(for: child3, backend: backend)
        self.child4 = AnyViewGraphNode(for: child4, backend: backend)
        self.child5 = AnyViewGraphNode(for: child5, backend: backend)
        self.child6 = AnyViewGraphNode(for: child6, backend: backend)
        self.child7 = AnyViewGraphNode(for: child7, backend: backend)
        self.child8 = AnyViewGraphNode(for: child8, backend: backend)
        self.child9 = AnyViewGraphNode(for: child9, backend: backend)
    }
}
