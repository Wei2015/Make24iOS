//
//  MathUtility.swift
//  Make24
//
//  Created by MacBookPro13 on 3/28/18.
//  Copyright © 2018 edu.sjsu.CMPE277. All rights reserved.
//

import Foundation

//generate an integer array with four random number between 1-9
func fourRandomNum() -> [Int] {
    var nums = [Int]()
    for _ in 0..<4 {
    nums.append(Int(arc4random_uniform(9))+1)
    }
    return nums
}

func getSolution(inputArray: [Int]) -> String {
    let o: [Character] = ["+", "-", "*", "/"]
    for w in 0..<4 {
        for x in 0..<4 {
            if (x==w) {
                continue
            }
            for y in 0..<4 {
                if (y==x || y == w){
                    continue
                }
                for z in 0..<4 {
                    if (z == w || z == x || z == y) {
                        continue
                    }
                    for i in 0..<4 {
                        for j in 0..<4{
                            for k in 0..<4 {
                                let result = eval(a:inputArray[w], b:inputArray[x], c:inputArray[y], d:inputArray[z], x:o[i], y:o[j],z:o[k])
                                if "" != result {
                                    return result
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return ""
}

func eval(a: Int, b: Int, c: Int, d: Int, x:Character, y:Character, z:Character) -> String {
    
    if (bingo(x: evalThree(a:evalThree(a:evalThree(a:Double(a),x:x,b:Double(b)),x:y,b:Double(c)),x:z,b:Double(d)))) {
            return "((" + String(a) + String(x) + String(b) + ")" + String(y) + String(c) + ")" + String(z) + String(d)
    }
    if (bingo(x: evalThree(a:evalThree(a:Double(a), x:x, b:evalThree(a:Double(b), x:y, b:Double(c))), x:z, b:Double(d)))) {
        return "(" + String(a) + String(x) + "(" + String(b) + String(y) + String(c) + "))" + String(z) + String(d)
    }
    if (bingo(x: evalThree(a:Double(a), x:x, b:evalThree(a:evalThree(a:Double(b), x:y, b:Double(c)), x:z, b:Double(d))))) {
        return "" + String(a) + String(x) + "((" + String(b) + String(y) + String(c) + ")" + String(z) + String(d) + ")"
    }
    if (bingo(x: evalThree(a:Double(a), x:x, b:evalThree(a:Double(b), x:y, b:evalThree(a:Double(c), x:z, b:Double(d)))))) {
        return "" + String(a) + String(x) + "(" + String(b) + String(y) + "(" + String(c) + String(z) + String(d) + ")" + ")"
    }
    if (bingo(x: evalThree(a:evalThree(a:Double(a), x:x, b:Double(b)), x:y, b:evalThree(a:Double(c), x:z, b:Double(d))))) {
        return "((" + String(a) + String(x) + String(b) + ")" + String(y) + "(" + String(c) + String(z) + String(d) + "))"
    }
    
    return ""

}

func bingo(x: Double) -> Bool {
    return abs(x-24)<0.0000001
}

func evalThree(a:Double, x:Character, b:Double)->Double {
    switch x {
    case "+":
        return a + b
    case "-":
        return a - b
    case "*":
        return a * b
    default:
        return a / b
    }
}

func checkValid(expression: String) -> Bool {
    if (Int(expression.count)<=7) {return false}
    
    if(expression[expression.startIndex] == "-" || expression[expression.startIndex] == "+" || expression[expression.startIndex] == "*" || expression[expression.startIndex] == "/"
        || expression[expression.startIndex] == ")") {return false}
    
    var isLeftPar = false
    var isLeftOp = false
    var lastNumIndex = false
    var parCount = 0
    
    for index in expression.indices {
        let current = expression[index]
        if (current == "(") {
            parCount += 1
            if isLeftPar {return false}
            if (lastNumIndex) {return false}
            isLeftOp = false
            isLeftPar = true
        } else if (current == ")") {
            if (parCount == 0) {return false}
            else { parCount -= 1}
            if (isLeftPar || isLeftOp) {return false}
            isLeftPar = true
            isLeftOp = false
        } else if (current == "-" || current == "+" || current == "*" || current == "/") {
            if (isLeftOp) {return false}
            if (isLeftPar && expression[expression.index(before:index)]=="(") {return false}
            isLeftOp = true
            isLeftPar = false
        } else {
            if (lastNumIndex) {return false}
            if (isLeftPar && expression[expression.index(before:index)]==")") {return false}
            lastNumIndex = true
            isLeftOp = false
            isLeftPar = false
        }
    }
    return true
}

