import CGtk

public class GFile: GObject {
    public var path: String {
        String(cString: g_file_get_path(opaquePointer))
    }
}
