import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

struct CodableWrapperMacro: DeclarationMacro {

    static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {

        guard let typeName = node.arguments.stringArgumentValue("typeName"),
              let formatter = node.arguments.argumentValue("formatter") else {
            context.diagnose(Diagnostic(
                node: node, message: MacroExpansionErrorMessage("typeName or formatter argument not supplied. Passed arguments \(node.arguments)")
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
                    wrappedValue = try DayType.decode(using: decoder, formatter: \(raw: formatter))
                }

                public func encode(to encoder: Encoder) throws {
                    try wrappedValue.encode(using: encoder, formatter: \(raw: formatter))
                }
            }
            """,
        ]
    }
}
