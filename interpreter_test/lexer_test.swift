//
//  lexer_test.swift
//  interpreter_test
//
//  Created by Cameron Rohlof on 9/14/23.
//

import XCTest

final class lexer_test: XCTestCase {

    func testNextToken(){
        let input = """
            let five = 5;
            let ten = 10;
            
            let add = fn(x,y){
                x+y;
            };
            
            let result = add(five,ten);
            !-/*5;
            5<10>5;
            
            if(5<10){
                return true;
            }else{
                return false;
            }
            10 == 10;
            10 != 9;
            """
        
        let expectedTokens: [Token] = [
            Token(type: .let, literal: "let"),
            Token(type: .ident, literal: "five"),
            Token(type: .assign, literal: "="),
            Token(type: .int, literal: "5"),
            Token(type: .semi, literal: ";"),
            Token(type: .let, literal: "let"),
            Token(type: .ident, literal: "ten"),
            Token(type: .assign, literal: "="),
            Token(type: .int, literal: "10"),
            Token(type: .semi, literal: ";"),
            Token(type: .let, literal: "let"),
            Token(type: .ident, literal: "add"),
            Token(type: .assign, literal: "="),
            Token(type: .function, literal: "fn"),
            Token(type: .lParen, literal: "("),
            Token(type: .ident, literal: "x"),
            Token(type: .comma, literal: ","),
            Token(type: .ident, literal: "y"),
            Token(type: .rParen, literal: ")"),
            Token(type: .lSquirly, literal: "{"),
            Token(type: .ident, literal: "x"),
            Token(type: .plus, literal: "+"),
            Token(type: .ident, literal: "y"),
            Token(type: .semi, literal: ";"),
            Token(type: .rSquirly, literal: "}"),
            Token(type: .semi, literal: ";"),
            Token(type: .let, literal: "let"),
            Token(type: .ident, literal: "result"),
            Token(type: .assign, literal: "="),
            Token(type: .ident, literal: "add"),
            Token(type: .lParen, literal: "("),
            Token(type: .ident, literal: "five"),
            Token(type: .comma, literal: ","),
            Token(type: .ident, literal: "ten"),
            Token(type: .rParen, literal: ")"),
            Token(type: .semi, literal: ";"),
            Token(type: .bang, literal: "!"),
            Token(type: .minus, literal: "-"),
            Token(type: .slash, literal: "/"),
            Token(type: .asterisk, literal: "*"),
            Token(type: .int, literal: "5"),
            Token(type: .semi, literal: ";"),
            Token(type: .int, literal: "5"),
            Token(type: .lessThan, literal: "<"),
            Token(type: .int, literal: "10"),
            Token(type: .greaterThan, literal: ">"),
            Token(type: .int, literal: "5"),
            Token(type: .semi, literal: ";"),
            Token(type: .if, literal: "if"),
            Token(type: .lParen, literal: "("),
            Token(type: .int, literal: "5"),
            Token(type: .lessThan, literal: "<"),
            Token(type: .int, literal: "10"),
            Token(type: .rParen, literal: ")"),
            Token(type: .lSquirly, literal: "{"),
            Token(type: .return, literal: "return"),
            Token(type: .true, literal: "true"),
            Token(type: .semi, literal: ";"),
            Token(type: .rSquirly, literal: "}"),
            Token(type: .else, literal: "else"),
            Token(type: .lSquirly, literal: "{"),
            Token(type: .return, literal: "return"),
            Token(type: .false, literal: "false"),
            Token(type: .semi, literal: ";"),
            Token(type: .rSquirly, literal: "}"),
            Token(type: .int, literal: "10"),
            Token(type: .equal, literal: "=="),
            Token(type: .int, literal: "10"),
            Token(type: .semi, literal: ";"),
            Token(type: .int, literal: "10"),
            Token(type: .notEqual, literal: "!="),
            Token(type: .int, literal: "9"),
            Token(type: .semi, literal: ";"),
            Token(type: .eof, literal: ""),
        ]
        
        var lexer = Lexer(input: input)
        
        for expectedToken in expectedTokens{
            let nextToken = lexer.next()
            if nextToken == nil{break}
            XCTAssertEqual(nextToken, expectedToken)
        }
    }

}
