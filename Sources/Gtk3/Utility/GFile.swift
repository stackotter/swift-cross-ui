import CGtk3
import Foundation

public class GFile: GObject {
    public var path: String {
        return String(cString: g_file_get_path(opaquePointer))
    }

    public var uri: URL {
        URL(string: String(cString: g_file_get_uri(opaquePointer)))!
    }
}
