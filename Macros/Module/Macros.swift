import Foundation
import SwiftSyntax

@freestanding(declaration, names: arbitrary)
public macro dayStringCodablePropertyWrapper(typeName: String, formatter: DateFormatter) = #externalMacro(module: "DayTypeMacroImplementations", type: "CodableWrapperMacro")

@freestanding(declaration, names: arbitrary)
public macro epochCodablePropertyWrapper(typeName: String, milliseconds: Bool) = #externalMacro(module: "DayTypeMacroImplementations", type: "EpochWrapperMacro")

@freestanding(declaration, names: arbitrary)
public macro ios8601CodablePropertyWrapper(typeName: String, formatter: ISO8601DateFormatter) = #externalMacro(module: "DayTypeMacroImplementations", type: "ISO8601WrapperMacro")

@attached(member, names: named(decode), named(encode))
public macro OptionalDayCodable(argumentName: String, argumentType: Any.Type) = #externalMacro(module: "DayTypeMacroImplementations", type: "OptionalDayCodableMacro")

