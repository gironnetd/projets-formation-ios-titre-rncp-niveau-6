//
//  ArithmeticElement.swift
//  CountOnMe
//
//  Created by damien on 18/06/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum ArithmeticElement: RawRepresentable, Equatable {
    
    init(rawValue: (arithmeticOperator: String,left: ArithmeticElement, right: ArithmeticElement)) {
        switch rawValue.arithmeticOperator {
        case "+":
            self = .addition(rawValue.left, rawValue.right)
        case "-":
            self = .substraction(rawValue.left, rawValue.right)
        case "/":
            self = .division(rawValue.left, rawValue.right)
        case "*":
            self = .multiplication(rawValue.left, rawValue.right)
        default:
            self = .none
        }
    }
    
    var rawValue: (arithmeticOperator: String,left: ArithmeticElement, right: ArithmeticElement) {
        switch self {
        case let .addition (left, right):
            return ("+", left, right)
        case let .substraction (left, right):
            return ("-", left, right)
        case let .division (left, right):
            return ("/", left, right)
        case let .multiplication (left, right):
            return ("*", left, right)
        case let .number(double):
            return ("\(double)", .none, .none)
        case .evaluation:
            return ("=", .none, .none)
        default:
            return ("", .none, .none)
        }
    }
    
    typealias RawValue = (arithmeticOperator: String,left: ArithmeticElement, right: ArithmeticElement)
    
    case number(Double)
    case none
    case evaluation
    indirect case addition(ArithmeticElement, ArithmeticElement)
    indirect case substraction(ArithmeticElement, ArithmeticElement)
    indirect case division(ArithmeticElement, ArithmeticElement)
    indirect case multiplication(ArithmeticElement, ArithmeticElement)
    
    func evaluate() throws -> Double {
        switch self {
        case let .number(value):
            return value
        case let .addition(left, right):
            return try left.evaluate() + right.evaluate()
        case let .substraction(left, right):
            return try left.evaluate() - right.evaluate()
        case let .multiplication(left, right):
            return try left.evaluate() * right.evaluate()
        case let .division(left, right):
            return try left.evaluate() / right.evaluate()
        default:
            return 0.0
        }
    }
}

extension ArithmeticElement: CaseIterable {
    static var allCases: [ArithmeticElement] {
        return [.number(0.0), .addition(.none, .none), .substraction(.none, .none),
                    .multiplication(.none, .none), .division(.none, .none),
                    .none, .evaluation
            ]
        }
}
