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
        "gchar*": "String",
        "gboolean": "Bool",
    ]

    static func main() throws {
        let arguments = parseCommandLineArguments()
        let data = try loadGIRFileContents(arguments.girFile)
        let gir = try decodeGIR(data)

        try? FileManager.default.removeItem(at: arguments.outputDirectory)
        try FileManager.default.createDirectory(
            at: arguments.outputDirectory, withIntermediateDirectories: true
        )

        try generateSources(for: gir, to: arguments.outputDirectory)
    }

    static func generateSources(for gir: GIR, to directory: URL) throws {
        let allowListedClasses = ["Button", "ToggleButton"]
        for class_ in gir.namespace.classes where allowListedClasses.contains(class_.name) {
            var initializers: [DeclSyntax] = []
            for constructor in class_.constructors ?? [] {
                initializers.append(generateInitializer(constructor))
            }

            var properties: [DeclSyntax] = []
            for property in class_.properties ?? [] where property.name != "child" {
                guard
                    let decl = generateProperty(property, namespace: gir.namespace, class_: class_)
                else {
                    continue
                }
                properties.append(decl)
            }

            let signals = class_.signals ?? []
            for signal in signals {
                properties.append(
                    generateSignalHandlerProperty(signal, class_: class_)
                )
            }

            var methods: [DeclSyntax] = []
            if !signals.isEmpty {
                methods.append(
                    generateDidMoveToParent(signals)
                )
            }

            let conformances: String
            if let parent = class_.parent {
                conformances = ": \(parent)"
            } else {
                conformances = ""
            }

            let source = SourceFileSyntax {
                DeclSyntax("import CGtk")
                    .withTrailingTrivia(Trivia.newline)

                DeclSyntax(
                    """
                    public class \(raw: class_.name)\(raw: conformances) {
                        \(raw: initializers.map(\.description).joined(separator: "\n\n"))

                        \(raw: methods.map(\.description).joined(separator: "\n\n"))

                        \(raw: properties.map(\.description).joined(separator: "\n\n"))
                    }
                    """
                )
            }

            try save(source.description, to: directory, class_: class_)
        }
    }

    static func save(_ source: String, to directory: URL, class_: Class) throws {
        let file = directory.appendingPathComponent("\(class_.name).swift")
        try source.write(to: file, atomically: false, encoding: .utf8)
    }

    static func generateDidMoveToParent(_ signals: [Signal]) -> DeclSyntax {
        var exprs: [ExprSyntax] = []

        for signal in signals {
            let name = convertDelimitedCasingToCamel(signal.name, delimiter: "-")
            exprs.append(
                ExprSyntax(
                    """
                    addSignal(name: \(literal: signal.name)) { [weak self] in
                        guard let self = self else { return }
                        self.\(raw: name)?(self)
                    }
                    """
                )
            )
        }

        return DeclSyntax(
            """
            override func didMoveToParent() {
                super.didMoveToParent()

                \(raw: exprs.map(\.description).joined(separator: "\n\n"))
            }
            """
        )
    }

    static func generateSignalHandlerProperty(_ signal: Signal, class_: Class) -> DeclSyntax {
        let name = convertDelimitedCasingToCamel(signal.name, delimiter: "-")
        return DeclSyntax(
            """
            public var \(raw: name): ((\(raw: class_.name)) -> Void)?
            """
        )
    }

    static func generateProperty(
        _ property: Property,
        namespace: Namespace,
        class_: Class
    ) -> DeclSyntax? {
        guard let getterName = property.getter else {
            return nil
        }

        guard let girType = property.type else {
            fatalError("Missing type for '\(class_.name).\(property.name)'")
        }

        var type = swiftType(girType, namespace: namespace)
        let getterFunction = "\(namespace.cSymbolPrefix)_\(class_.cSymbolPrefix)_\(getterName)"

        guard
            let method = class_.methods?.first(where: { method in
                method.cIdentifier == getterFunction
            })
        else {
            fatalError("'\(class_.name)' is missing method matching '\(getterFunction)'")
        }

        if method.returnValue?.nullable == true {
            type += "?"
        }

        let getter =
            """
            get {
                return \(generateGtkToSwiftConversion("\(getterFunction)(castedPointer())", swiftType: type))
            }
            """

        let setter = property.setter.map { setter in
            let conversion = generateSwiftToGtkConversion("newValue", swiftType: type)
            return
                """
                set {
                    \(namespace.cSymbolPrefix)_\(class_.cSymbolPrefix)_\(setter)(castedPointer(), \(conversion))
                }
                """
        }

        return DeclSyntax(
            """
            public var \(raw: convertPropertyName(property.name)): \(raw: type) {
                \(raw: getter)
                \(raw: setter ?? "")
            }
            """
        )
    }

    static func generateSwiftToGtkConversion(_ value: String, swiftType: String) -> String {
        switch swiftType {
            case "Bool":
                return "\(value).toGBoolean()"
            default:
                return value
        }
    }

    static func generateGtkToSwiftConversion(_ value: String, swiftType: String) -> String {
        switch swiftType {
            case "String?":
                return "\(value).map(String.init(cString:))"
            case "Bool":
                return "\(value).toBool()"
            default:
                return value
        }
    }

    static func swiftType(_ type: GIRType, namespace: Namespace) -> String {
        if let cType = type.cType {
            return convertCType(cType)
        } else if let name = type.name {
            return namespace.cIdentifierPrefix + name
        } else {
            fatalError("Type has no valid name")
        }
    }

    static func generateInitializer(_ constructor: Constructor) -> DeclSyntax {
        let parameters = generateParameters(
            constructor.parameters,
            constructorName: constructor.name
        )
        let modifiers = parameters.isEmpty ? "override " : ""

        return DeclSyntax(
            """
            \(raw: modifiers)public init(\(raw: parameters)) {
                super.init()
                widgetPointer = \(raw: constructor.cIdentifier)(\(raw: generateArguments(constructor.parameters)))
            }
            """
        )
    }

    static func generateParameters(
        _ parameters: Parameters?,
        constructorName: String? = nil
    ) -> String {
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
        return convertDelimitedCasingToCamel(identifier, delimiter: "_")
    }

    static func convertPropertyName(_ name: String) -> String {
        return convertDelimitedCasingToCamel(name, delimiter: "-")
    }

    static func convertDelimitedCasingToCamel(
        _ identifier: String,
        delimiter: Character
    ) -> String {
        var parts = identifier.split(separator: delimiter)
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
