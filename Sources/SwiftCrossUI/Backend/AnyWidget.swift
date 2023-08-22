public class AnyWidget {
    var widget: Any

    public init(_ widget: Any) {
        self.widget = widget
    }

    public func concreteWidget<Backend: AppBackend>(
        for backend: Backend.Type
    ) -> Backend.Widget {
        guard let widget = widget as? Backend.Widget else {
            fatalError("AnyWidget used with incompatible backend \(backend)")
        }
        return widget
    }

    public func into<T>() -> T {
        guard let widget = widget as? T else {
            fatalError("AnyWidget used with incompatible widget type \(T.self)")
        }
        return widget
    }
}
