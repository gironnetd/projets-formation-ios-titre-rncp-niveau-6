//
//  ArithmeticExpression.swift
//  CountOnMe
//
//  Created by damien on 14/06/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

struct ArithmeticExpression {
    
    private var elements: [ArithmeticElement] = []

    // Error check computed variables
    private var isCorrect: Bool {
        switch elements.last {
        case .addition, .substraction, .division, .multiplication, nil:
            return false
        default:
            return true
        }
    }
    
    private var haveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    private var canAddOperator: Bool {
        switch elements.last {
        case .addition, .substraction, .division, .multiplication, nil:
            return false
        default:
            return true
        }
    }
    
    private var haveResult: Bool {
        return elements.contains(.evaluation)
    }
    
    mutating func clear() {
        elements.removeAll()
    }
    
    mutating func addNumber(number: Double) throws {
        guard !haveResult else {
            clear()
            elements.append(.number(number))
            throw ArithmeticError.ExpressionHaveResult(elements)
        }
        
        switch elements.last {
        case .number (let lastElement):
            elements.remove(at: elements.endIndex - 1)
            elements.append(.number((lastElement * 10) + number))
            
            if haveEnoughElement {
                switch elements[elements.endIndex - 2] {
                case let .addition (left, _):
                    elements[elements.endIndex - 2] = .addition(left, .number(try elements[elements.endIndex - 1].evaluate()))
                case let .substraction (left, _):
                    elements[elements.endIndex - 2] = .substraction(left, .number(try elements[elements.endIndex - 1].evaluate()))
                case let .division (left, _):
                    elements[elements.endIndex - 2] = .division(left, .number(try elements[elements.endIndex - 1].evaluate()))
                case let .multiplication (left, _):
                    elements[elements.endIndex - 2] = .multiplication(left, .number(try elements[elements.endIndex - 1].evaluate()))
                default:
                    throw ArithmeticError.ExpressionIsIncorrect(elements)
                }
            }
            
        case let .addition (left, _):
            elements[elements.endIndex - 1] = .addition(left, .number(number))
            elements.append(.number(number))
        case let .substraction (left, _):
            elements[elements.endIndex - 1] = .substraction(left, .number(number))
            elements.append(.number(number))
        case let .division (left, _):
            elements[elements.endIndex - 1] = .division(left, .number(number))
            
            if haveEnoughElement {
                switch elements[elements.endIndex - 3] {
                case let .addition (left, _):
                    elements[elements.endIndex - 3] = .addition(left, .number(try elements[elements.endIndex - 1].evaluate()))
                case let .substraction (left, _):
                    elements[elements.endIndex - 3] = .substraction(left, .number(try elements[elements.endIndex - 1].evaluate()))
                default:
                    break
                }
            }
            
            elements.append(.number(number))
        case let .multiplication (left, _):
            elements[elements.endIndex - 1] = .multiplication(left, .number(number))
            
            if haveEnoughElement {
                switch elements[elements.endIndex - 3] {
                case let .addition (left, _):
                    elements[elements.endIndex - 3] = .addition(left, .number(try elements[elements.endIndex - 1].evaluate()))
                case let .substraction (left, _):
                    elements[elements.endIndex - 3] = .substraction(left, .number(try elements[elements.endIndex - 1].evaluate()))
                default:
                    break
                }
            }
        
            elements.append(.number(number))
        default:
            elements.append(.number(number))
        }
    }
    
    mutating func addOperator(arithmeticOperator: String) throws {
        guard let lastElement = elements.last else {
            throw ArithmeticError.ExpressionIsIncorrect(elements)
        }
        
        guard canAddOperator else {
            throw ArithmeticError.CannotAddOperator(elements)
        }
        
        let newElement = ArithmeticElement(rawValue: (arithmeticOperator, lastElement, .none))
        
        if haveEnoughElement {
            switch newElement {
            case .addition, .substraction:
                let finalElement = ArithmeticElement(rawValue: (arithmeticOperator, .number(try elements[elements.endIndex - 2].evaluate()), .none))
                elements.append(finalElement)
                return
            case .division, .multiplication:
                switch elements[elements.endIndex - 2] {
                case .division, .multiplication :
                    let finalElement = ArithmeticElement(rawValue: (arithmeticOperator, .number(try elements[elements.endIndex - 2].evaluate()), .none))
                    elements.append(finalElement)
                    return
                default:
                    break
                }
            default:
                break
            }
        }
        
        guard newElement != .none else {
            throw ArithmeticError.UnknownOperator(elements)
        }
        
        elements.append(newElement)
    
        guard !haveResult else {
            if let firstIndex = elements.firstIndex(of: .evaluation) {
                elements.removeSubrange(0...firstIndex)
            }
            throw ArithmeticError.ExpressionHaveResult(elements)
        }
    }
    
    @discardableResult
    mutating func evaluate() throws -> String {
        guard haveEnoughElement else {
            if let firstIndex = elements.firstIndex(of: .evaluation) {
                elements.removeSubrange(0...firstIndex)
            }
            throw ArithmeticError.ExpressionHaveNotEnoughElement(elements)
        }
        
        guard isCorrect else {
            throw ArithmeticError.ExpressionIsIncorrect(elements)
        }
        
        // Create local copy of operations
        var operationsToReduce = elements
        
        var result: Double = 0.0
    
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            
            let leftIndex: Int
            var operandIndex: Int
            let rightIndex: Int
            
            let operand: ArithmeticElement
            
            if let priorityIndex = try operationsToReduce.firstIndex(where: { element in
                switch element {
                case .multiplication(_, _):
                    return true
                case let .division(_, right):
                    if try right.evaluate() == 0 {
                        elements.append(.evaluation)
                        throw ArithmeticError.DivisionByZero(elements)
                    }
                    return true
                default:
                    return false
                }
            }) {
                operandIndex = priorityIndex
            } else {
               operandIndex = 1
            }
        
            leftIndex = operandIndex - 1
            rightIndex = operandIndex + 1
            
            operand = operationsToReduce[operandIndex]
        
            result = try operand.evaluate()
            
            operationsToReduce.remove(at: rightIndex)
            operationsToReduce.remove(at: operandIndex)
            operationsToReduce.remove(at: leftIndex)
            operationsToReduce.insert(.number(result), at: leftIndex)
        }
        
        elements.removeAll()
        elements.append(.evaluation)
        elements.append(.number(result))
        
        return "\(result)"
    }
}
