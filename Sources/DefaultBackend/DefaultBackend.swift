#if canImport(AppKitBackend)
    import AppKitBackend
    public typealias DefaultBackend = AppKitBackend
#elseif canImport(GtkBackend)
    import GtkBackend
    public typealias DefaultBackend = GtkBackend
#elseif canImport(QtBackend)
    import QtBackend
    public typealias DefaultBackend = QtBackend
#elseif canImport(WinUIBackend)
    import WinUIBackend
    public typealias DefaultBackend = WinUIBackend
#elseif canImport(CursesBackend)
    import CursesBackend
    public typealias DefaultBackend = CursesBackend
#elseif canImport(LVGLBackend)
    import LVGLBackend
    public typealias DefaultBackend = LVGLBackend
#else
    #error("Unknown backend selected")
#endif
