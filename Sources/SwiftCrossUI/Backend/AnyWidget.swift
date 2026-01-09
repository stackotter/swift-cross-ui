/// A type-erased widget which can be stored without having to propagate
/// the selected backend type through the type system of the whole view graph
/// system of types, which would leak it back into user view implementations
/// making the backend hard to switch for developers.
///
/// Uses the simplest kind of type erasure because we always know the
/// widget type at time of use anyway so it can simply be cast back to
/// a concrete type before use (removing the need to type-erase specific
/// methods or anything like that).
public class AnyWidget {
    /// The wrapped widget
    var widget: Any

    /// Erases the specific type of a widget (to allow storage without propagating
    /// the selected backend type through the whole type system).
    public init(_ widget: Any) {
        self.widget = widget
    }

    /// Converts the widget back to its original concrete type. If the requested
    /// type doesn't match its original type then the method will crash.
    public func concreteWidget<Backend: AppBackend>(
        for backend: Backend.Type
    ) -> Backend.Widget {
        guard let widget = widget as? Backend.Widget else {
            fatalError("AnyWidget used with incompatible backend \(backend); widget type is \(type(of: widget))")
        }
        return widget
    }

    /// Converts the widget back to its original concrete type. If the requested
    /// type doesn't match its original type then the method will crash. Often
    /// more concise than using ``AnyWidget/concreteWidget(for:)``.
    public func into<T>() -> T {
        guard let widget = widget as? T else {
            fatalError("AnyWidget used with incompatible widget type \(T.self); actual widget type is \(type(of: widget))")
        }
        return widget
    }
}
