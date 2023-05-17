import CGtk

public protocol Orientable: AnyObject {
    var opaquePointer: OpaquePointer? { get }
    var orientation: Orientation { get set }
}

extension Orientable {
    public var orientation: Orientation {
        get {
            gtk_orientable_get_orientation(opaquePointer).toOrientation()
        }
        set {
            gtk_orientable_set_orientation(opaquePointer, newValue.toGtkOrientation())
        }
    }
}