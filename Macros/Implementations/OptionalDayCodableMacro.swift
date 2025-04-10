import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

struct OptionalDayCodableMacro: MemberMacro {

    static func expansion(
        of node: AttributeSyntax,
        providingMembersOf _: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        guard let argumentName = node.arguments?.stringArgumentValue("argumentName"),
              let argumentType = node.arguments?.typeArgumentValue("argumentType") else {
            context.diagnose(Diagnostic(
                node: node, message: MacroExpansionErrorMessage("argumentName or argumentType not supplied. Passed arguments: \(node.arguments?.description ?? "")")
            ))
            return []
        }

        return [
            """
                public static func decode(using decoder: Decoder, \(raw: argumentName): \(raw: argumentType)) throws -> Day? {
                    let container = try decoder.singleValueContainer()
                    return container.decodeNil() ? nil : try Day.decode(using: decoder, \(raw: argumentName): \(raw: argumentName))
                }
            """,
            """
                public func encode(using encoder: Encoder, \(raw: argumentName): \(raw: argumentType)) throws {
                    if let self {
                        try self.encode(using: encoder, \(raw: argumentName): \(raw: argumentName))
                    } else {
                        var container = encoder.singleValueContainer()
                        try container.encodeNil()
                    }
                }
            """,
        ]
    }
}
