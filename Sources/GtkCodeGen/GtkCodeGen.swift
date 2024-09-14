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
        "gdouble": "Double",
        "guint": "UInt",
        "gint": "Int",
        "gfloat": "Float",
        "double": "Double",
        "GIcon*": "OpaquePointer",
        "GdkPixbuf*": "OpaquePointer",
        "GdkPaintable*": "OpaquePointer",
    ]

    static let interfaces: [String] = [
        "Gio.ListModel"
    ]

    static let unshorteningMap: [String: String] = [
        "char": "character",
        "str": "string",
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
        let allowListedClasses = [
            "Button", "Entry", "Label", "TextView", "Range", "Scale", "Image", "DropDown",
            "Picture", "Switch",
        ]
        for class_ in gir.namespace.classes where allowListedClasses.contains(class_.name) {
            let source = generateClass(class_, namespace: gir.namespace)
            try save(source.description, to: directory, declName: class_.name)
        }

        for enumeration in gir.namespace.enumerations {
            // Enums that aren't available in base 4.10 shouldn't be generated.
            guard enumeration.version == nil else {
                continue
            }

            // The 'License' enum has a case that doesn't seem to exist in some Gtk versions
            guard enumeration.name != "License" else {
                continue
            }

            let source = generateEnum(enumeration)
            try save(source.description, to: directory, declName: enumeration.name)
        }

        // TODO: Generate Orientable
        for interface in gir.namespace.interfaces where interface.name != "Orientable" {
            // Skip interfaces which were added since 4.0
            guard interface.version == nil else {
                continue
            }
            let source = generateProtocol(interface, namespace: gir.namespace)
            try save(source.description, to: directory, declName: interface.name)
        }
    }

    static func generateProtocol(_ interface: Interface, namespace: Namespace) -> String {
        var properties: [DeclSyntax] = []
        for property in interface.properties where property.version == nil {
            if let syntax = generateProperty(
                property, namespace: namespace, classLike: interface, forProtocol: true
            ) {
                properties.append(syntax)
            }
        }

        var signalProperties: [DeclSyntax] = []
        for signal in interface.signals {
            signalProperties.append(
                generateSignalHandlerProperty(signal, className: "Self", forProtocol: true)
            )
        }

        let source = SourceFileSyntax(
            """
            import CGtk

            \(raw: docComment(interface.doc))
            public protocol \(raw: interface.name): GObjectRepresentable {
                \(raw: properties.map(\.description).joined(separator: "\n\n"))

                \(raw: signalProperties.map(\.description).joined(separator: "\n\n"))
            }
            """
        )
        return source.description
    }

    static func generateEnum(_ enumeration: Enumeration) -> String {
        // Filter out members which were introduced after 4.0
        let members = enumeration.members.filter { member in
            if member.version != nil {
                return false
            }

            if let doc = member.doc {
                // Why they gotta be inconsistent like that 💀
                return !doc.contains("Since: ") && !doc.contains("Since ")
            } else {
                return true
            }
        }

        var cases: [DeclSyntax] = []
        for case_ in members {
            let name = convertCIdentifier(case_.name)
            cases.append(
                DeclSyntax(
                    """
                    \(raw: docComment(case_.doc))
                    case \(raw: name)
                    """
                )
            )
        }

        var toGtkConversionSwitchCases: [SwitchCaseSyntax] = []
        for case_ in members {
            let name = convertCIdentifier(case_.name)
            toGtkConversionSwitchCases.append(
                SwitchCaseSyntax(
                    """
                    case .\(raw: name):
                        return \(raw: case_.cIdentifier)
                    """
                )
            )
        }

        var fromGtkConversionSwitchCases: [SwitchCaseSyntax] = []
        for case_ in members {
            let name = convertCIdentifier(case_.name)
            fromGtkConversionSwitchCases.append(
                SwitchCaseSyntax(
                    """
                    case \(raw: case_.cIdentifier):
                        self = .\(raw: name)
                    """
                )
            )
        }

        let source = SourceFileSyntax(
            """
            import CGtk

            \(raw: docComment(enumeration.doc))
            public enum \(raw: enumeration.name): GValueRepresentableEnum {
                public typealias GtkEnum = \(raw: enumeration.cType)

                \(raw: cases.map(\.description).joined(separator: "\n"))

                /// Converts a Gtk value to its corresponding swift representation.
                public init(from gtkEnum: \(raw: enumeration.cType)) {
                    switch gtkEnum {
                        \(raw: fromGtkConversionSwitchCases.map(\.description).joined(separator: "\n"))
                        default:
                            fatalError("Unsupported \(raw: enumeration.cType) enum value: \\(gtkEnum.rawValue)")
                    }
                }

                /// Converts the value to its corresponding Gtk representation.
                public func toGtk() -> \(raw: enumeration.cType) {
                    switch self {
                        \(raw: toGtkConversionSwitchCases.map(\.description).joined(separator: "\n"))
                    }
                }
            }
            """
        )
        return source.description
    }

    static func docComment(_ doc: String?) -> String {
        // TODO: Parse comment format to replace image includes, links, and similar
        doc?
            .split(separator: "\n", omittingEmptySubsequences: false)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .enumerated()
            .map {
                $0.offset == 0
                    ? $0.element.prefix(1).capitalized + $0.element.dropFirst() : $0.element
            }
            .map { "/// \($0)" }
            .joined(separator: "\n") ?? ""
    }

    static func generateClass(_ class_: Class, namespace: Namespace) -> String {
        var initializers: [DeclSyntax] = []
        for constructor in class_.constructors {
            let excludedParameterTypes: [String] = ["GListModel*", "GFile*"]
            if let type = constructor.parameters?.parameters.first?.type?.cType,
                excludedParameterTypes.contains(type)
            {
                // TODO: Support GListModel, GFile and GtkExpression
                continue
            }
            initializers.append(generateInitializer(constructor))
        }

        var properties: [DeclSyntax] = []
        for (classLike, property) in class_.getAllImplemented(\.properties, namespace: namespace) {
            guard
                property.version == nil,
                property.name != "child",
                let decl = generateProperty(
                    property, namespace: namespace, classLike: classLike, forProtocol: false
                )
            else {
                continue
            }
            properties.append(decl)
        }

        // TODO: Refactor so that notify::property signal handlers aren't just hacked into the
        //   signal handler generation code so jankily. Ideally we should decouple the signal generation
        //   code from the GIR types a bit more so that we can synthesize signals without having to
        //   create fake GIR entries.
        var signals = class_.getAllImplemented(\.signals, namespace: namespace)
        for (classLike, property) in class_.getAllImplemented(\.properties, namespace: namespace) {
            signals.append(
                (
                    classLike,
                    Signal(
                        name: "notify::\(property.name)", when: "before",
                        returnValue: ReturnValue(
                            nullable: false, doc: "", type: property.type
                        ),
                        parameters: Parameters(parameters: [
                            Parameter(
                                nullable: false, name: "object", transferOwnership: "", doc: "",
                                type: GIRType.init(name: "OpaquePointer", cType: "OpaquePointer")
                            )
                        ])
                    )
                )
            )
        }

        for (_, signal) in signals {
            properties.append(
                generateSignalHandlerProperty(signal, className: class_.name, forProtocol: false)
            )
        }

        var methods: [DeclSyntax] = []
        if !signals.isEmpty {
            methods.append(
                generateDidMoveToParent(
                    signals.map { signal in
                        signal.1
                    },
                    namespace: namespace
                )
            )
        }

        var conformances: [String] = []
        if let parent = class_.parent {
            conformances.append(parent)
        }

        for conformance in class_.getImplementedInterfaces(
            namespace: namespace, excludeInherited: true
        ) {
            conformances.append(conformance.name)
        }

        let conformanceString: String
        if conformances.isEmpty {
            conformanceString = ""
        } else {
            conformanceString = ": \(conformances.joined(separator: ", "))"
        }

        let source = SourceFileSyntax(
            """
            import CGtk

            \(raw: docComment(class_.doc))
            public class \(raw: class_.name)\(raw: conformanceString) {
                \(raw: initializers.map(\.description).joined(separator: "\n\n"))

                \(raw: methods.map(\.description).joined(separator: "\n\n"))

                \(raw: properties.map(\.description).joined(separator: "\n\n"))
            }
            """
        )
        return source.description
    }

    static func save(_ source: String, to directory: URL, declName: String) throws {
        let file = directory.appendingPathComponent("\(declName).swift")
        try source.write(to: file, atomically: false, encoding: .utf8)
    }

    static func generateDidMoveToParent(_ signals: [Signal], namespace: Namespace) -> DeclSyntax {
        var exprs: [String] = []

        for (signalIndex, signal) in signals.enumerated() {
            let parameterCount = signal.parameters?.parameters.count ?? 0

            let parameterTypes = (signal.parameters?.parameters ?? []).map { parameter in
                guard let girType = parameter.type else {
                    fatalError(
                        "Missing c type for parameter '\(parameter.name)' of signal '\(signal.name)'"
                    )
                }
                var type = swiftType(girType, namespace: namespace)
                if type == "String" {
                    type = "UnsafePointer<CChar>"
                }
                return type
            }
            let name = convertDelimitedCasingToCamel(
                signal.name.replacingOccurrences(of: "::", with: "-"),
                delimiter: "-"
            )

            let parameters = parameterTypes.map { type in
                "_: \(type)"
            }.joined(separator: ", ")

            let closure = ExprSyntax(
                """
                { [weak self] (\(raw: parameters)) in
                    guard let self = self else { return }
                    self.\(raw: name)?(self)
                }
                """
            )
            let expr: ExprSyntax
            if parameterCount == 0 {
                expr = ExprSyntax(
                    """
                    addSignal(name: \(literal: signal.name)) \(raw: closure)
                    """
                )
            } else {
                let typeParameters = parameterTypes.joined(separator: ", ")

                let arguments = (1...parameterCount).map { "value\($0)" }.joined(separator: ", ")
                exprs.append(
                    DeclSyntax(
                        """
                        let handler\(raw: signalIndex): @convention(c) (UnsafeMutableRawPointer, \(raw: typeParameters), UnsafeMutableRawPointer) -> Void =
                            { _, \(raw: arguments), data in
                                SignalBox\(raw: parameterCount)<\(raw: typeParameters)>.run(data, \(raw: arguments))
                            }
                        """
                    ).description
                )
                expr = ExprSyntax(
                    """
                    addSignal(name: \(literal: signal.name), handler: gCallback(handler\(raw: signalIndex))) \(raw: closure)
                    """
                )
            }
            exprs.append(expr.description)
        }

        return DeclSyntax(
            """
            override func didMoveToParent() {
                removeSignals()

                super.didMoveToParent()

                \(raw: exprs.joined(separator: "\n\n"))
            }
            """
        )
    }

    static func generateSignalHandlerProperty(
        _ signal: Signal, className: String, forProtocol: Bool
    ) -> DeclSyntax {
        // TODO: Correctly handle signals that take extra parameters
        let name = convertDelimitedCasingToCamel(
            signal.name.replacingOccurrences(of: "::", with: "-"),
            delimiter: "-"
        )
        var prefix = ""
        var suffix = ""
        if forProtocol {
            suffix = " { get set }"
        } else {
            prefix = "public "
        }
        return DeclSyntax(
            """
            \(raw: docComment(signal.doc))
            \(raw: prefix)var \(raw: name): ((\(raw: className)) -> Void)?\(raw: suffix)
            """
        )
    }

    static func generateProperty(
        _ property: Property,
        namespace: Namespace,
        classLike: any ClassLike,
        forProtocol: Bool
    ) -> DeclSyntax? {
        guard let getterName = property.getter else {
            return nil
        }

        guard let girType = property.type else {
            fatalError("Missing type for '\(classLike.name).\(property.name)'")
        }

        var type = swiftType(girType, namespace: namespace)
        let getterFunction = "\(namespace.cSymbolPrefix)_\(classLike.cSymbolPrefix)_\(getterName)"

        guard
            let method = classLike.methods.first(where: { method in
                method.cIdentifier == getterFunction
            })
        else {
            print(property)
            fatalError("'\(classLike.name)' is missing method matching '\(getterFunction)'")
        }

        // TODO: Handle this conversion more cleanly
        if type.hasPrefix("Gtk") {
            type = String(type.dropFirst(3))
        }

        if !cTypeReplacements.values.contains(type)
            && !namespace.enumerations.contains(where: { $0.name == type })
            && type != "OpaquePointer"
        {
            print("Skipping \(property.name) with type \(type)")
            // TODO: Handle more types
            return nil
        }

        if method.returnValue?.nullable == true {
            type += "?"
        }

        // TODO: Figure out why DropDown.selected doesn't work as a UInt (Gtk complains that
        //   the property doesn't hold a UInt, implying that the docs are wrong??)
        if classLike.name == "DropDown" && property.name == "selected" {
            type = "Int"
        }

        guard !type.contains(".") else {
            // TODO: Handle namespaced types
            return nil
        }

        var prefix = ""
        var suffix = ""
        if forProtocol {
            suffix = " { get set }"
        } else {
            let literal = StringLiteralExprSyntax(content: property.name).description
            prefix = "@GObjectProperty(named: \(literal)) public "
        }

        return DeclSyntax(
            """
            \(raw: docComment(property.doc))
            \(raw: prefix)var \(raw: convertPropertyName(property.name)): \(raw: type)\(raw: suffix)
            """
        )
    }

    static func swiftType(_ type: GIRType, namespace: Namespace) -> String {
        if let cType = type.cType {
            return convertCType(cType)
        } else if let name = type.name {
            if interfaces.contains(name) {
                return "OpaquePointer"
            } else {
                return namespace.cIdentifierPrefix + name
            }
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
            \(raw: docComment(constructor.doc))
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

        for (i, parameter) in parameters.enumerated() {
            parameters[i].name = convertCIdentifier(parameter.name)
        }

        // TODO: Fix for `gtk_scale_new_with_range`
        // Add a label to the first parameter name based on the constructor name if possible (to
        // avoid ambiguity between certain initializers). E.g. `gtk_button_new_with_label` and
        // `gtk_button_new_with_mnemonic` both call their first parameter `label` which would be
        // ambiguous in Swift.
        if let constructorName = constructorName, constructorName.contains("_with_") {
            let label = convertCIdentifier(
                String(constructorName.components(separatedBy: "_with_")[1])
            )
            let parameterName = parameters[0].name
            if label != parameterName {
                parameters[0].name = "\(label) \(parameterName)"
            }
        }

        return
            parameters
            .map { parameter in
                if let type = parameter.type?.cType {
                    return "\(parameter.name): \(convertCType(type))"
                } else if let arrayElementType = parameter.array?.type.cType {
                    return "\(parameter.name): [\(convertCType(arrayElementType))]"
                } else {
                    fatalError("Missing type for '\(parameter.name)'")
                }
            }
            .joined(separator: ", ")
    }

    static func generateArguments(_ parameters: Parameters?) -> String {
        return parameters?.parameters.map { parameter in
            let name = convertCIdentifier(parameter.name)
            var argument = name

            // TODO: Handle nested pointer arrays more generally
            if parameter.array?.type.cType == "char*" {
                argument = """
                    \(argument)
                        .map({ UnsafePointer($0.unsafeUTF8Copy().baseAddress) })
                        .unsafeCopy()
                        .baseAddress!
                    """
            }

            return argument
        }
        .joined(separator: ", ") ?? ""
    }

    static func convertCIdentifier(_ identifier: String) -> String {
        // TODO: Keywords should possibly be escaped with backticks instead of underscored
        let keywords = ["true", "false", "default", "switch", "import"]
        if keywords.contains(identifier) {
            return "\(identifier)_"
        }
        var identifier = identifier
        if identifier.starts(with: "0") {
            identifier = "zero_" + identifier.dropFirst()
        }
        return convertDelimitedCasingToCamel(identifier, delimiter: "_")
    }

    static func convertPropertyName(_ name: String) -> String {
        return convertDelimitedCasingToCamel(name, delimiter: "-", unshorten: true)
    }

    static func convertDelimitedCasingToCamel(
        _ identifier: String,
        delimiter: Character,
        unshorten: Bool = false
    ) -> String {
        var parts = identifier.split(separator: delimiter).map(String.init)
        for (i, part) in parts.enumerated() {
            if let replacement = unshorteningMap[part] {
                parts[i] = replacement
            }
        }
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
            type = "UnsafeMutablePointer<\(pointeeType)>!"
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
