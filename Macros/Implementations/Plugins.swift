import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MyMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        FormattedStringPropertyWrapperMacro.self,
        EpochPropertyWrapperMacro.self,
        KeyedContainerDecodeMissingDayStringMacro.self,
        KeyedContainerEncodeMissingDayStringMacro.self,
        KeyedContainerDecodeMissingEpochMacro.self,
        KeyedContainerEncodeMissingEpochMacro.self,
    ]
}
