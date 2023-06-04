import Foundation
import XMLCoder

extension GtkCodeGen {
    static func decodeGIR(_ data: Data) throws -> GIR {
        let decoder = XMLDecoder()
        decoder.keyDecodingStrategy = .custom({ path in
            let codingKey = path[path.count - 1]
            let containsColon = codingKey.stringValue.contains(":")
            let containsHyphen = codingKey.stringValue.contains("-")
            if containsColon || containsHyphen {
                var input = codingKey.stringValue
                var output = ""

                // Remove namespace
                if containsColon {
                    let parts = input.split(separator: ":").map(String.init)
                    output = parts[0]
                    input = parts[1]
                }

                // Convert kebab-case to camelCase
                if containsHyphen {
                    var parts = input.split(separator: "-")
                    let firstPart = String(parts.removeFirst())
                    if containsColon {
                        output += firstPart.capitalized
                    } else {
                        output += firstPart
                    }

                    for part in parts {
                        output += part.capitalized
                    }
                } else {
                    output += input.capitalized
                }

                return output
            } else {
                return codingKey
            }
        })
        return try decoder.decode(GIR.self, from: data)
    }
}

struct GIR: Decodable {
    var package: Package
    var namespace: Namespace
    var include: [Include]
}

struct Namespace: Decodable {
    var name: String
    var version: String
    var sharedLibrary: String
    var cIdentifierPrefix: String
    var cSymbolPrefix: String

    var aliases: [Alias]
    var classes: [Class]
    var enumerations: [Enumeration]

    enum CodingKeys: String, CodingKey {
        case name, version, sharedLibrary
        case cIdentifierPrefix = "cIdentifierPrefixes"
        case cSymbolPrefix = "cSymbolPrefixes"
        case aliases = "alias"
        case classes = "class"
        case enumerations = "enumeration"
    }
}

struct Enumeration: Decodable {
    var name: String
    var cType: String
    var doc: String
    var members: [Member]

    enum CodingKeys: String, CodingKey {
        case name, cType, doc
        case members = "member"
    }

    struct Member: Decodable {
        var name: String
        var cIdentifier: String
        var doc: String
    }
}

struct Alias: Decodable {
    var name: String
    @Attribute var cType: String
    var doc: String
    @Element var type: String
}

struct Class: Decodable {
    var name: String
    var cSymbolPrefix: String
    var cType: String?
    var parent: String?
    var abstract: Bool?

    var doc: String
    var constructors: [Constructor]?
    var methods: [Method]?
    var properties: [Property]?
    var signals: [Signal]?

    enum CodingKeys: String, CodingKey {
        case name, cSymbolPrefix, cType, parent, abstract, doc
        case constructors = "constructor"
        case methods = "method"
        case properties = "property"
        case signals = "glibSignal"
    }
}

struct Signal: Decodable {
    var name: String
    var when: String
    var noRecurse: Bool?
    var doc: String?
    var returnValue: ReturnValue
    var parameters: Parameters?
}

struct Constructor: Decodable {
    var name: String
    var cIdentifier: String
    var doc: String
    var returnValue: ReturnValue
    var parameters: Parameters?
    var version: String?
}

struct Method: Decodable {
    var name: String
    var cIdentifier: String
    var version: String?
    var doc: String?
    var returnValue: ReturnValue?
    var parameters: MethodParameters?
}

struct Property: Decodable {
    var name: String
    var doc: String?
    var getter: String?
    var setter: String?
    var defaultValue: String?
    var transferOwnership: String
    var writable: Bool?
    var type: GIRType?
}

struct MethodParameters: Decodable {
    var instanceParameter: Parameter
    var parameters: [Parameter]

    enum CodingKeys: String, CodingKey {
        case instanceParameter
        case parameters = "parameter"
    }
}

struct Parameters: Decodable {
    var parameters: [Parameter]

    enum CodingKeys: String, CodingKey {
        case parameters = "parameter"
    }
}

struct Parameter: Decodable {
    var nullable: Bool?
    var name: String
    var transferOwnership: String
    var doc: String?
    var type: GIRType?
    var varargs: VarArgs?
}

struct VarArgs: Decodable {}

struct ReturnValue: Decodable {
    var nullable: Bool?
    var transferOwnership: String?
    var doc: String?
    var type: GIRType?
}

struct GIRType: Decodable {
    var name: String?
    var cType: String?
}

struct Package: Decodable {
    var name: String
}

struct Include: Decodable {
    var name: String
    var version: String
}
