#if canImport(GtkBackend)
    import GtkBackend
    public typealias SelectedBackend = GtkBackend
#elseif canImport(QtBackend)
    import QtBackend
    public typealias SelectedBackend = QtBackend
#elseif canImport(AppKitBackend)
    import AppKitBackend
    public typealias SelectedBackend = AppKitBackend
#elseif canImport(CursesBackend)
    import CursesBackend
    public typealias SelectedBackend = CursesBackend
#elseif canImport(LVGLBackend)
    import LVGLBackend
    public typealias SelectedBackend = LVGLBackend
#elseif canImport(WinUIBackend)
    import WinUIBackend
    public typealias SelectedBackend = WinUIBackend
#else
    #error("Unknown backend selected")
#endif
