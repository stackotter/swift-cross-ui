//
//  Copyright © 2016 Tomas Linhart. All rights reserved.
//

import CGtk

@propertyWrapper public struct GObjectProperty<Value: GValueRepresentable> {
    @available(*, unavailable)
    public var wrappedValue: Value {
        get { fatalError("This wrapper only works on instance properties of GObjectRepresentable") }
        set { fatalError("This wrapper only works on instance properties of GObjectRepresentable") }
    }

    var name: String

    public init(named: String) {
        self.name = named
    }

    public static subscript<EnclosingSelf: GObjectRepresentable>(
        _enclosingInstance instance: EnclosingSelf,
        wrapped _: ReferenceWritableKeyPath<EnclosingSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Self>
    ) -> Value {
        get { instance.getProperty(name: instance[keyPath: storageKeyPath].name) }
        set { instance.setProperty(name: instance[keyPath: storageKeyPath].name, newValue: newValue) }
    }
}
