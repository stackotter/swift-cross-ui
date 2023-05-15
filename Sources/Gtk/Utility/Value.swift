//
//  Copyright © 2016 Tomas Linhart. All rights reserved.
//

import CGtk

// This is from GLib and one day could be moved to GLib binding. It also not very perfect because
// original GValue heavily depends on macros that are not available in Swift. It might be best to
// introduce Object superclass and define these methods on it.

func getProperty(_ pointer: UnsafeMutablePointer<GObject>?, name: String) -> Bool {
    var v = GValue()
    let type = GType(5 << G_TYPE_FUNDAMENTAL_SHIFT)
    let value = g_value_init(&v, type)
    g_object_get_property(UnsafeMutablePointer(pointer), name, value)
    return g_value_get_boolean(value).toBool()
}

func setProperty(_ pointer: UnsafeMutablePointer<GObject>?, name: String, newValue: Bool) {
    var v = GValue()
    let type = GType(5 << G_TYPE_FUNDAMENTAL_SHIFT)
    let value = g_value_init(&v, type)
    g_value_set_boolean(value, newValue.toGBoolean())
    g_object_set_property(UnsafeMutablePointer(pointer), name, value)
}

func getProperty(_ pointer: UnsafeMutablePointer<GObject>?, name: String) -> Int {
    var v = GValue()
    let type = GType(6 << G_TYPE_FUNDAMENTAL_SHIFT)
    let value = g_value_init(&v, type)
    g_object_get_property(UnsafeMutablePointer(pointer), name, value)
    return Int(g_value_get_int(value))
}

func setProperty(_ pointer: UnsafeMutablePointer<GObject>?, name: String, newValue: Int) {
    var v = GValue()
    let type = GType(6 << G_TYPE_FUNDAMENTAL_SHIFT)
    let value = g_value_init(&v, type)
    g_value_set_int(value, gint(newValue))
    g_object_set_property(UnsafeMutablePointer(pointer), name, value)
}
