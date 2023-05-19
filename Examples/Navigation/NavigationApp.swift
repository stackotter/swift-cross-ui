import Foundation
import SwiftCrossUI

enum SubjectArea: Codable {
    case science
    case humanities
}

struct Science {
    enum Subject: Codable {
        case physics
        case chemistry
    }
}

enum HumanitiesSubject: Codable {
    case english
    case history
}

class NavigationAppState: Observable {
    @Observed var path = NavigationPath()
    @Observed var transitionDuration = 0.3

    var pathWrapper: Observed<NavigationPath> {
        _path
    }
}

@main
struct NavigationApp: App {
    let identifier = "dev.stackotter.NavigationApp"

    let state = NavigationAppState()

    let windowProperties = WindowProperties(
        title: "Navigation",
        defaultSize: WindowProperties.Size(200, 250)
    )

    var body: some ViewContent {
        VStack {
            Text("Change transition duration")
            Slider(state.$transitionDuration, minimum: 0, maximum: 3)
            Button("Test decoded Path", action: {
                // You should probably not do this while running your app.
                // This is just for testing if a decoded path will work for persistence
                print(state.path)
                let encodedPath = try! JSONEncoder().encode(state.path)
                print(String(decoding: encodedPath, as: UTF8.self))
                let decodedPath = try! JSONDecoder().decode(NavigationPath.self, from: encodedPath)
                print(decodedPath)
                state.path = decodedPath
            })
        }
        .padding(10)

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

                    NavigationLink("Physics", value: Science.Subject.physics, path: state.$path)
                    NavigationLink("Chemistry", value: Science.Subject.chemistry, path: state.$path)
                case .humanities:
                    Text("Choose a humanities subject")
                        .padding(.bottom, 10)

                    NavigationLink("English", value: HumanitiesSubject.english, path: state.$path)
                    NavigationLink("History", value: HumanitiesSubject.history, path: state.$path)
            }

            backButton
        }
        .navigationDestination(for: Science.Subject.self) { subject in
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
        .navigationTransition(.slideLeftRight, duration: state.transitionDuration)
        .padding(10)
    }

    @ViewContentBuilder
    var backButton: some ViewContent {
        Button("Back") {
            state.path.removeLast()
        }
        .padding(.top, 10)
    }
}
