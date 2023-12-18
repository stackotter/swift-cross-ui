import CGtk

public protocol GValueRepresentableEnum: GValueRepresentable {
    associatedtype GtkEnum: RawRepresentable
    init(from gtkEnum: GtkEnum)
    func toGtk() -> GtkEnum
}

extension GValueRepresentableEnum {
    public static var type: GType {
        GType(12 << G_TYPE_FUNDAMENTAL_SHIFT)
    }
}

extension GValueRepresentableEnum where GtkEnum.RawValue == Int32 {
    public init(_ pointer: UnsafeMutablePointer<GValue>) {
        self.init(from: GtkEnum(rawValue: g_value_get_enum(pointer))!)
    }

    public func apply(to pointer: UnsafeMutablePointer<GValue>) {
        g_value_set_enum(pointer, toGtk().rawValue)
    }
}

extension GValueRepresentableEnum where GtkEnum.RawValue == UInt32 {
    public init(_ pointer: UnsafeMutablePointer<GValue>) {
        self.init(from: GtkEnum(rawValue: UInt32(g_value_get_enum(pointer)))!)
    }

    public func apply(to pointer: UnsafeMutablePointer<GValue>) {
        g_value_set_enum(pointer, Int32(toGtk().rawValue))
    }
}
