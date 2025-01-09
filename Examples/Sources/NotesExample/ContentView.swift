import Foundation
import SwiftCrossUI

struct Note: Codable, Equatable {
    var id = UUID()
    var title: String
    var content: String
}

struct ContentView: View {
    let notesFile = URL(fileURLWithPath: "notes.json")

    @State var notes: [Note] = [
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

    @State var selectedNoteId: UUID?

    @State var error: String?

    var selectedNote: Binding<Note>? {
        guard let id = selectedNoteId else {
            return nil
        }

        guard
            let index = notes.firstIndex(where: { note in
                note.id == id
            })
        else {
            return nil
        }

        // TODO: This is unsafe, index could change/not exist anymore
        return Binding(
            get: {
                notes[index]
            },
            set: { newValue in
                notes[index] = newValue
            }
        )
    }

    var body: some View {
        NavigationSplitView {
            VStack {
                ForEach(notes) { note in
                    Button(note.title) {
                        selectedNoteId = note.id
                    }
                }
                Spacer()
                if let error = error {
                    Text(error)
                        .foregroundColor(.red)
                }
                Button("New note") {
                    let note = Note(title: "Untitled", content: "")
                    notes.append(note)
                    selectedNoteId = note.id
                }
            }
            .onChange(of: notes) {
                do {
                    let data = try JSONEncoder().encode(notes)
                    try data.write(to: notesFile)
                } catch {
                    print("Error: \(error)")
                    self.error = "Failed to save notes"
                }
            }
            .onAppear {
                guard FileManager.default.fileExists(atPath: notesFile.path) else {
                    return
                }

                do {
                    let data = try Data(contentsOf: notesFile)
                    notes = try JSONDecoder().decode([Note].self, from: data)
                } catch {
                    print("Error: \(error)")
                    self.error = "Failed to load notes"
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
