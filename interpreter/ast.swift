//
//  ast.swift
//  interpreter
//
//  Created by Cameron Rohlof on 9/13/23.
//

import Foundation

protocol Node: CustomStringConvertible {
    func tokenLiteral()-> String?
}

protocol Statement:Node {
    func statementNode()
}

protocol Expression:Node{
    func expressionNode()
}

struct Program:Node {
    var statements: [Statement]
    
    var description: String {
        var out: String = ""
        for statement in statements{
            out.append(String(describing: statement) + " ")
        }
        return out
    }
    
    func tokenLiteral() ->String?{
        if self.statements.count > 0{
            return self.statements[0].tokenLiteral()
        }else{
            return ""
        }
    }
}

struct LetStatement: Statement{
    var token: Token?
    var name: Identifier?
    var value: Expression?
    
    var description: String {
        var out: String = ""
        
        out.append(self.tokenLiteral()!+" ")
        out.append(self.name!.value)
        out.append(" = ")
        
        if let val = value{
            out.append(val.description)
        }
        
        out.append(";")
        
        return out
    }
    
    func statementNode() {
        return
    }
    
    func tokenLiteral() -> String? {
        return self.token!.literal!
    }
}

struct ReturnStatement: Statement{
    var token: Token?
    var returnValue: Expression?
    
    var description: String{
        var out: String = ""
        
        out.append(tokenLiteral()! + " ")
        
        if let rv = returnValue{
            out.append(rv.description)
        }
        
        out.append(";")
        
        return out
    }
    
    func statementNode() {
        return
    }
    
    func tokenLiteral() -> String?{
        return self.token!.literal
    }
}

struct ExpressionStatement: Statement{
    var token: Token?
    var expression: Expression?
    
    var description: String{
        if let ex = expression{
            return ex.description
        }else{
            return ""
        }
    }
    
    func statementNode() {
        return
    }
    
    func tokenLiteral() -> String? {
        return self.token!.literal
    }
    
}

struct Identifier: Expression{
    var token: Token
    var value: String
    
    var description: String{
        return value
    }
    
    func expressionNode() {
        return
    }
    
    func tokenLiteral() -> String? {
        return self.token.literal
    }
}

struct IntegerLiteral: Expression{
    var token: Token
    var value: Int?
    
    func expressionNode() {
        return
    }
    
    func tokenLiteral() -> String? {
        return self.token.literal
    }
    
    var description: String{
        return self.token.literal!
    }
}

struct PrefixExpression: Expression{
    var token: Token
    var operatr: String
    var right: Expression?
    
    func expressionNode() {
        return
    }
    
    func tokenLiteral() -> String? {
        return self.token.literal
    }
    
    var description: String{
        return "(\(self.operatr)\(self.right!.description))"
    }
}

struct InfixExpression: Expression{
    var token: Token
    var left: Expression?
    var operatr: String
    var right: Expression?
    
    func expressionNode() {
        return
    }
    
    func tokenLiteral() -> String? {
        return self.token.literal
    }
    
    var description: String{
        return "(\(self.left!.description) \(self.operatr) \(self.right!.description))"
    }
}
