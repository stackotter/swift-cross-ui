import CGtk3

public class GFile: GObject {
    public var path: String {
        return String(cString: g_file_get_path(opaquePointer))
    }
}
