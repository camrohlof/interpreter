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
            case .return: return self.parseReturnStatement()
            default: return nil
        }
    }
    
    mutating func parseLetStatement() -> LetStatement?{
        var stmt = LetStatement(token: self.curToken)
    
        if case .ident = self.peekToken{
            self.next()
        }else{
            return nil
        }
        
        stmt.name = Identifier(token: self.curToken!, value: self.curToken!.literal)

        if case .assign = self.peekToken{
            self.next()
        }else{
            return nil
        }
        
        while !self.curTokenIs(Token.semi){
            self.next()
        }
        return stmt
    }
    
    mutating func parseReturnStatement() -> ReturnStatement{
        let stmt = ReturnStatement(token: self.curToken)
        
        self.next()
        
        while !self.curTokenIs(.semi){
            self.next()
        }
        return stmt
    }
    
    func curTokenIs(_ t: Token)->Bool{
        if case self.curToken = t{
            return true
        }else{
            return false
        }
    }
    
}
