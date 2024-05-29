//
//  ArithmeticError.swift
//  CountOnMe
//
//  Created by damien on 15/06/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum ArithmeticError: RawRepresentable, Error, Equatable {
    
    typealias RawValue = (title: String,message: String, expression: [ArithmeticElement])
    
    init?(rawValue: (title: String, message: String, expression: [ArithmeticElement])) {
        switch rawValue.message {
        case Constants.divisionByZeroIsImpossible:
            self = .DivisionByZero(rawValue.expression)
        case Constants.expressionIsIncorrect:
            self = .ExpressionIsIncorrect(rawValue.expression)
        case Constants.expressionHaveNotEnoughElement:
            self = .ExpressionHaveNotEnoughElement(rawValue.expression)
        case Constants.expressionHaveResult:
            self = .ExpressionHaveResult(rawValue.expression)
        case Constants.cannotAddOperator:
            self = .CannotAddOperator(rawValue.expression)
        case Constants.unknownOperator:
            self = .UnknownOperator(rawValue.expression)
        default:
            self = .None
        }
    }
    
    var rawValue: (title: String,message: String, expression: [ArithmeticElement]) {
        switch self {
        case .DivisionByZero (let expression):
            return (Constants.titleDivisionByZero, Constants.divisionByZeroIsImpossible, expression)
        case .ExpressionIsIncorrect (let expression):
            return (Constants.titleExpressionIsIncorrect, Constants.expressionIsIncorrect, expression)
        case .ExpressionHaveNotEnoughElement (let expression):
            return (Constants.titleExpressionHaveNotEnoughElement, Constants.expressionHaveNotEnoughElement, expression)
        case .ExpressionHaveResult (let expression):
            return (Constants.titleExpressionHaveResult, Constants.expressionHaveResult, expression)
        case .CannotAddOperator (let expression):
            return (Constants.titleCannotAddOperator, Constants.cannotAddOperator, expression)
        case .UnknownOperator (let expression):
            return (Constants.titleUnknownOperator, Constants.unknownOperator, expression)
        case .None:
            return ("", "", [])
        }
    }
    
    case None
    case DivisionByZero([ArithmeticElement])
    case ExpressionIsIncorrect([ArithmeticElement])
    case ExpressionHaveNotEnoughElement([ArithmeticElement])
    case ExpressionHaveResult([ArithmeticElement])
    case CannotAddOperator([ArithmeticElement])
    case UnknownOperator([ArithmeticElement])
}

extension ArithmeticError: CaseIterable {
    static var allCases: [ArithmeticError] {
            return [.None, .DivisionByZero([]), .ExpressionIsIncorrect([]),
                    .ExpressionHaveNotEnoughElement([]), .ExpressionHaveResult([]),
                    .CannotAddOperator([]), .UnknownOperator([])
            ]
        }
}

