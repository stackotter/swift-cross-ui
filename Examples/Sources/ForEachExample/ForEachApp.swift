import DefaultBackend
import Foundation
import SwiftCrossUI

#if canImport(SwiftBundlerRuntime)
    import SwiftBundlerRuntime
#endif

@main
@HotReloadable
struct ForEachApp: App {
    @State var items = {
        var items = [Item]()
        for i in 0..<20 {
            items.append(.init("\(i)"))
        }
        return items
    }()
    @State var biggestValue = 19
    @State var insertionPosition = 10

    var body: some Scene {
        WindowGroup("ForEach") {
            #hotReloadable {
                ScrollView {
                    VStack {
                        Text("Items")

                        Button("Append") {
                            biggestValue += 1
                            items.append(.init("\(biggestValue)"))
                        }

                        Button("Insert in front of current item at position \(insertionPosition)") {
                            biggestValue += 1
                            items.insert(.init("\(biggestValue)"), at: insertionPosition)
                        }
                        Slider($insertionPosition, minimum: 0, maximum: items.count - 1)
                            .onChange(of: items.count) {
                                guard insertionPosition > items.count - 1 else {
                                    return
                                }
                                insertionPosition = max(items.count - 1, 0)
                            }

                        ForEach(items) { item in
                            ItemRow(
                                item: item, isFirst: Optional(item.id) == items.first?.id,
                                isLast: Optional(item.id) == items.last?.id
                            ) {
                                items.removeAll(where: { $0.id == item.id })
                            } moveUp: {
                                guard
                                    let ownIndex = items.firstIndex(where: { $0.id == item.id }),
                                    ownIndex != items.startIndex
                                else { return }
                                items.swapAt(ownIndex, ownIndex - 1)
                            } moveDown: {
                                guard
                                    let ownIndex = items.firstIndex(where: { $0.id == item.id }),
                                    ownIndex != items.endIndex
                                else { return }
                                items.swapAt(ownIndex, ownIndex + 1)
                            }
                        }
                    }
                    .padding(10)
                }
            }
        }
        .defaultSize(width: 400, height: 800)
    }
}

struct ItemRow: View {
    @State var item: Item
    let isFirst: Bool
    let isLast: Bool
    var remove: () -> Void
    var moveUp: () -> Void
    var moveDown: () -> Void

    var body: some View {
        HStack {
            Text(item.value)
            Button("Delete") { remove() }
            Button("⌃") { moveUp() }
                .disabled(isFirst)
            Button("⌄") { moveDown() }
                .disabled(isLast)
        }
    }
}

class Item: Identifiable, SwiftCrossUI.ObservableObject {
    let id = UUID()
    @SwiftCrossUI.Published var value: String

    init(_ value: String) {
        self.value = value
    }
}
