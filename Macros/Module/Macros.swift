import Foundation

// MARK: - Type macros

@attached(member, names: arbitrary)
public macro DayStringPropertyWrapper(name: String, formatter: DateFormatter, withNullableImplementation: Bool = true) = #externalMacro(module: "DayTypeMacroImplementations", type: "FormattedStringPropertyWrapperMacro")

@attached(member, names: arbitrary)
public macro ISO8601PropertyWrapper(name: String, formatter: ISO8601DateFormatter, withNullableImplementation: Bool = true) = #externalMacro(module: "DayTypeMacroImplementations", type: "FormattedStringPropertyWrapperMacro")

// Refactor these
@attached(member, names: arbitrary)
public macro EpochPropertyWrapper(typeName: String, milliseconds: Bool, withNullableImplementation: Bool = true) = #externalMacro(module: "DayTypeMacroImplementations", type: "EpochPropertyWrapperMacro")

// MARK: - Common macros

@attached(member, names: named(decode), named(encode))
public macro OptionalDayCodableImplementation(argumentName: String, argumentType: Any.Type) = #externalMacro(module: "DayTypeMacroImplementations", type: "OptionalDayCodableImplementationMacro")

// MARK: - Keyed containers

@attached(member, names: named(decode))
public macro DecodeMissingString(type: Any.Type) = #externalMacro(module: "DayTypeMacroImplementations", type: "KeyedContainerDecodeMissingDayStringMacro")

@attached(member, names: named(encode))
public macro EncodeMissingString(type: Any.Type) = #externalMacro(module: "DayTypeMacroImplementations", type: "KeyedContainerEncodeMissingDayStringMacro")

@attached(member, names: named(decode))
public macro DecodeMissingEpoch(type: Any.Type) = #externalMacro(module: "DayTypeMacroImplementations", type: "KeyedContainerDecodeMissingEpochMacro")

@attached(member, names: named(encode))
public macro EncodeMissingEpoch(type: Any.Type) = #externalMacro(module: "DayTypeMacroImplementations", type: "KeyedContainerEncodeMissingEpochMacro")


