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
        
        var parser = Parser(lexer: Lexer(input: input))
        if let program = parser.parseProgram(){
            XCTAssertEqual(program.statements.count, 3)
            if program.statements.count != 3{
                return
            }
            let expectedIdentifiers: [String] = [
                "x",
                "y",
                "foobar"
            ]
            
            for (i,expectedIdentifier) in expectedIdentifiers.enumerated() {
                let stmt = program.statements[i]
                if !TestLetStatement(stmt, expectedIdentifier){
                    return
                }
                
            }
        }
    }
    
    func TestLetStatement(_ stmt: Statement, _ name: String)->Bool{
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
    
    func CheckParserErrors(parser: Parser){
        let errors = parser.errors
        guard errors.count > 0 else{
            return
        }
        XCTFail("parser had \(errors.count)")
        for error in errors{
            XCTFail("parser error: \(error)")
        }
    }
    
    func testReturnStatements() throws{
        let input =  """
            return 5;
            return 10;
            return 993322;
            """
        var parser = Parser(lexer: Lexer(input: input))
        let program = parser.parseProgram()
        CheckParserErrors(parser: parser)
        
        guard program?.statements.count == 3 else{
            XCTFail("program.Statements does not contain 3 statements. got \(program!.statements.count)")
            return
        }
        
        for statement in program!.statements{
            guard statement.self is ReturnStatement else{
                XCTFail("stmt not ReturnStatement. got \(statement)")
                continue
            }
            guard statement.tokenLiteral() == "return" else{
                XCTFail("returnStmt.TokenLiteral not 'return'. got \(statement.tokenLiteral())")
                continue
            }
        }
    }
}

