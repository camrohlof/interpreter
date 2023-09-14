//
//  repl.swift
//  interpreter
//
//  Created by Cameron Rohlof on 9/13/23.
//

import Foundation

let prompt = ">>"

struct REPL {
    
    func start(){
        while true {
            print(prompt, terminator: "")
            if let input = readLine(strippingNewline: true){
                if input == "quit" {
                    return
                }
                let lexer = Lexer(input: input)
                for token in lexer{
                    print("{\(token)}")
                }
            }else{
                return
            }
        }
    }
}
