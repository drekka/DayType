import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

struct KeyedContainerEncodeMissingEpochMacro: MemberMacro {

    static func expansion(
        of node: AttributeSyntax,
        providingMembersOf owningType: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        guard owningType.as(ExtensionDeclSyntax.self)?.extendedType.trimmedDescription == "KeyedEncodingContainer" else {
            context.diagnose(Diagnostic(
                node: node, message: MacroExpansionErrorMessage("Can only be used on a KeyedEncodingContainer: \(owningType.as(ExtensionDeclSyntax.self)?.extendedType.trimmedDescription ?? "")")
            ))
            return []
        }

        guard let encodableType = node.arguments?.typeArgumentValue("type") else {
            context.diagnose(Diagnostic(
                node: node, message: MacroExpansionErrorMessage("Unable to determine passed type argument from: \(node.arguments?.description ?? "")")
            ))
            return []
        }

        return [
            """
            /// Encoding must be handled by the keyed container or we end up writing keys with missing values.
            public mutating func encode(_ propertyWrapper: \(raw: encodableType), forKey key: Key) throws {
                if let value = propertyWrapper.wrappedValue {
                    try self.encode(value.date().timeIntervalSince1970 * (propertyWrapper.milliseconds ? 1000 : 1), forKey: key)
                } else if propertyWrapper.writeNulls {
                    try self.encodeNil(forKey: key)
                }
            }
            """,
        ]
    }
}
