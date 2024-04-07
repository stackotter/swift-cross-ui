import Foundation
import PackagePlugin

enum DependencyError: Error, CustomStringConvertible {
    case missingSystemDependency(String)

    var description: String {
        switch self {
            case .missingSystemDependency(let name):
                Diagnostics.error("Missing '\(name)' system dependency.")

                #if os(Windows)
                    return "No installation instructions for Windows."
                #else
                    let installationInstructions: String?
                    let packageManager: String
                    #if os(macOS)
                        packageManager = "brew"
                        switch name {
                            case "CGtk":
                                installationInstructions = "brew install gtk4"
                            case "Qt5Widgets":
                                installationInstructions = "brew install qt@5 && brew link qt@5"
                            default:
                                installationInstructions = nil
                        }
                    #elseif os(Linux)
                        packageManager = "apt"
                        switch name {
                            case "CGtk":
                                installationInstructions = "apt install libgtk-4-dev clang"
                            case "Qt5Widgets":
                                installationInstructions = "apt install qt5-default"
                            default:
                                installationInstructions = nil
                        }
                    #endif

                    let instructions =
                        installationInstructions
                        ?? "Missing installation instructions for '\(name)', please open an issue at https://github.com/stackotter/swift-cross-ui"
                    return "To install with \(packageManager): \(instructions)"
                #endif
        }
    }
}

@main
struct DependencyCheckingPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        if ProcessInfo.processInfo.environment["SWIFTCROSSUI_SKIP_DEP_CHECK"] == "1" {
            return []
        }

        #if os(Windows)
            Diagnostics.warning(
                "Dependency checking not implemented on Windows. Set SWIFTCROSSUI_SKIP_DEP_CHECK=1 to disable this warning"
            )
            return []
        #endif

        for dependency in target.recursiveTargetDependencies {
            try check(dependency)
        }

        return []
    }

    func check(_ target: Target) throws {
        // TODO: Add hardcoded checks for curses and lvgl
        if let systemDependency = target as? SystemLibraryTarget {
            guard let pkgConfigName = systemDependency.pkgConfig else {
                Diagnostics.warning(
                    "Dependency checking not implemented for system libraries without pkgConfig names, manually implement a check for '\(systemDependency.name)'"
                )
                return
            }

            try checkPkgConfig(pkgConfigName)
        }
    }

    func checkPkgConfig(_ name: String) throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = [
            "pkg-config",
            name,
        ]

        try process.run()
        process.waitUntilExit()

        if process.terminationStatus != 0 {
            throw DependencyError.missingSystemDependency(name)
        }
    }
}
