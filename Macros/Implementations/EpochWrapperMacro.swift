import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

struct EpochWrapperMacro: DeclarationMacro {

    static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {

        guard let typeName = node.arguments.stringArgumentValue("typeName"),
              let milliseconds = node.arguments.argumentValue("milliseconds") else {
            context.diagnose(Diagnostic(
                node: node, message: MacroExpansionErrorMessage("typeName or milliseconds argument not supplied. Passed arguments \(node.arguments)")
            ))
            return []
        }

        return [
            """
            @propertyWrapper
            public struct \(raw: typeName): Codable {

                public var wrappedValue: DayType

                public init(wrappedValue: DayType) {
                    self.wrappedValue = wrappedValue
                }

                public init(from decoder: Decoder) throws {
                    wrappedValue = try DayType.decode(using: decoder, milliseconds: \(raw: milliseconds))
                }

                public func encode(to encoder: Encoder) throws {
                    try wrappedValue.encode(using: encoder, milliseconds: \(raw: milliseconds), writeNulls: false)
                }
            }
            """,
        ]
    }
}
