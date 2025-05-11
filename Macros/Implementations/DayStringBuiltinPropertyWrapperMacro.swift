import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Adds a static embedeed type for encoding and decoding using a passed formatter.
struct DayStringBuiltinPropertyWrapperMacro: MemberMacro {

    static func expansion(
        of node: AttributeSyntax,
        providingMembersOf _: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        guard let typeName = node.arguments?.stringArgumentValue("name"),
              let formatter = node.arguments?.argumentValue("formatter")
        else {
            context.diagnose(Diagnostic(
                node: node, message: MacroExpansionErrorMessage("typeName, formatter or writeNulls argument not supplied. Passed arguments: \(node.arguments?.description ?? "")")
            ))
            return []
        }

        let withNullableImplementation = (node.arguments?.argumentValue("withNullableImplementation") ?? "true") == "true"

        return [
            DeclSyntax(stringLiteral: propertyWrapper(name: typeName, formatter: formatter, withNullableImplementation: withNullableImplementation)),
        ]
    }

    private static func propertyWrapper(name: String, formatter: String, withNullableImplementation: Bool) -> String {
        let writeNulls = withNullableImplementation ? "false" : "true"
        return """
        @propertyWrapper 
        public struct \(name): Codable {

            \(withNullableImplementation ? propertyWrapper(name: "WritesNulls", formatter: formatter, withNullableImplementation: false) : "")

            public var wrappedValue: DayType
            // We need to expose these values so keyed containers can access them.
            let formatter = \(formatter)
            let writeNulls = \(writeNulls)

            public init(wrappedValue: DayType) {
                self.wrappedValue = wrappedValue
            }

            public init(from decoder: Decoder) throws {
                wrappedValue = try DayType.decode(from: try decoder, formatter: \(formatter))
            }

            public func encode(to encoder: Encoder) throws {
                try wrappedValue.encode(into: encoder, formatter: \(formatter), writeNulls: \(writeNulls))
            }
        }
        """
    }
}
