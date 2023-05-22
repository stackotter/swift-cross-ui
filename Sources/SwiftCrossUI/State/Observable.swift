import Foundation

/// An object that can be observed for changes.
///
/// The default implementation only publishes changes made to properties that have been wrapped with
/// the ``Observed`` property wrapper. Even properties that themselves conform to ``Observable``
/// must be wrapped with the ``Observed`` property wrapper for clarity.
///
/// ```swift
/// class NestedState: Observable {
///     // Both `startIndex` and `endIndex` will have their changes published to `NestedState`'s
///     // `didChange` publisher.
///     @Observed
///     var startIndex = 0
///
///     @Observed
///     var endIndex = 0
/// }
///
/// class CounterState: Observable {
///     // Only changes to `count` will be published (it is the only property with `@Observed`)
///     @Observed
///     var count = 0
///
///     var otherCount = 0
///
///     // Even though `nested` is `Observable`, its changes won't be published because without
///     // `@Observed`, the behaviour is unclear without looking at the definition of `NestedState`
///     var nested = NestedState()
/// }
/// ```
public protocol Observable: AnyObject {
    /// A publisher which publishes changes made to the object. Only publishes changes made to
    /// ``Observed`` properties by default.
    var didChange: Publisher { get }
}

extension Observable {
    public var didChange: Publisher {
        let publisher = Publisher()
        guard type(of: self) != EmptyState.self else {
            return publisher
        }

        var mirror: Mirror? = Mirror(reflecting: self)
        while let aClass = mirror {
            for (_, property) in aClass.children {
                guard
                    property is ObservedMarkerProtocol,
                    let property = property as? Observable
                else {
                    continue
                }

                _ = publisher.link(toDownstream: property.didChange)
            }
            mirror = aClass.superclassMirror
        }
        return publisher
    }
}
