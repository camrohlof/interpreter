//
//  parser.swift
//  interpreter
//
//  Created by Cameron Rohlof on 9/13/23.
//

import Foundation

class Parser{
    var lexer: Lexer
    
    var curToken: Token?
    var peekToken: Token?
    var errors: [String]
    
    var prefixParseFns: [Token.TokenType: () -> Expression?]
    var infixParseFns: [Token.TokenType: (Expression) -> Expression]
    
    enum Priority: Int{
        case lowest = 1, equals, lessGreater, sum, product, prefix, call
    }
    
    let precedences: [Token.TokenType: Priority] = [
        .equal: .equals,
        .notEqual: .equals,
        .lessThan: .lessGreater,
        .greaterThan: .lessGreater,
        .plus: .sum,
        .minus: .sum,
        .slash: .product,
        .asterisk: .product,
    ]
    
    let infixTokenTypes: [Token.TokenType] = [
        .plus,
        .minus,
        .slash,
        .asterisk,
        .equal,
        .notEqual,
        .lessThan,
        .greaterThan
    ]
    
    init(lexer: Lexer) {
        self.lexer = lexer
        self.curToken = nil
        self.peekToken = nil
        self.errors = []
        
        self.prefixParseFns = [:]
        self.infixParseFns = [:]
        
        self.next()
        self.next()
        
        prefixParseFns.updateValue(parseIdentifier, forKey:Token.TokenType.ident)
        prefixParseFns.updateValue((parseIntegerLiteral), forKey:Token.TokenType.int)
        prefixParseFns.updateValue((parsePrefixExpression), forKey: Token.TokenType.bang)
        prefixParseFns.updateValue((parsePrefixExpression), forKey: Token.TokenType.minus)
    
        for tt in infixTokenTypes{
            infixParseFns.updateValue(parseInfixExpression, forKey: tt)
        }
        
        
    }
    
    func next(){
        self.curToken = self.peekToken
        self.peekToken = self.lexer.next()
    }
    
    func peekPrecedence() -> Priority{
        if let p = precedences[self.peekToken!.type]{
            return p
        }
        return .lowest
    }
    
    func curPrecedence() -> Priority{
        if let p = precedences[self.curToken!.type]{
            return p
        }
        return .lowest
    }
    
    func registerInfix(_ tokenType: Token.TokenType, _ fn:@escaping (Expression) -> Expression){
        self.infixParseFns[tokenType] = fn
    }
    
    func peekError(_ t: Token){
        let msg = "expected next token to be \(t), got \(self.peekToken!)"
        self.errors.append(msg)
    }
    
    func parseProgram() -> Program?{
        var program = Program(statements: [])
        while self.curToken != nil {
            if let stmt = self.parseStatement(){
                program.statements.append(stmt)
            }
            self.next()
        }
        
        return program
    }
    
    func parseStatement() -> Statement?{
        switch self.curToken?.type{
            case .let: return self.parseLetStatement()
            case .return: return self.parseReturnStatement()
            default: return self.parseExpressionStatement()
        }
    }
    
    func parseLetStatement() -> LetStatement?{
        var stmt = LetStatement(token: self.curToken)
    
        if case .ident = self.peekToken?.type{
            self.next()
        }else{
            return nil
        }
        
        stmt.name = Identifier(token: self.curToken!, value: self.curToken!.literal!)

        if case .assign = self.peekToken!.type{
            self.next()
        }else{
            return nil
        }
        
        while !self.curTokenIs(Token.TokenType.semi){
            self.next()
        }
        return stmt
    }
    
    func parseReturnStatement() -> ReturnStatement{
        let stmt = ReturnStatement(token: self.curToken)
        
        self.next()
        
        while !self.curTokenIs(Token.TokenType.semi){
            self.next()
        }
        return stmt
    }
    
    func parseExpressionStatement()-> ExpressionStatement{
        var stmt = ExpressionStatement(token: self.curToken)
        
        stmt.expression = self.parseExpression(priority: Priority.lowest)
        
        if self.peekToken?.type == Token.TokenType.semi{
            self.next()
        }
        
        return stmt
    }
    
    func parseExpression(priority: Priority) -> Expression?{
        var leftExp: Expression?
        if let prefix = self.prefixParseFns[self.curToken!.type]{
            leftExp = prefix()
            while self.peekToken != nil && self.peekToken!.type != .semi && priority.rawValue < self.peekPrecedence().rawValue{
                if let infix = self.infixParseFns[self.peekToken!.type]{
                    self.next()
                    leftExp = infix(leftExp!)
                }
            }
            return leftExp
        }
        self.noPrefixParseFnError(self.curToken!)
        return nil
    }
    
    func parseIdentifier() -> Expression{
        return Identifier(token: self.curToken!, value: self.curToken!.literal!)
    }
    
    func curTokenIs(_ t: Token.TokenType)->Bool{
        if case self.curToken?.type = t{
            return true
        }else{
            return false
        }
    }
    
    func parseIntegerLiteral() -> Expression?{
        var lit = IntegerLiteral(token: self.curToken!)
        
        if let value = Int(self.curToken!.literal!){
            lit.value = value
            return lit
        }else{
            let msg = "could not parse \(String(describing: self.curToken?.literal!)) as integer"
            self.errors.append(msg)
            return nil
        }
    }
    
    func parsePrefixExpression() -> Expression?{
        var expression = PrefixExpression(token: self.curToken!, operatr: self.curToken!.literal!)
        self.next()
        expression.right = self.parseExpression(priority: .prefix)
        return expression
    }
    
    func noPrefixParseFnError(_ t: Token){
        self.errors.append("no prefix parse function for \(t) found")
    }
    
    func parseInfixExpression(left: Expression)->Expression{
        var expression = InfixExpression(token: self.curToken!, left: left, operatr: self.curToken!.literal!)
        
        let precedence = self.curPrecedence()
        self.next()
        expression.right = self.parseExpression(priority: precedence)
        
        return expression
    }
}
