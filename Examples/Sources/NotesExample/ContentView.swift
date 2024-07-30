import Foundation
import SwiftCrossUI

struct Note: Codable, Equatable {
    var id = UUID()
    var title: String
    var content: String
}

class NotesState: Observable, Codable {
    @Observed
    var notes: [Note] = [
        Note(title: "Hello, world!", content: "Welcome SwiftCrossNotes!"),
        Note(
            title: "Shopping list",
            content: """
                - Carrots
                - Mushrooms
                - Pasta
                """
        ),
    ]

    @Observed
    var selectedNoteId: UUID?

    @Observed
    var error: String?
}

struct OnChangeOfView<Value: Equatable, Child: View>: View {
    var state = OnChangeOfViewState()

    var currentValue: Value
    var onChange: (Value) -> Void
    var child: Child
    var notifyInitial: Bool

    class OnChangeOfViewState: Observable {
        var value: Value?
    }

    init(
        _ value: Value,
        _ onChange: @escaping (Value) -> Void,
        _ notifyInitial: Bool,
        _ child: Child
    ) {
        self.currentValue = value
        self.onChange = onChange
        self.notifyInitial = notifyInitial
        self.child = child
    }

    var body: some View {
        if state.value != currentValue {
            let isInitial = state.value != nil
            state.value = currentValue
            if !isInitial || notifyInitial {
                onChange(currentValue)
            }
        }
        return child
    }
}

struct OnAppearView<Child: View>: View {
    var state = OnAppearViewState()
    var onAppear: () -> Void
    var child: Child

    class OnAppearViewState: Observable {
        var hasAppeared = false
    }

    init(_ onAppear: @escaping () -> Void, _ child: Child) {
        self.onAppear = onAppear
        self.child = child
    }

    var body: some View {
        if !state.hasAppeared {
            state.hasAppeared = true
            onAppear()
        }
        return child
    }
}

extension View {
    func onChange<Value>(
        of value: Value,
        initial: Bool = false,
        _ action: @escaping (Value) -> Void
    ) -> OnChangeOfView<Value, Self> {
        OnChangeOfView(value, action, initial, self)
    }

    func onAppear(perform action: @escaping () -> Void) -> OnAppearView<Self> {
        OnAppearView(action, self)
    }
}

struct ContentView: View {
    let notesFile = URL(fileURLWithPath: "notes.json")

    var state = NotesState()

    var selectedNote: Binding<Note>? {
        guard let id = state.selectedNoteId else {
            return nil
        }

        guard
            let index = state.notes.firstIndex(where: { note in
                note.id == id
            })
        else {
            return nil
        }

        // TODO: This is unsafe, index could change/not exist anymore
        return Binding(
            get: {
                state.notes[index]
            },
            set: { newValue in
                state.notes[index] = newValue
            }
        )
    }

    var body: some View {
        NavigationSplitView {
            VStack {
                ForEach(state.notes) { note in
                    Button(note.title) {
                        state.selectedNoteId = note.id
                    }
                }
                Spacer()
                if let error = state.error {
                    Text(error)
                        .foregroundColor(.red)
                }
                Button("New note") {
                    let note = Note(title: "Untitled", content: "")
                    state.notes.append(note)
                    state.selectedNoteId = note.id
                }
            }
            .onChange(of: state.notes) { notes in
                do {
                    let data = try JSONEncoder().encode(notes)
                    try data.write(to: notesFile)
                } catch {
                    print("Error: \(error)")
                    state.error = "Failed to save notes"
                }
            }
            .onAppear {
                guard FileManager.default.fileExists(atPath: notesFile.path) else {
                    return
                }

                do {
                    let data = try Data(contentsOf: notesFile)
                    state.notes = try JSONDecoder().decode([Note].self, from: data)
                } catch {
                    print("Error: \(error)")
                    state.error = "Failed to load notes"
                }
            }
            .padding(10)
        } detail: {
            VStack {
                if let selectedNote = selectedNote {
                    VStack(spacing: 0) {
                        Text("Title")
                        TextField("Title", selectedNote.title)
                    }.padding(.bottom, 10)

                    VStack(spacing: 0) {
                        Text("Content")
                        TextField("Content", selectedNote.content)
                    }
                } else {
                    Text("Select a note...")
                }
            }.padding(10)
        }
    }
}
