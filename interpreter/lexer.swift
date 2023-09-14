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
                return .equal
            }else{
                return .assign
            }
            case "+": return .plus
            case "-": return .minus
            case "/": return .slash
            case "!": 
                if self.peekChar() == "="{
                    currentIndex = input.index(after: currentIndex)
                    return .notEqual
                }else{
                    return .bang
                }
            case "*": return .asterisk
            case "<": return .lessThan
            case ">": return .greaterThan
            case "(": return .lParen
            case ")": return .rParen
            case "{": return .lSquirly
            case "}": return .rSquirly
            case ",": return .comma
            case ";": return .semi
            case let char where char.isLetter:
                let ident = input.identifier(from: currentIndex)
                currentIndex = input.index(currentIndex, offsetBy: (ident.count - 1))
                return keywords[ident, default: .ident(ident)]
            case let char where char.isNumber:
                let numString = input.numberString(from: currentIndex)
                guard let num = Int(numString) else {
                    return .illegal(numString)
                }
                currentIndex = input.index(currentIndex, offsetBy: numString.count - 1)
                return .int(num)
            default:
                return .illegal(String(currentChar))
        }
    }
}
