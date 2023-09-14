//
//  ast.swift
//  interpreter
//
//  Created by Cameron Rohlof on 9/13/23.
//

import Foundation

protocol Node {
    func tokenLiteral()-> String
}

protocol Statement:Node {
    func statementNode()
}

protocol Expression:Node{
    func expressionNode()
}

struct Program:Node {
    var statements: [Statement]
    
    func tokenLiteral() ->String{
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
    
    func statementNode() {
        return
    }
    
    func tokenLiteral() -> String {
        return self.token!.literal
    }
}
struct Identifier: Expression{
    var token: Token
    var value: String
    
    func expressionNode() {
        return
    }
    
    func tokenLiteral() -> String {
        return self.token.literal
    }
}
