import SwiftCrossUI

enum SubjectArea: Hashable {
    case science
    case humanities
}

enum ScienceSubject: Hashable {
    case physics
    case chemistry
}

enum HumanitiesSubject: Hashable {
    case english
    case history
}

class NavigationAppState: AppState {
    @Observed var path = NavigationPath()
    @Observed var transitionDuration = 0.3
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

                    NavigationLink("Physics", value: ScienceSubject.physics, path: state.$path)
                    NavigationLink("Chemistry", value: ScienceSubject.chemistry, path: state.$path)
                case .humanities:
                    Text("Choose a humanities subject")
                        .padding(.bottom, 10)

                    NavigationLink("English", value: HumanitiesSubject.english, path: state.$path)
                    NavigationLink("History", value: HumanitiesSubject.history, path: state.$path)
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