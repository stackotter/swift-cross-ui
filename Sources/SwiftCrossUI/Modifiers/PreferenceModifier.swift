extension View {
    public func preference<V>(key: WritableKeyPath<PreferenceValues, V>, value: V) -> some View {
        PreferenceModifier(self) { preferences in
            var preferences = preferences
            preferences[keyPath: key] = value
            return preferences
        }
    }
}

struct PreferenceModifier<Child: View>: View {
    var body: TupleView1<Child>
    var modification: (PreferenceValues) -> PreferenceValues

    init(
        _ child: Child,
        modification: @escaping (PreferenceValues) -> PreferenceValues
    ) {
        self.body = TupleView1(child)
        self.modification = modification
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        children: any ViewGraphNodeChildren,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        var result = defaultUpdate(
            widget,
            children: children,
            proposedSize: proposedSize,
            environment: environment,
            backend: backend,
            dryRun: dryRun
        )
        result.preferences = modification(result.preferences)
        return result
    }
}
