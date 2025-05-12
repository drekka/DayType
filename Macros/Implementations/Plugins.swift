import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MyMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        DayStringBuiltinPropertyWrapperMacro.self,
        EpochPropertyWrapperMacro.self,
        ISO8601WrapperMacro.self,
        KeyedContainerDecodeMissingDayStringMacro.self,
        KeyedContainerEncodeMissingDayStringMacro.self,
        KeyedContainerDecodeMissingEpochMacro.self,
        KeyedContainerEncodeMissingEpochMacro.self,
    ]
}
