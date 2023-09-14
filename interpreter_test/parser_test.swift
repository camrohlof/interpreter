//
//  parser_test.swift
//  interpreter_test
//
//  Created by Cameron Rohlof on 9/14/23.
//

import XCTest

final class parser_test: XCTestCase {

    func testLetStatements() throws{
        let input = """
        let x = 5;
        let y = 10;
        let foobar = 838383;
        """
        
        let lexer = Lexer(input: input)
        var parser = Parser(lexer: lexer)
        let program = parser.parseProgram()
        XCTAssertNotNil(program)
        if let program = parser.parseProgram(){
            XCTAssertEqual(program.statements.count, 3)
        }
        
        let expectedIdentifiers: [String] = [
            "x",
            "y",
            "foobar"
        ]
        
        for (i,expectedIdentifier) in expectedIdentifiers.enumerated() {
            if let stmt = program?.statements[i] {
                if !testLetStatement(stmt, expectedIdentifier){
                    return
                }
            }
        }
    }
    
    func testLetStatement(_ stmt: Statement, _ name: String)->Bool{
        guard stmt.tokenLiteral() == "let" else{
            XCTFail("tokenLiteral not 'let', got \(stmt.tokenLiteral())")
            return false
        }
        
        guard stmt is LetStatement else{
            XCTFail("expected let statement, got\(stmt)")
            return false
        }
        
        guard (stmt as! LetStatement).name?.value == name else{
            return false
        }
        
        guard (stmt as! LetStatement).tokenLiteral() == name else{
            return false
        }
        return true
    }
}

