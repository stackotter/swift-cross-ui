import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct HotReloadingMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        HotReloadableAppMacro.self,
        HotReloadableExprMacro.self,
    ]
}
