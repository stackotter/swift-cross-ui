import MacroToolkit
import SwiftSyntax
import SwiftSyntaxMacros

public struct HotReloadableExprMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard let expr = destructureSingle(node.arguments), expr.label == nil else {
            throw MacroError("#hotReloadable takes exactly one unlabelled argument")
        }

        #if HOT_RELOADING_ENABLED
            guard let location = context.location(of: expr) else {
                throw MacroError(
                    "#hotReloadable expr without source location?? (shouldn't be possible)")
            }
            // TODO: Guard against use of `#hotReloadable` in situations where `self` doesn't refer
            //   to the root App type of the user's application.
            return
                """
                {
                    let location = ExprLocation(line: \(location.line), column: \(location.column))
                    let viewId = Self.hotReloadingExprIds[location]!
                    if let hotReloadingImportedEntryPoint {
                        return withUnsafePointer(to: self) { pointer in
                            return hotReloadingImportedEntryPoint(
                                pointer,
                                viewId
                            ) as! SwiftCrossUI.HotReloadableView
                        }
                    } else {
                        return self.entryPoint(viewId: viewId)
                    }
                }()
                """
        #else
            return "SwiftCrossUI.HotReloadableView(\(expr))"
        #endif
    }
}
