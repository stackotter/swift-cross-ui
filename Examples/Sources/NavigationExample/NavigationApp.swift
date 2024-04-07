import Foundation
import SelectedBackend
import SwiftCrossUI

enum SubjectArea: Codable {
    case science
    case humanities
}

enum ScienceSubject: Codable {
    case physics
    case chemistry
}

enum HumanitiesSubject: Codable {
    case english
    case history
}

class NavigationAppState: Observable {
    @Observed var path = NavigationPath()
}

@main
struct NavigationApp: App {
    let identifier = "dev.stackotter.NavigationApp"

    let state = NavigationAppState()

    var body: some Scene {
        WindowGroup("Navigation") {
            NavigationStack(path: state.$path) {
                Text("Learn about subject areas")
                    .padding(.bottom, 10)

                NavigationLink("Science", value: SubjectArea.science, path: state.$path)
                NavigationLink("Humanities", value: SubjectArea.humanities, path: state.$path)
            }
            .navigationDestination(for: SubjectArea.self) { area in
                switch area {
                    case .science:
                        Text("Choose a science subject")
                            .padding(.bottom, 10)

                        NavigationLink("Physics", value: ScienceSubject.physics, path: state.$path)
                        NavigationLink(
                            "Chemistry", value: ScienceSubject.chemistry, path: state.$path)
                    case .humanities:
                        Text("Choose a humanities subject")
                            .padding(.bottom, 10)

                        NavigationLink(
                            "English", value: HumanitiesSubject.english, path: state.$path)
                        NavigationLink(
                            "History", value: HumanitiesSubject.history, path: state.$path)
                }

                backButton
            }
            .navigationDestination(for: ScienceSubject.self) { subject in
                switch subject {
                    case .physics:
                        Text("Physics is applied maths")
                    case .chemistry:
                        Text("Chemistry is applied physics")
                }

                backButton
            }
            .navigationDestination(for: HumanitiesSubject.self) { subject in
                switch subject {
                    case .english:
                        Text("I don't like essays")
                    case .history:
                        Text("Don't repeat it")
                }

                backButton
            }
            .padding(10)
        }
        .defaultSize(width: 200, height: 250)
    }

    @ViewBuilder
    var backButton: some View {
        Button("Back") {
            state.path.removeLast()
        }
        .padding(.top, 10)
    }
}
