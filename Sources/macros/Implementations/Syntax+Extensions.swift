import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

extension AttributeSyntax.Arguments {

    func argumentValue(_ key: String) -> String? {
        asLabeledExpressionList?.argumentValue(key)
    }

    func stringArgumentValue(_ key: String) -> String? {
        asLabeledExpressionList?.stringArgumentValue(key)
    }

    func typeArgumentValue(_ key: String) -> String? {
        asLabeledExpressionList?.typeArgumentValue(key)
    }

    private var asLabeledExpressionList: LabeledExprListSyntax? {
        self.as(LabeledExprListSyntax.self)
    }
}

extension LabeledExprListSyntax {

    func argumentValue(_ key: String) -> String? {
        expression(key)?.trimmedDescription
    }

    func stringArgumentValue(_ key: String) -> String? {
        expression(key)?.as(StringLiteralExprSyntax.self)?.segments.trimmedDescription
    }

    func typeArgumentValue(_ key: String) -> String? {
        expression(key)?.as(MemberAccessExprSyntax.self)?.base?.trimmedDescription
    }

    private func expression(_ key: String) -> ExprSyntax? {
        first(where: { $0.label?.text == key })?.expression
    }
}
