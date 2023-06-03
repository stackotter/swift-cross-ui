//
//  Copyright © 2016 Tomas Linhart. All rights reserved.
//

import CGtk

public protocol GObjectRepresentable {
    var gobjectPointer: UnsafeMutablePointer<GObject> { get }
}

extension GObjectRepresentable {
    public func setProperty<V: GValueRepresentable>(name: String, newValue: V) {
        var v = GValue()
        let value = g_value_init(&v, V.type)!
        newValue.apply(to: value)
        g_object_set_property(gobjectPointer, name, value)
    }

    public func getProperty<V: GValueRepresentable>(name: String) -> V {
        var v = GValue()
        let value = g_value_init(&v, V.type)!
        g_object_get_property(gobjectPointer, name, value)
        return V(value)
    }
}
