#if canImport(GtkBackend)
    import GtkBackend
    public typealias SelectedBackend = GtkBackend
#elseif canImport(QtBackend)
    import QtBackend
    public typealias SelectedBackend = QtBackend
#elseif canImport(CursesBackend)
    import CursesBackend
    public typealias SelectedBackend = CursesBackend
#elseif canImport(AppKitBackend)
    import AppKitBackend
    public typealias SelectedBackend = AppKitBackend
#elseif canImport(LVGLBackend)
    import LVGLBackend
    public typealias SelectedBackend = LVGLBackend
#else
    #error("No known backend selected")
#endif
