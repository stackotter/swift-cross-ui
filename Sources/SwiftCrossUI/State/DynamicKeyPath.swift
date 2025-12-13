#if canImport(Darwin)
    import func Darwin.memcmp
#elseif canImport(Glibc)
    import func Glibc.memcmp
#elseif canImport(WinSDK)
    import func WinSDK.memcmp
#elseif canImport(Android)
    import func Android.memcmp
#endif

/// A type similar to KeyPath, but that can be constructed at run time given
/// an instance of a struct, and the value of the desired property. Construction
/// fails if the property's in-memory representation is not unique within the
/// struct. SwiftCrossUI only uses ``DynamicKeyPath`` in situations where it is
/// highly likely for properties to have unique in-memory representations, such
/// as when properties have internal storage pointers.
struct DynamicKeyPath<Base, Value> {
    /// The property's offset within instances of ``T``.
    var offset: Int

    /// Constructs a key path given an instance of the base type, and the
    /// value of the desired property. The initializer will search through
    /// the base instance's in-memory representation to find the unique offset
    /// that matches the representation of the given property value. If such an
    /// offset can't be found or isn't unique, then the initialiser returns `nil`.
    init?(
        forProperty value: Value,
        of base: Base,
        label: String? = nil
    ) {
        let propertyAlignment = MemoryLayout<Value>.alignment
        let propertySize = MemoryLayout<Value>.size
        let baseStructSize = MemoryLayout<Base>.size

        var index = 0
        var matches: [Int] = []
        while index + propertySize <= baseStructSize {
            let isMatch = withUnsafeBytes(of: base) { viewPointer in
                withUnsafeBytes(of: value) { valuePointer in
                    memcmp(
                        viewPointer.baseAddress!.advanced(by: index),
                        valuePointer.baseAddress!,
                        propertySize
                    )
                }
            } == 0
            if isMatch {
                matches.append(index)
            }
            index += propertyAlignment
        }

        guard let offset = matches.first else {
            print("Warning: No offset found for dynamic property '\(label ?? "<unknown>")'")
            return nil
        }

        guard matches.count == 1 else {
            print("Warning: Multiple offsets found for dynamic property '\(label ?? "<unknown>")'")
            return nil
        }

        self.offset = offset
    }

    /// Gets the property's value on the given instance.
    func get(_ base: Base) -> Value {
        withUnsafeBytes(of: base) { buffer in
            buffer.baseAddress!.advanced(by: offset)
                .assumingMemoryBound(to: Value.self)
                .pointee
        }
    }

    /// Sets the property's value to a new value on the given instance.
    func set(_ base: inout Base, _ newValue: Value) {
        withUnsafeMutableBytes(of: &base) { buffer in
            buffer.baseAddress!.advanced(by: offset)
                .assumingMemoryBound(to: Value.self)
                .pointee = newValue
        }
    }
}
