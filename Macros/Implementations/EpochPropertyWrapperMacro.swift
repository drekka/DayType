import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

struct EpochPropertyWrapperMacro: MemberMacro {

    static func expansion(
        of node: AttributeSyntax,
        providingMembersOf _: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        guard let typeName = node.arguments?.stringArgumentValue("typeName"),
              let milliseconds = node.arguments?.argumentValue("milliseconds") else {
            context.diagnose(Diagnostic(
                node: node, message: MacroExpansionErrorMessage("typeName or milliseconds argument not supplied. Passed arguments \(node.arguments?.description ?? "")")
            ))
            return []
        }

        let withNullableImplementation = (node.arguments?.argumentValue("withNullableImplementation") ?? "true") == "true"

        return [
            DeclSyntax(stringLiteral: propertyWrapper(name: typeName, milliseconds: milliseconds, withNullableImplementation: withNullableImplementation)),
        ]
    }

    private static func propertyWrapper(name: String, milliseconds: String, withNullableImplementation: Bool) -> String {
        let writeNulls = withNullableImplementation ? "false" : "true"
        return """
        @propertyWrapper
        public struct \(name): Codable {

            \(withNullableImplementation ? propertyWrapper(name: "Nullable", milliseconds: milliseconds, withNullableImplementation: false) : "")

            public var wrappedValue: DayType

            // We need to expose these values so keyed containers can access them.
            let writeNulls = \(writeNulls)
            let milliseconds = \(milliseconds)

            public init(wrappedValue: DayType) {
                self.wrappedValue = wrappedValue
            }

            public init(from decoder: Decoder) throws {
                wrappedValue = try DayType.decode(using: decoder, milliseconds: \(milliseconds))
            }

            public func encode(to encoder: Encoder) throws {
                try wrappedValue.encode(using: encoder, milliseconds: \(milliseconds), writeNulls: writeNulls)
            }
        }
        """
    }
}
