extension View {
    public func onChange<Value: Equatable>(
        of value: Value,
        initial: Bool = false,
        perform action: @escaping () -> Void
    ) -> some View {
        OnChangeModifier(
            body: TupleView1(self),
            value: value,
            action: action,
            initial: initial
        )
    }
}

class OnChangeModifierState<Value: Equatable>: Observable {
    var previousValue: Value?
}

struct OnChangeModifier<Value: Equatable, Content: View>: View {
    var state = OnChangeModifierState<Value>()

    var body: TupleView1<Content>

    var value: Value
    var action: () -> Void
    var initial: Bool

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        if let previousValue = state.previousValue, value != previousValue {
            action()
        } else if initial && state.previousValue == nil {
            action()
        }
        state.previousValue = value

        return defaultUpdate(
            widget,
            children: children,
            proposedSize: proposedSize,
            environment: environment,
            backend: backend,
            dryRun: dryRun
        )
    }
}
