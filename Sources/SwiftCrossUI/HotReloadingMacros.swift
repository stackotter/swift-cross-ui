import Foundation

@attached(
    peer,
    names: named(hotReloadingExportedEntryPoint),
    named(hotReloadingImportedEntryPoint),
    named(hotReloadingHasConnectedToServer))
@attached(member, names: named(entryPoint), named(hotReloadingExprIds))
public macro HotReloadable() =
    #externalMacro(module: "HotReloadingMacrosPlugin", type: "HotReloadableAppMacro")

@freestanding(expression)
public macro hotReloadable<T>(_ expr: T) -> HotReloadableView =
    #externalMacro(module: "HotReloadingMacrosPlugin", type: "HotReloadableExprMacro")

public struct ExprLocation: Hashable {
    var line: Int
    var column: Int

    public init(line: Int, column: Int) {
        self.line = line
        self.column = column
    }
}
