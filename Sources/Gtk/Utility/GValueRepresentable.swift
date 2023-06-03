//
//  Copyright © 2016 Tomas Linhart. All rights reserved.
//

import CGtk

/// Implement to support @GObjectProperty wrapper
public protocol GValueRepresentable {
    static var type: GType { get }
    init(_ pointer: UnsafeMutablePointer<GValue>)
    func apply(to pointer: UnsafeMutablePointer<GValue>)
}

// MARK: - GValueRepresentable Implementations

extension Int: GValueRepresentable {}
extension Int32: GValueRepresentable {}

extension GValueRepresentable where Self: BinaryInteger {
    public static var type: GType {
        GType(6 << G_TYPE_FUNDAMENTAL_SHIFT)
    }

    public init(_ pointer: UnsafeMutablePointer<GValue>) {
        self.init(g_value_get_int(pointer))
    }

    public func apply(to pointer: UnsafeMutablePointer<GValue>) {
        g_value_set_int(pointer, gint(self))
    }
}

extension Bool: GValueRepresentable {
    public static var type: GType {
        GType(5 << G_TYPE_FUNDAMENTAL_SHIFT)
    }

    public init(_ pointer: UnsafeMutablePointer<GValue>) {
        self.init(g_value_get_boolean(pointer).toBool())
    }

    public func apply(to pointer: UnsafeMutablePointer<GValue>) {
        g_value_set_boolean(pointer, self.toGBoolean())
    }
}

extension Double: GValueRepresentable {
    public static var type: GType {
        GType(15 << G_TYPE_FUNDAMENTAL_SHIFT)
    }

    public init(_ pointer: UnsafeMutablePointer<GValue>) {
        self.init(g_value_get_double(pointer))
    }

    public func apply(to pointer: UnsafeMutablePointer<GValue>) {
        g_value_set_double(pointer, gdouble(self))
    }
}

extension String: GValueRepresentable {
    public static var type: GType {
        GType(16 << G_TYPE_FUNDAMENTAL_SHIFT)
    }

    public init(_ pointer: UnsafeMutablePointer<GValue>) {
        self.init(g_value_get_string(pointer).toString())
    }

    public func apply(to pointer: UnsafeMutablePointer<GValue>) {
        withCString {
            g_value_set_string(pointer, $0)
        }
    }
}
