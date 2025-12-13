/// A property wrapper updated by the view graph before each access to
/// ``View/body``. Conforming types should use internal mutability (see ``Box``)
/// to implement this protocol's non-mutable methods if required. This
/// protocol avoids mutation to allow state properties and such to be
/// captured even though views are structs.
public protocol DynamicProperty {
    /// Updates the property. Called by SwiftCrossUI before every access it
    /// makes to an ``App/body`` or ``View/body``.
    func update(
        with environment: EnvironmentValues,
        previousValue: Self?
    )
}
