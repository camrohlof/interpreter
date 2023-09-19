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
        
        let parser = Parser(lexer: Lexer(input: input))
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
            XCTFail("tokenLiteral not 'let', got \(String(describing: stmt.tokenLiteral()))")
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
        let parser = Parser(lexer: Lexer(input: input))
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
                XCTFail("returnStmt.TokenLiteral not 'return'. got \(String(describing: statement.tokenLiteral()))")
                continue
            }
        }
    }
    
    func testIdentifierExpression() throws{
        let input = "foobar;"
        
        let parser = Parser(lexer:Lexer(input:input))
        let program = parser.parseProgram()
        
        if let p = program{
            XCTAssertEqual(p.statements.count, 1, "not enough statements, got \(p.statements.count)")

            XCTAssert(p.statements[0] is ExpressionStatement, "not an expression")
            
            let stmt = p.statements[0] as? ExpressionStatement
            
            XCTAssert(stmt?.expression is Identifier, "expression not identifier")
            
            let ident = stmt?.expression as? Identifier
            guard ident?.value == "foobar" else{
                XCTFail("value isn't foobar")
                return
            }
            XCTAssertEqual(ident?.value, "foobar", "value isn't foobar")
           
            XCTAssertEqual(ident?.tokenLiteral(), "foobar", "token literal isnt foobar")
        }else{
            XCTFail("program not parsed")
        }
    }
    
    func testIntegerLiteralExpression() throws{
        let input = "5"
        
        let parser = Parser(lexer:Lexer(input: input))
        let program = parser.parseProgram()
        CheckParserErrors(parser: parser)
        
        if let p = program{
            XCTAssertEqual(p.statements.count, 1, "program has not enough statements")
            
            XCTAssert(p.statements[0] is ExpressionStatement, "not an expression statement")
            
            let stmt = p.statements[0] as? ExpressionStatement;

            XCTAssert(stmt?.expression is IntegerLiteral, "not an Integer literal")
            
            let literal = stmt?.expression as? IntegerLiteral
            
            guard literal!.value == 5 else{
                XCTFail("int value not 5")
                return
            }
            guard literal!.tokenLiteral() == "5" else{
                XCTFail("literal value not '5'")
                return
            }
        }else{
            XCTFail("program not parsed")
        }
    }
    
    func testParsingPrefixExpressions() throws{
        struct PrefixTest {
            var input: String
            var operatr: String
            var integerValue: Int
            
            init(_ input: String, _ operatr: String, _ integerValue: Int) {
                self.input = input
                self.operatr = operatr
                self.integerValue = integerValue
            }
        }
        let prefixTests: [PrefixTest] = [
            PrefixTest("!5", "!", 5),
            PrefixTest("-15", "-", 15)
        ]
        
        for ptest in prefixTests{
            let parser = Parser(lexer: Lexer(input: ptest.input))
            let program = parser.parseProgram()
            
            if let p = program{
                guard p.statements.count == 1 else{
                    XCTFail("program.Statements does not contain 1 statement. got \(p.statements.count)")
                    return
                }
                let stmt = p.statements[0] as? ExpressionStatement
                if let exp = stmt?.expression as? PrefixExpression{
                    XCTAssertEqual(exp.operatr, ptest.operatr)
                    XCTAssertTrue(TestIntegerLiteral(exp.right!, ptest.integerValue))
                }
            }else{
                XCTFail("program not parsed")
            }
        }
    }
    
    func TestIntegerLiteral(_ il: Expression, _ val: Int)-> Bool{
        if let integ = il as? IntegerLiteral{
            guard integ.value == val else{
                return false
            }
            guard integ.tokenLiteral() == String(val) else{
                return false
            }
            return true
        }else{
            return false
        }
    }
    
    func testParsingInfixExpressions(){
        struct InfixTest{
            var input: String
            var leftValue: Int
            var operatr: String
            var rightValue: Int
            
            init(_ input: String,_ leftValue: Int,_ operatr: String,_ rightValue: Int) {
                self.input = input
                self.leftValue = leftValue
                self.operatr = operatr
                self.rightValue = rightValue
            }
        }
        let infixTests: [InfixTest] = [
            InfixTest("5 + 5;", 5, "+", 5),
            InfixTest("5 - 5;", 5, "-", 5),
            InfixTest("5 * 5;", 5, "*", 5),
            InfixTest("5 / 5;", 5, "/", 5),
            InfixTest("5 > 5;", 5, ">", 5),
            InfixTest("5 < 5;", 5, "<", 5),
            InfixTest("5 == 5;", 5, "==", 5),
            InfixTest("5 != 5;", 5, "!=", 5),
        ]
        
        for testi in infixTests{
            let parser = Parser(lexer: Lexer(input: testi.input))
            CheckParserErrors(parser: parser)
            
            if let program = parser.parseProgram(){
                guard program.statements.count == 1 else{
                    XCTFail("not enough statements")
                    return
                }
            }
            
            
            
        }
    }
}

