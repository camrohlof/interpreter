//
//  ast_test.swift
//  interpreter_test
//
//  Created by Cameron Rohlof on 9/15/23.
//

import XCTest

final class ast_test: XCTestCase {

    func testString() throws{
        let program = Program(statements: [
            LetStatement(token: Token.let, name: Identifier(token: Token.ident("myVar"), value:"myVar"), value: Identifier(token: Token.ident("anotherVar"), value: "anotherVar")),
        ])
        if program.description.compare("let myVar = anotherVar;") == .orderedSame{
            XCTFail("program.description wrong. got \(program.description)")
        }
    }

}
