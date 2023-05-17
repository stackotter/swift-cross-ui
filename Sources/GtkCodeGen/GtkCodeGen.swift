import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

struct CommandLineArguments {
    var girFile: URL
    var outputDirectory: URL
}

@main
struct GtkCodeGen {
    static let cTypeReplacements: [String: String] = [
        "const char*": "String",
        "char*": "String",
    ]

    static func main() throws {
        let arguments = parseCommandLineArguments()
        let data = try loadGIRFileContents(arguments.girFile)
        let gir = try decodeGIR(data)

        try generateSources(for: gir, to: arguments.outputDirectory)
    }

    static func generateSources(for gir: GIR, to directory: URL) throws {
        for _class in gir.namespace.classes {
            if _class.name == "Button" {
                var initializers: [DeclSyntax] = []
                for constructor in _class.constructors ?? [] {
                    initializers.append(generateInitializer(constructor))
                }

                let conformances: String
                if let parent = _class.parent {
                    conformances = ": \(parent)"
                } else {
                    conformances = ""
                }

                let source = SourceFileSyntax {
                    DeclSyntax("import CGtk")
                        .withTrailingTrivia(Trivia.newline)

                    DeclSyntax(
                        """
                        public class \(raw: _class.name)\(raw: conformances) {
                            \(raw: initializers.map(\.description).joined(separator: "\n"))
                        }
                        """
                    )
                }
                print(source.description)
            }
        }
    }

    static func generateInitializer(_ constructor: Constructor) -> DeclSyntax {
        return DeclSyntax(
            """
            public init(\(raw: generateParameters(constructor.parameters, constructorName: constructor.name))) {
                super.init()
                var widgetPointer = \(raw: constructor.cIdentifier)(\(raw: generateArguments(constructor.parameters)))
            }
            """)
    }

    static func generateParameters(_ parameters: Parameters?, constructorName: String? = nil)
        -> String
    {
        guard var parameters = parameters?.parameters, !parameters.isEmpty else {
            return ""
        }

        // Add a label to the first parameter name based on the constructor name if possible (to
        // avoid ambiguity between certain initializers). E.g. `gtk_button_new_with_label` and
        // `gtk_button_new_with_mnemonic` both call their first parameter `label` which would be
        // ambiguous in Swift.
        if let constructorName = constructorName, constructorName.contains("_with_") {
            let label = convertCIdentifier(
                String(constructorName.components(separatedBy: "_with_")[1]))
            let parameterName = parameters[0].name
            if label != parameterName {
                parameters[0].name = "\(label) \(parameterName)"
            }
        }

        return
            parameters
            .map { parameter in
                guard let type = parameter.type?.cType else {
                    fatalError("Missing type for '\(parameter.name)'")
                }
                return "\(convertCIdentifier(parameter.name)): \(convertCType(type))"
            }
            .joined(separator: ", ")
    }

    static func generateArguments(_ parameters: Parameters?) -> String {
        return parameters?.parameters
            .map(\.name)
            .map(convertCIdentifier)
            .joined(separator: ", ") ?? ""
    }

    static func convertCIdentifier(_ identifier: String) -> String {
        var parts = identifier.split(separator: "_")
        let first = parts.removeFirst()
        return first + parts.map(\.capitalized).joined()
    }

    static func convertCType(_ cType: String) -> String {
        if let replacement = cTypeReplacements[cType] {
            return replacement
        }

        var type = cType
        if type.last == "*" {
            let pointeeType = convertCType(String(type.dropLast()))
            type = "UnsafeMutablePointer<\(pointeeType)>"
        }
        return type
    }

    static func parseCommandLineArguments() -> CommandLineArguments {
        let arguments = ProcessInfo.processInfo.arguments

        let helpRequested = arguments.contains("--help") || arguments.contains("-h")
        let invalid = arguments.count != 3 && !helpRequested
        if invalid || helpRequested {
            print("Usage: ./GtkCodeGen gtk_gir_file output_dir")
            Foundation.exit(invalid ? 1 : 0)
        }

        return CommandLineArguments(
            girFile: URL(fileURLWithPath: arguments[1]),
            outputDirectory: URL(fileURLWithPath: arguments[2])
        )
    }

    static func loadGIRFileContents(_ file: URL) throws -> Data {
        return try Data(contentsOf: file)
    }
}
