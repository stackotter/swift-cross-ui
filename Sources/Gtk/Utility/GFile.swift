import CGtk
import Foundation

public class GFile: GObject {
    public var path: String {
        String(cString: g_file_get_path(opaquePointer))
    }

    public var uri: URL {
        URL(string: String(cString: g_file_get_uri(opaquePointer)))!
    }
}
