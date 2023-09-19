//
//  lexer.swift
//  interpreter
//
//  Created by Cameron Rohlof on 9/1/23.
//

import Foundation

extension String{
    func identifier(from index: String.Index) -> String{
        var endIndex = self.index(after: index)
        while endIndex < self.endIndex && self[endIndex].isLetter{
            endIndex = self.index(after: endIndex)
        }
        return String(self[index..<endIndex])
    }
    
    func numberString(from index: String.Index) -> String{
        var endIndex = self.index(after: index)
        while endIndex < self.endIndex && self[endIndex].isNumber{
            endIndex = self.index(after: endIndex)
        }
        return String(self[index..<endIndex])
    }
}

struct Lexer: Sequence, IteratorProtocol{
    
    let input: String
    private var currentIndex: String.Index
    private var currentChar: Character { input[currentIndex] }
    private var keywords: [String : Token] = Token.defaultKeywords
    
    init(input: String) {
        self.input = input
        self.currentIndex = input.startIndex
    }
    
    func peekChar()-> Character{
        let tempIndex = input.index(after: currentIndex)
        return input[tempIndex]
    }
    
    public mutating func next() -> Token?{
        //eats whitespace
        while currentIndex < input.endIndex && currentChar.isWhitespace {
            currentIndex = input.index(after: currentIndex)
        }
        //checks for end of input
        guard currentIndex < input.endIndex else { return Optional.none}
        //Move to the next character after we have returned this token.
        defer {
            if currentIndex < input.endIndex {
                currentIndex = input.index(after: currentIndex)
            }
        }
        switch currentChar{
            case "=":
            if self.peekChar() == "="{
                currentIndex = input.index(after: currentIndex)
                return Token(type: .equal, literal:"==")
            }else{
                return Token(type:.assign, literal: "=")
            }
            case "+": return Token(type: .plus, literal: "+")
            case "-": return Token(type: .minus, literal: "-")
            case "/": return Token(type:.slash, literal: "/")
            case "!":
                if self.peekChar() == "="{
                    currentIndex = input.index(after: currentIndex)
                    return Token(type:.notEqual, literal: "!=")
                }else{
                    return Token(type: .bang, literal: "!")
                }
            case "*": return Token(type: .asterisk, literal: "*")
            case "<": return Token(type: .lessThan, literal: "<")
            case ">": return Token(type: .greaterThan, literal: ">")
            case "(": return Token(type: .lParen, literal: "(")
            case ")": return Token(type: .rParen, literal: ")")
            case "{": return Token(type: .lSquirly, literal: "{")
            case "}": return Token(type: .rSquirly, literal: "}")
            case ",": return Token(type: .comma, literal: ",")
            case ";": return Token(type: .semi, literal: ";")
            case let char where char.isLetter:
                let literal = input.identifier(from: currentIndex)
                currentIndex = input.index(currentIndex, offsetBy: (literal.count - 1))
                return keywords[literal, default:Token(type: .ident, literal: literal)]
            case let char where char.isNumber:
                let numString = input.numberString(from: currentIndex)
                guard let num = Int(numString) else {
                    return Token(type: .illegal, literal:numString)
                }
                currentIndex = input.index(currentIndex, offsetBy: numString.count - 1)
                return Token(type:.int, literal: String(num))
            default:
                return Token(type: .illegal, literal:String(currentChar))
        }
    }
}
