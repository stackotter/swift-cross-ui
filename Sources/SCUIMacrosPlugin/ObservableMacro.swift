import MacroToolkit
import SwiftSyntax
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacros

public struct ObservableMacro: MemberAttributeMacro, ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        guard let classDecl = ClassDeclSyntax(declaration) else {
            throw MacroError("@Observable can only be applied to classes")
        }

        guard
            let variable = member.as(VariableDeclSyntax.self),
            // only fully visible members
            !variable.modifiers.contains(where: { modifier in
                let kind = modifier.name.tokenKind

                return
                    kind == .keyword(.static) || kind == .keyword(.private)
                    || kind == .keyword(.fileprivate)
            }),
            // only variables
            variable.bindingSpecifier.text == "var",
            // only not yet observed and not opt out members
            !variable.attributes.contains(where: { attr in
                let trimmedDescription = attr.as(AttributeSyntax.self)?
                    .attributeName
                    .trimmedDescription
                return
                    trimmedDescription == "Published"
                    || trimmedDescription == "SwiftCrossUI.Published"
                    || trimmedDescription == "ObservationIgnored"
                    || trimmedDescription == "SwiftCrossUI.ObservationIgnored"
            }),
            // only non computed properties
            !variable.bindings.contains(where: {
                guard let accessor = $0.accessorBlock else { return false }
                return indicatesComputed(accessor: accessor)
            })
        else {
            return []
        }

        if variable.bindings.count != 1 {
            throw MacroError(
                "@Observable only supports single variables. Split up your variable declaration or ignore it with @ObservationIgnored"
            )
        }

        return ["@SwiftCrossUI.Published"]
    }

    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let classDecl = ClassDeclSyntax(declaration) else {
            throw MacroError("@Observable can only be applied to classes")
        }

        let extensionDecl = try ExtensionDeclSyntax(
            """
            extension \(raw: type): SwiftCrossUI.ObservableObject {}
            """
        )

        return [extensionDecl]
    }

    private static func indicatesComputed(accessor: AccessorBlockSyntax) -> Bool {
        switch accessor.accessors {
            case .accessors(let list):
                // willSet/didSet alone don't make it computed
                return list.contains(where: {
                    let kind = $0.accessorSpecifier.tokenKind
                    return kind == .keyword(.get) || kind == .keyword(.set)
                })
            case .getter:
                // e.g. 'var x: Int { 0 }'
                return true
        }
    }
}

public struct ObservationIgnoredMacro: AccessorMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingAccessorsOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.AccessorDeclSyntax] {
        return []
    }
}
