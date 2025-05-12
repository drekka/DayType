import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

struct KeyedContainerDecodeMissingDayStringMacro: MemberMacro {

    static func expansion(
        of node: AttributeSyntax,
        providingMembersOf owningType: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        guard owningType.as(ExtensionDeclSyntax.self)?.extendedType.trimmedDescription == "KeyedDecodingContainer" else {
            context.diagnose(Diagnostic(
                node: node, message: MacroExpansionErrorMessage("Can only be used on a KeyedDecodingContainer: \(owningType.as(ExtensionDeclSyntax.self)?.extendedType.trimmedDescription ?? "")")
            ))
            return []
        }

        guard let decodableType = node.arguments?.typeArgumentValue("type") else {
            context.diagnose(Diagnostic(
                node: node, message: MacroExpansionErrorMessage("Unable to determine passed type argument from: \(node.arguments?.description ?? "")")
            ))
            return []
        }

        return [
            """
            public func decode(_ type: \(raw: decodableType).Type, forKey key: Key) throws -> \(raw: decodableType) {
                try decodeIfPresent(type, forKey: key) ?? .init(wrappedValue: nil)
            }
            """,
        ]
    }
}
