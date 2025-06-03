import DefaultBackend
import SwiftCrossUI

#if canImport(SwiftBundlerRuntime)
    import SwiftBundlerRuntime
#endif

@main
@HotReloadable
struct SimpleGridApp: App {
    let rowColors: [Color] = [Color.red, Color.green, Color.blue]
    let columnColors: [Color] = [Color.yellow, Color.orange, Color.purple]
    var body: some Scene {
        WindowGroup("SimpleGridExample") {
            Grid(horizontalSpacing: 30, verticalSpacing: 30) {
                ForEach(0..<rowColors.count) { row in
                    GridRow {
                        ForEach(0..<columnColors.count) { column in
                            Text("(Column: \(column), Row: \(row))")
                                .font(.system(size: 24))
                                .background(rowColors[column])
                        }
                    }
                    .foregroundColor(columnColors[row])
                }
            }
        }
        .defaultSize(width: 800, height: 500)
    }
}
