//
//  token.swift
//  interpreter
//
//  Created by Cameron Rohlof on 9/1/23.
//

import Foundation

struct Token: Hashable, Equatable{
    var type: TokenType
    var literal: String?
    
    enum TokenType{
        case illegal
        case ident
        case int
        case eof
        case comma
        case semi
        case plus
        case minus
        case bang
        case slash
        case asterisk
        case lessThan
        case greaterThan
        case assign
        case equal
        case notEqual
        case lParen
        case rParen
        case lSquirly
        case rSquirly
        case function
        case `let`
        case `true`
        case `false`
        case `if`
        case `else`
        case `return`
    }
    
    static var defaultKeywords: [String : Token] {
        return [
            "fn" : Token(type: .function, literal: "fn"),
            "let" : Token(type: .let, literal: "let"),
            "true" : Token(type: .true, literal: "true"),
            "false" : Token(type: .false, literal: "false"),
            "if" : Token(type: .if, literal: "if"),
            "else" : Token(type: .else, literal: "else"),
            "return" : Token(type: .return, literal: "return"),
        ]
    }

}
