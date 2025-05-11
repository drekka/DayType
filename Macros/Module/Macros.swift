import Foundation

// MARK: - Type macros

@attached(member, names: arbitrary)
public macro DayStringBuiltin(name: String, formatter: DateFormatter, withNullableImplementation: Bool = true) = #externalMacro(module: "DayTypeMacroImplementations", type: "DayStringBuiltinPropertyWrapperMacro")

// Refactor these
@freestanding(declaration, names: arbitrary)
public macro epochCodablePropertyWrapper(typeName: String, milliseconds: Bool) = #externalMacro(module: "DayTypeMacroImplementations", type: "EpochWrapperMacro")

@freestanding(declaration, names: arbitrary)
public macro ios8601CodablePropertyWrapper(typeName: String, formatter: ISO8601DateFormatter) = #externalMacro(module: "DayTypeMacroImplementations", type: "ISO8601WrapperMacro")

// MARK: - Common macros

@attached(member, names: named(decode), named(encode))
public macro OptionalDayCodableImplementation(argumentName: String, argumentType: Any.Type) = #externalMacro(module: "DayTypeMacroImplementations", type: "OptionalDayCodableImplementationMacro")

// MARK: - Keyed containers

@attached(member, names: named(decode))
public macro DecodeMissing(type: Any.Type) = #externalMacro(module: "DayTypeMacroImplementations", type: "KeyedContainerDecodeMissingMacro")

@attached(member, names: named(encode))
public macro EncodeMissing(type: Any.Type) = #externalMacro(module: "DayTypeMacroImplementations", type: "KeyedContainerEncodeMissingMacro")


