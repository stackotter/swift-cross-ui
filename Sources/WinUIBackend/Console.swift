import WinSDK
import Foundation

extension WinUIBackend {
    /// Attaches the app's standard IO streams to the parent's console.
    ///
    /// This allows the stdout/stderr of SwiftCrossUI GUI apps to be
    /// viewed by starting them from the command line, even when they're
    /// built and linked as /SUBSYSTEM:WINDOWS apps (GUI apps). Without
    /// this fix the output of GUI apps is basically impossible to access.
    ///
    /// Adapted from: https://stackoverflow.com/a/55875595/8268001
    static func attachToParentConsole() throws {
        try Self.releaseConsole()
        // -1 attaches to parent's console
        if AttachConsole(DWORD(bitPattern: -1)) {
            try Self.adjustConsoleBuffer(1024)
            try Self.redirectConsoleIO()
        }
    }
    
    /// Releases existing files associated with the app's standard IO streams.
    private static func releaseConsole() throws {
        var fp = UnsafeMutablePointer<FILE>?.none
        guard
            freopen_s(&fp, "NUL:", "r", stdin) == 0,
            freopen_s(&fp, "NUL:", "w", stdout) == 0,
            freopen_s(&fp, "NUL:", "w", stdout) == 0,
            FreeConsole()
        else {
            throw Error(message: "Failed to release existing console")
        }
    }

    /// Redirect the application's standard IO streams to the current console.
    private static func redirectConsoleIO() throws {
        var fp = UnsafeMutablePointer<FILE>?.none
        guard
            freopen_s(&fp, "CONIN$", "r", stdin) == 0,
            freopen_s(&fp, "CONOUT$", "w", stdout) == 0,
            freopen_s(&fp, "CONOUT$", "w", stderr) == 0
        else {
            throw Error(message: "Failed to redirect console IO")
        }
    }

    /// Adjusts the size of the app's console output buffer.
    private static func adjustConsoleBuffer(_ minLength: SHORT) throws {
        let handle = GetStdHandle(STD_OUTPUT_HANDLE)
        var consoleInfo = CONSOLE_SCREEN_BUFFER_INFO();
        guard GetConsoleScreenBufferInfo(handle, &consoleInfo) else {
            throw Error(message: "Failed to get console screen buffer info")
        }
        if consoleInfo.dwSize.Y < minLength {
            consoleInfo.dwSize.Y = minLength
        }
        guard SetConsoleScreenBufferSize(handle, consoleInfo.dwSize) else {
            throw Error(message: "Failed to set console screen buffer size")
        }
    }
}
