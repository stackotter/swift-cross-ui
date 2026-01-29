import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SCUIMacrosPlugin: CompilerPlugin {
    let providingMacros: [any Macro.Type] = [
        ObservableMacro.self, ObservationIgnoredMacro.self,
    ]
}
