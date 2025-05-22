/// An object that can be observed for changes.
///
/// The default implementation only publishes changes made to properties that
/// have been wrapped with the ``Published`` property wrapper. Even properties
/// that themselves conform to ``ObservableObject`` must be wrapped with the
/// ``Published`` property wrapper for clarity.
///
/// ```swift
/// class NestedState: ObservableObject {
///     // Both `startIndex` and `endIndex` will have their changes published to `NestedState`'s
///     // `didChange` publisher.
///     @Published
///     var startIndex = 0
///
///     @Published
///     var endIndex = 0
/// }
///
/// class CounterState: ObservableObject {
///     // Only changes to `count` will be published (it is the only property with `@Published`)
///     @Published
///     var count = 0
///
///     var otherCount = 0
///
///     // Even though `nested` is `ObservableObject`, its changes won't be
///     // published because if you could have observed properties without
///     // `@Published` things would get pretty messy and you'd always have to
///     // check the definition of the type of each property to know exactly
///     // what would and wouldn't cause updates.
///     var nested = NestedState()
/// }
/// ```
public protocol ObservableObject: AnyObject {
    /// A publisher which publishes changes made to the object. Only publishes changes made to
    /// ``Published`` properties by default.
    var didChange: Publisher { get }
}

extension ObservableObject {
    public var didChange: Publisher {
        let publisher = Publisher()
            .tag(with: String(describing: type(of: self)))

        var mirror: Mirror? = Mirror(reflecting: self)
        while let aClass = mirror {
            for (_, property) in aClass.children {
                guard
                    property is PublishedMarkerProtocol,
                    let property = property as? ObservableObject
                else {
                    continue
                }

                _ = publisher.link(toUpstream: property.didChange)
            }
            mirror = aClass.superclassMirror
        }
        return publisher
    }
}

protocol OptionalObservableObject {
    var didChange: Publisher? { get }
}

extension Optional: OptionalObservableObject where Wrapped: ObservableObject {
    var didChange: SwiftCrossUI.Publisher? {
        switch self {
            case .some(let object):
                object.didChange
            case .none:
                nil
        }
    }
}

@available(*, deprecated, message: "Replace Observable with ObservableObject")
public typealias Observable = ObservableObject
