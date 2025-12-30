/// A property wrapper updated by the view graph before each access to
/// ``View/body``.
///
/// Conforming types should use internal mutability (see ``Box``) to implement
/// this protocol's non-mutable methods if required. This protocol avoids
/// mutation to allow state properties and such to be captured even though views
/// are structs.
public protocol DynamicProperty {
    /// Updates the property.
    ///
    /// Called by SwiftCrossUI before every access it makes to an ``App/body``
    /// or ``View/body``.
    ///
    /// - Parameters:
    ///   - environment: The current environment.
    ///   - previousValue: The previous value of the property. `nil` if this is
    ///     the first time an update has been made.
    func update(
        with environment: EnvironmentValues,
        previousValue: Self?
    )
}

/// Updates the dynamic properties of a value given a previous instance of the
/// type (if one exists) and the current environment.
///
/// - Parameters:
///   - value: The value to update the dynamic properties of.
///   - previousValue: The previous value of `value`.  `nil` if this is the
///     first time an update has been made.
///   - environment: The current environment.
func updateDynamicProperties<T>(
    of value: T,
    previousValue: T?,
    environment: EnvironmentValues
) {
    let newMirror = Mirror(reflecting: value)
    let previousMirror = previousValue.map(Mirror.init(reflecting:))
    if let previousChildren = previousMirror?.children {
        let propertySequence = zip(newMirror.children, previousChildren)
        for (newProperty, previousProperty) in propertySequence {
            guard
                let newValue = newProperty.value as? any DynamicProperty,
                let previousValue = previousProperty.value as? any DynamicProperty
            else {
                continue
            }

            updateDynamicProperty(
                newProperty: newValue,
                previousProperty: previousValue,
                environment: environment,
                enclosingTypeName: "\(T.self)",
                propertyName: newProperty.label
            )
        }
    } else {
        for property in newMirror.children {
            guard let newValue = property.value as? any DynamicProperty else {
                continue
            }

            updateDynamicProperty(
                newProperty: newValue,
                previousProperty: nil,
                environment: environment,
                enclosingTypeName: "\(T.self)",
                propertyName: property.label
            )
        }
    }
}

/// Updates a dynamic property.
///
/// Required to unmask the concrete type of the property. Since the two
/// properties can technically be two different types, Swift correctly wouldn't
/// allow us to assume they're both the same. So we unwrap one and then
/// dynamically check whether the other matches using a type cast.
///
/// - Parameters:
///   - newProperty: The new property.
///   - previousProperty: The previous property. `nil` if this is the first time
///     an update has been made.
///   - environment: The current environment.
///   - enclosingTypeName: The name of the type that contains the property. Used
///     for debugging.
///   - propertyName: The name of the property. Used for debugging.
private func updateDynamicProperty<Property: DynamicProperty>(
    newProperty: Property,
    previousProperty: (any DynamicProperty)?,
    environment: EnvironmentValues,
    enclosingTypeName: String,
    propertyName: String?
) {
    let castedPreviousProperty: Property?
    if let previousProperty {
        guard let previousProperty = previousProperty as? Property else {
            fatalError(
                """
                Supposedly unreachable... previous and current types of \
                \(enclosingTypeName).\(propertyName ?? "<unknown property>") \
                don't match.
                """
            )
        }

        castedPreviousProperty = previousProperty
    } else {
        castedPreviousProperty = nil
    }

    newProperty.update(
        with: environment,
        previousValue: castedPreviousProperty
    )
}
