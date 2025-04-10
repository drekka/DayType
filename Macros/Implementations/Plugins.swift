import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MyMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        CodableWrapperMacro.self,
        EpochWrapperMacro.self,
        ISO8601WrapperMacro.self,
        OptionalDayCodableMacro.self
    ]
}
