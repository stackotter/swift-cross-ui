//
//  Copyright © 2015 Tomas Linhart. All rights reserved.
//

import CGtk

public class Application {
    let applicationPointer: UnsafeMutablePointer<GtkApplication>
    private(set) var applicationWindow: ApplicationWindow?
    private var windowCallback: ((ApplicationWindow) -> Void)?

    public init(applicationId: String) {
        // Ignore the deprecation warning, making the change breaks support for platforms such as
        // Ubuntu (before Lunar). This is due to Ubuntu coming with an older version of Gtk in apt.
        #if GTK_4_10_PLUS
        applicationPointer = gtk_application_new(applicationId, G_APPLICATION_DEFAULT_FLAGS)
        #else
        applicationPointer = gtk_application_new(applicationId, G_APPLICATION_FLAGS_NONE)
        #endif
    }

    @discardableResult
    public func run(_ windowCallback: @escaping (ApplicationWindow) -> Void) -> Int {
        self.windowCallback = windowCallback

        let handler:
            @convention(c) (
                UnsafeMutableRawPointer,
                UnsafeMutableRawPointer
            ) -> Void = { _, data in
                let app = unsafeBitCast(data, to: Application.self)
                app.activate()
            }

        connectSignal(
            applicationPointer,
            name: "activate",
            data: Unmanaged.passUnretained(self).toOpaque(),
            handler: unsafeBitCast(handler, to: GCallback.self)
        )
        let status = g_application_run(applicationPointer.cast(), 0, nil)
        g_object_unref(applicationPointer)
        return Int(status)
    }

    private func activate() {
        let window = ApplicationWindow(application: self)
        windowCallback?(window)
        self.applicationWindow = window
    }
}
