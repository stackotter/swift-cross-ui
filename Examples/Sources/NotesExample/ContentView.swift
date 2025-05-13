import Foundation
import SwiftCrossUI

struct Note: Codable, Equatable, Identifiable {
    var id = UUID()
    var title: String
    var content: String

    var truncatedDescription: String {
        let firstLine = content.split(separator: "\n").first ?? []
        let words = firstLine.split(separator: " ", omittingEmptySubsequences: false)
        let limit = 20
        var output = ""
        for (index, word) in words.enumerated() {
            let addition = (index == 0 ? "" : " ") + word
            guard output.count + addition.count <= limit else {
                if index == 0 {
                    // We should at least output a little snippet
                    output += word.prefix(limit)
                }
                break
            }
            output += addition
        }
        if content.isEmpty {
            output = "No content"
        } else if output.count < content.count {
            output += "..."
        }
        return output
    }
}

struct ContentView: View {
    let notesFile = URL(fileURLWithPath: "notes.json")

    @State var notes: [Note] = [
        Note(title: "Hello, world!", content: "Welcome SwiftCrossNotes!"),
        Note(
            title: "Shopping list",
            content: "Carrots, mushrooms, and party pies"
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
                ScrollView {
                    List(notes, selection: $selectedNoteId) { note in
                        VStack(alignment: .leading, spacing: 0) {
                            Text(note.title.isEmpty ? "Untitled" : note.title)
                            Text(note.truncatedDescription)
                                .foregroundColor(.gray)
                                .font(.system(size: 12))
                        }
                    }
                    .padding(10)
                }
                if let error = error {
                    Text(error)
                        .foregroundColor(.red)
                }
                Button("New note") {
                    let note = Note(title: "", content: "")
                    notes.append(note)
                    selectedNoteId = note.id
                }
                .padding(10)
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
        } detail: {
            VStack(alignment: .leading) {
                if let selectedNote = selectedNote {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Title")
                        TextField("Title", text: selectedNote.title)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Content")
                        TextField("Content", text: selectedNote.content)
                    }
                } else {
                    Text("Select a note...")
                }
            }
            .frame(maxWidth: 400)
            .padding(10)

            Spacer()
        }
    }
}
