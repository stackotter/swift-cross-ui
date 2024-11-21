import CGtk3

public protocol GValueRepresentableEnum: GValueRepresentable {
    associatedtype GtkEnum: RawRepresentable

    /// Converts a Gtk value to its corresponding swift representation.
    init(from gtkEnum: GtkEnum)

    /// Converts the value to its corresponding Gtk representation.
    func toGtk() -> GtkEnum
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
