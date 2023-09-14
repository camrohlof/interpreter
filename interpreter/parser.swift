//
//  parser.swift
//  interpreter
//
//  Created by Cameron Rohlof on 9/13/23.
//

import Foundation

struct Parser{
    var lexer: Lexer
    
    var curToken: Token?
    var peekToken: Token?
    var errors: [String]
    
    init(lexer: Lexer) {
        self.lexer = lexer
        self.curToken = nil
        self.peekToken = nil
        self.errors = []
        
        self.next()
        self.next()
    }
    
    mutating func next(){
        self.curToken = self.peekToken
        self.peekToken = self.lexer.next()
    }
    
    mutating func peekError(_ t: Token){
        let msg = "expected next token to be \(t), got \(self.peekToken!)"
        self.errors.append(msg)
    }
    
    mutating func parseProgram() -> Program?{
        var program = Program(statements: [])
        while self.curToken != nil {
            if let stmt = self.parseStatement(){
                program.statements.append(stmt)
            }
            self.next()
        }
        
        return program
    }
    
    mutating func parseStatement() -> Statement?{
        switch self.curToken{
            case .let: return self.parseLetStatement()
            default: return nil
        }
    }
    
    mutating func parseLetStatement() -> LetStatement?{
        var stmt = LetStatement(token: self.curToken)
        guard self.expectPeek(.ident("")) else{
            return nil
        }
        
        stmt.name = Identifier(token: self.curToken!, value: self.curToken!.literal)
        guard self.expectPeek(.assign) else{
            return nil
        }
        while !self.curTokenIs(Token.semi){
            self.next()
        }
        return stmt
    }
    
    func curTokenIs(_ t: Token) -> Bool{
        return self.curToken == t
    }
    
    func peekTokenIs(_ t: Token)-> Bool{
        return self.peekToken.self == t
    }
    
    mutating func expectPeek(_ t: Token) -> Bool{
        if self.peekTokenIs(t){
            self.next()
            return true
        }else{
            return false
        }
    }
}
