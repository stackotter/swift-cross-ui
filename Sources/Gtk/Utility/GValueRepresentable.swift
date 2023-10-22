import CGtk

/// Implement to support @GObjectProperty wrapper
public protocol GValueRepresentable {
    static var type: GType { get }
    init?(_ pointer: UnsafeMutablePointer<GValue>)
    func apply(to pointer: UnsafeMutablePointer<GValue>)
}

// TODO: Implement property wrapper to convert all integer types to int without losing
//   information about the underlying specific integer type
extension Int: GValueRepresentable {
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

extension UInt: GValueRepresentable {
    public static var type: GType {
        GType(6 << G_TYPE_FUNDAMENTAL_SHIFT)
    }

    public init(_ pointer: UnsafeMutablePointer<GValue>) {
        self.init(g_value_get_uint(pointer))
    }

    public func apply(to pointer: UnsafeMutablePointer<GValue>) {
        g_value_set_uint(pointer, guint(self))
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

    public init?(_ pointer: UnsafeMutablePointer<GValue>) {
        self.init(g_value_get_double(pointer))
    }

    public func apply(to pointer: UnsafeMutablePointer<GValue>) {
        g_value_set_double(pointer, gdouble(self))
    }
}

extension Float: GValueRepresentable {
    public static var type: GType {
        GType(14 << G_TYPE_FUNDAMENTAL_SHIFT)
    }

    public init?(_ pointer: UnsafeMutablePointer<GValue>) {
        self.init(g_value_get_float(pointer))
    }

    public func apply(to pointer: UnsafeMutablePointer<GValue>) {
        g_value_set_float(pointer, gfloat(self))
    }
}

extension String: GValueRepresentable {
    public static var type: GType {
        GType(16 << G_TYPE_FUNDAMENTAL_SHIFT)
    }

    public init?(_ pointer: UnsafeMutablePointer<GValue>) {
        guard let cString = g_value_get_string(pointer) else { return nil }
        self.init(cString: cString)
    }

    public func apply(to pointer: UnsafeMutablePointer<GValue>) {
        g_value_set_string(pointer, self)
    }
}

extension OpaquePointer: GValueRepresentable {
    public static var type: GType {
        GType(20 << G_TYPE_FUNDAMENTAL_SHIFT)
    }

    public init?(_ pointer: UnsafeMutablePointer<GValue>) {
        guard let object = g_value_get_object(pointer) else { return nil }
        self = OpaquePointer(object)
    }

    public func apply(to pointer: UnsafeMutablePointer<GValue>) {
        g_value_set_object(pointer, gpointer(self))
    }
}

extension Optional: GValueRepresentable where Wrapped: GValueRepresentable {
    public static var type: GType {
        Wrapped.type
    }

    public init?(_ pointer: UnsafeMutablePointer<GValue>) {
        if let wrapped = Wrapped(pointer) {
            self = .some(wrapped)
        } else {
            self = nil
        }
    }

    public func apply(to pointer: UnsafeMutablePointer<GValue>) {
        if let unwrapped = self {
            unwrapped.apply(to: pointer)
        }
    }
}
