import MacroToolkit
import SwiftSyntax
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacros

public struct ObservableObjectMacro: MemberAttributeMacro, ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        guard ClassDeclSyntax(declaration) != nil else {
            throw MacroError("@Observable can only be applied to classes")
        }

        guard
            let variable = Decl(member).asVariable,
            // only fully visible members
            !variable._syntax.modifiers.contains(where: { modifier in
                let kind = modifier.name.tokenKind

                return
                    kind == .keyword(.static) || kind == .keyword(.private)
                    || kind == .keyword(.fileprivate)
            }),
            // Only include variables
            variable._syntax.bindingSpecifier.text == "var",
            // Only include not yet observed and not opt out members
            !variable.attributes.contains(where: { attr in
                return
                    [
                        "Published",
                        "SwiftCrossUI.Published",
                        "ObservationIgnored",
                        "SwiftCrossUI.ObservationIgnored",
                    ].contains(attr.attribute?.name.name)
            }),
            // Only include properties without accessors
            variable.isStoredProperty
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
        guard ClassDeclSyntax(declaration) != nil else {
            throw MacroError("@Observable can only be applied to classes")
        }

        let extensionDecl = try ExtensionDeclSyntax(
            """
            extension \(raw: type): SwiftCrossUI.ObservableObject {}
            """
        )

        return [extensionDecl]
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
