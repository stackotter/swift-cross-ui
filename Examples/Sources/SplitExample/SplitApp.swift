import DefaultBackend
import Foundation
import SwiftCrossUI

#if canImport(SwiftBundlerRuntime)
    import SwiftBundlerRuntime
#endif

enum SubjectArea {
    case science
    case humanities
}

enum ScienceSubject {
    case physics
    case chemistry
}

enum HumanitiesSubject {
    case english
    case history
}

enum Columns {
    case two
    case three
}

struct ContentView: View {
    @State var selectedArea: SubjectArea?
    @State var selectedDetail: Any?
    @State var columns: Columns = .two

    var body: some View {
        switch columns {
            case .two:
                doubleColumn
            case .three:
                tripleColumn
        }
    }

    /// Example view for a two column NavigationSplitView
    var doubleColumn: some View {
        NavigationSplitView {
            VStack {
                Button("Science") { selectedArea = .science }
                Button("Humanities") { selectedArea = .humanities }
                Spacer()
                Button("Switch to 3 column example") { columns = .three }
            }.padding(10)
        } detail: {
            VStack {
                switch selectedArea {
                    case .science:
                        Text("Science")
                    case .humanities:
                        Text("Humanities")
                    case nil:
                        Text("Select an area")
                }
            }.padding(10)
        }
    }

    /// Example view for a three column NavigationSplitView
    var tripleColumn: some View {
        NavigationSplitView {
            VStack {
                Button("Science") { selectedArea = .science }
                Button("Humanities") { selectedArea = .humanities }
                Spacer()
                Button("Switch to 2 column example") { columns = .two }
            }.padding(10)
        } content: {
            VStack {
                switch selectedArea {
                    case .science:
                        Text("Choose a science subject")
                            .padding(.bottom, 10)
                        Button("Physics") { selectedDetail = ScienceSubject.physics }
                        Button("Chemistry") { selectedDetail = ScienceSubject.chemistry }
                    case .humanities:
                        Text("Choose a humanities subject")
                            .padding(.bottom, 10)
                        Button("English") { selectedDetail = HumanitiesSubject.english }
                        Button("History") { selectedDetail = HumanitiesSubject.history }
                    case nil:
                        Text("Select an area")
                }
            }
            .padding(10)
            .frame(minWidth: 190)
        } detail: {
            VStack {
                switch selectedDetail {
                    case let subject as ScienceSubject:
                        switch subject {
                            case .physics:
                                Text("Physics is applied maths")
                            case .chemistry:
                                Text("Chemistry is applied physics")
                        }
                    case let subject as HumanitiesSubject:
                        switch subject {
                            case .english:
                                Text("I don't like essays")
                            case .history:
                                Text("Don't repeat it")
                        }
                    default:
                        Text("Select a subject")
                }
            }
            .padding(10)
        }
    }
}

@main
@HotReloadable
struct SplitApp: App {
    var body: some Scene {
        WindowGroup("Split") {
            #hotReloadable {
                ContentView()
            }
        }
        .defaultSize(width: 600, height: 250)
    }
}
