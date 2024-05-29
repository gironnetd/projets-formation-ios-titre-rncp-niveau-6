//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class SimpleCalcTests: XCTestCase {
    
    private lazy var expression: ArithmeticExpression = ArithmeticExpression()
    
    private lazy var formatter = NumberFormatter()

    private var firstValue: Double = 60
    private var secondValue: Double = 3
    private var thirdValue: Double = 3.55
    
    override func setUp() {
        expression = ArithmeticExpression()
        formatter.maximumFractionDigits =  2
    }
    
    override func tearDown() {
        expression.clear()
    }
    
    func test_GivenTwoNumberAndMakeAddition_WhenEvaluate_ThenAdditionIsCorrect() throws {
        // Given two Number and make addition
        try expression.addNumber(number: firstValue)
        try expression.addOperator(arithmeticOperator: "+")
        try expression.addNumber(number: secondValue)
        
        // When Evaluate
        // Then Addition Is Correct
        let actual = String(try expression.evaluate())
        let expected = String(firstValue + secondValue)
        XCTAssert(actual == expected)
    }
    
    func test_GivenOneNumberHigherThanTenAndAnotherAndMakeAddition_WhenEvaluate_ThenAdditionIsCorrect() throws {
        // Given One Number Higher Than Ten And Another And Make Addition
        try expression.addNumber(number:firstValue)
        try expression.addNumber(number: firstValue)
        
        try expression.addOperator(arithmeticOperator: "+")
        
        try expression.addNumber(number: secondValue)
        try expression.addNumber(number: secondValue)
        
        // When Evaluate
        // Then Addition Is Correct
        let actual = String(try expression.evaluate())
        let expected = String((firstValue * 10 + firstValue) + (secondValue * 10 + secondValue))
        XCTAssert(actual == expected)
    }
    
    func test_GivenOneNumberHigherThanTenAndAnotherAndMakeSubstraction_WhenEvaluate_ThenAdditionIsCorrect() throws {
        // Given One Number Higher Than Ten And Another And Make Addition
        try expression.addNumber(number:firstValue)
        try expression.addNumber(number: firstValue)
        
        try expression.addOperator(arithmeticOperator: "-")
        
        try expression.addNumber(number: secondValue)
        try expression.addNumber(number: secondValue)
        
        // When Evaluate
        // Then Addition Is Correct
        let actual = String(try expression.evaluate())
        let expected = String((firstValue * 10 + firstValue) - (secondValue * 10 + secondValue))
        XCTAssert(actual == expected)
    }
    
    func test_GivenOneNumberHigherThanTenAndAnotherAndMakeDivision_WhenEvaluate_ThenAdditionIsCorrect() throws {
        // Given One Number Higher Than Ten And Another And Make Addition
        try expression.addNumber(number:firstValue)
        try expression.addNumber(number: firstValue)
        
        try expression.addOperator(arithmeticOperator: "/")
        
        try expression.addNumber(number: secondValue)
        try expression.addNumber(number: secondValue)
        
        // When Evaluate
        // Then Addition Is Correct
        let actual = String(try expression.evaluate())
        let expected = String((firstValue * 10 + firstValue) / (secondValue * 10 + secondValue))
        XCTAssert(actual == expected)
    }
    
    func test_GivenOneNumberHigherThanTenAndAnotherAndMakeMultiplication_WhenEvaluate_ThenAdditionIsCorrect() throws {
        // Given One Number Higher Than Ten And Another And Make Addition
        try expression.addNumber(number:firstValue)
        try expression.addNumber(number: firstValue)
        
        try expression.addOperator(arithmeticOperator: "*")
        
        try expression.addNumber(number: secondValue)
        try expression.addNumber(number: secondValue)
        
        // When Evaluate
        // Then Addition Is Correct
        let actual = String(try expression.evaluate())
        let expected = String((firstValue * 10 + firstValue) * (secondValue * 10 + secondValue))
        XCTAssert(actual == expected)
    }
    
    func test_GivenOneNumberHigherThanTenAndAnotherAndAddEvaluation_ThenExpressionIsIncorrectErrorIsThrown() throws {
        // Given One Number Higher Than Ten And Another And Make Addition
        try expression.addNumber(number:firstValue)
        try expression.addNumber(number: firstValue)
        
        try expression.addOperator(arithmeticOperator: "*")
        
        try expression.addNumber(number: secondValue)
        try expression.addNumber(number: secondValue)
        
        // When Evaluate
        // Then Addition Is Correct
        let actual = String(try expression.evaluate())
        let expected = String((firstValue * 10 + firstValue) * (secondValue * 10 + secondValue))
        XCTAssert(actual == expected)
    }
    
    func test_GivenTwoNumberAndMakeAdditionAndEvaluate_WhenAddNumber_ThenExpressionHaveResultErrorIsThrown() throws {
        // Given Two Number And Make Addition And Evaluate
        try expression.addNumber(number: firstValue)
        try expression.addOperator(arithmeticOperator: "+")
        try expression.addNumber(number: secondValue)
        
        try expression.evaluate()
        
        do {
            // When Add Number
            try expression.addNumber(number: firstValue)
        } catch let error as ArithmeticError {
            // Then Expression Has Been Cleared And Replace By Added Number
            switch error {
            case .ExpressionHaveResult(let expression):
                XCTAssert(expression.count == 1)
                XCTAssert(expression[0] == .number(firstValue))
            default:
                break
            }
        }
    }
    
    func test_GivenTwoNumberAndMakeAdditionAndEvaluate_WhenAddOperator_ThenOperatorHasBeenAddedToResult() throws {
        // Given Two Number And Make Addition And Evaluate
        try expression.addNumber(number: firstValue)
        try expression.addOperator(arithmeticOperator: "+")
        try expression.addNumber(number: secondValue)
        
        try expression.evaluate()
        
        // When Add Operator
        do {
            // When Add Number
            try expression.addOperator(arithmeticOperator: "*")
        } catch let error as ArithmeticError {
            // Then Expression Has Been Cleared And Replace By Added Number
            switch error {
            case .ExpressionHaveResult(let expression):
                XCTAssert(expression.count == 2)
                XCTAssert(expression[0] == .number(firstValue + secondValue))
            default:
                break
            }
        }
        
        try expression.addNumber(number: thirdValue)
        
        // Then Operator Has Been Added To Resul
        let actual = String(try expression.evaluate())
        let expected = String((firstValue + secondValue) * thirdValue)
        XCTAssert(actual == expected)
    }
    
    func test_GivenTwoNumberAndMakeAdditionAndEvaluate_WhenEvaluateAgain_ThenExpressionHaveResultErrorIsThrown() throws {
        // Given Two Number And Make Addition And Evaluate
        try expression.addNumber(number: firstValue)
        try expression.addOperator(arithmeticOperator: "+")
        try expression.addNumber(number: secondValue)
        
        try expression.evaluate()
        
        // When Evaluate Again
        do {
            // When Add Number
            try expression.evaluate()
        } catch let error as ArithmeticError {
            // Then Expression Has Been Cleared And Replace By Added Number
            switch error {
            case .ExpressionHaveResult(_):
                XCTAssert(true)
            default:
                XCTAssert(true)
            }
        }
    }
    
    func test_GivenTwoNumberAndMakeSubstraction_WhenEvaluate_ThenSubstractionIsCorrect() throws {
        // Given Two Number And Make Substraction
        try expression.addNumber(number: firstValue)
        try expression.addOperator(arithmeticOperator: "-")
        try expression.addNumber(number: secondValue)
        
        // When Evaluate
        // Then Substraction Is Correct
        let actual = String(try expression.evaluate())
        let expected = String(firstValue - secondValue)
        XCTAssert(actual == expected)
    }
    
    func test_GivenTwoNumberAndMakeMultiplication_WhenEvaluate_ThenMultiplicationIsCorrect() throws {
        // Given Two Number And Make Multiplication
        try expression.addNumber(number: firstValue)
        try expression.addOperator(arithmeticOperator: "*")
        try expression.addNumber(number: secondValue)
        
        // When Evaluate
        // Then Multiplication Is Correct
        let actual = String(try expression.evaluate())
        let expected = String(firstValue * secondValue)
        XCTAssert(actual == expected)
    }
    
    func test_GivenTwoLongNumberAndMakeMultiplication_WhenEvaluate_ThenMultiplicationIsCorrect() throws {
        // Given Two Long Number And Make Multiplication
        firstValue = 80000000000000
        secondValue = 80000000000000
        
        try expression.addNumber(number: firstValue)
        try expression.addOperator(arithmeticOperator: "*")
        try expression.addNumber(number: secondValue)
        
        // When Evaluate
        let actual = String(try expression.evaluate())
        
        // Then Multiplication Is Correct
        let expected = String(firstValue * secondValue)
        XCTAssert(actual == expected)
    }
    
    func test_GivenTwoNumberAndMakeDivision_WhenEvaluate_ThenDivisionIsCorrect() throws {
        // Given Two Number And Make Division
        try expression.addNumber(number: firstValue)
        try expression.addOperator(arithmeticOperator: "/")
        try expression.addNumber(number: secondValue)
        
        // When Evaluate
        // Then Division Is Correct
        let actual = String(try expression.evaluate())
        let expected = String(firstValue / secondValue)
        XCTAssert(actual == expected)
    }
    
    func test_GivenTwoNumberAndMakeDivision_WhenEvaluate_ThenDivisionIsDecimal() throws {
        // Given Two Number And Make Division
        try expression.addNumber(number: firstValue)
        try expression.addOperator(arithmeticOperator: "/")
        try expression.addNumber(number: secondValue)
        
        // When Evaluate
        let actual = String(try expression.evaluate())
        let expected = String(firstValue / secondValue)
        XCTAssert(actual == expected)
        
        // Then Division Is Decimal
        XCTAssert(Decimal(string: actual) == Decimal(string: expected))
    }
    
    func test_GivenExpressionIsIncorrect_WhenEvaluate_ThenExpressionIsIncorrectErrorIsThrown() throws {
        // Given Expression Is Incorrect
        try expression.addNumber(number: firstValue)
        try expression.addNumber(number: firstValue)
        try expression.addOperator(arithmeticOperator: "+")
        try expression.addNumber(number: firstValue)
        try expression.addOperator(arithmeticOperator: "+")
        
        do {
            // When Evaluate
            try expression.evaluate()
        } catch let error as ArithmeticError {
            // Then ExpressionIsIncorrect Error Is Thrown
            switch error {
            case .ExpressionIsIncorrect(_):
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
        }
    }
    
    func test_GivenExpressionHaveNotEnoughElement_WhenEvaluate_ThenExpressionHaveNotEnoughElementErrorIsThrown() throws {
        // Given Expression Have Not Enough Element
        try expression.addNumber(number: firstValue)
        try expression.addOperator(arithmeticOperator: "+")
        
        do {
            // When Evaluate
            try expression.evaluate()
        } catch let error as ArithmeticError {
            // Then ExpressionHaveNotEnoughElement Error Is Thrown
            switch error {
            case .ExpressionHaveNotEnoughElement(_):
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
        }
    }

    func test_GivenAddAOperator_WhenAddAOperatorAgain_ThenCannotAddOperatorErrorIsThrown() throws {
        do {
            try expression.addNumber(number: firstValue)
            // Given Add A Operator
            try expression.addOperator(arithmeticOperator: "+")
            // When Add A Operator Again
            try expression.addOperator(arithmeticOperator: "*")
        } catch let error as ArithmeticError {
            // Then CannotAddOperator Error Is Thrown
            switch error {
            case .CannotAddOperator(_):
                XCTAssert(true)
            default:
                XCTAssert(false)
                break
            }
        }
    }
    
    func test_GivenTwoNumber_WhenAddUnknownOperatorAndEvaluate_ThenUnknownOperatorErrorIsThrown() throws {
        // Given Two Number
        do {
            try expression.addNumber(number: firstValue)
            // When Add Unknown Operator And Evaluate
            try expression.addOperator(arithmeticOperator: "+")
            try expression.addNumber(number: secondValue)
            try expression.addOperator(arithmeticOperator: "/+")
            try expression.addNumber(number: thirdValue)
            try expression.evaluate()
        } catch let error as ArithmeticError {
            // Then Unknown Operator Error Is Thrown
            switch error {
            case .UnknownOperator:
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
        }
    }
    
    func test_GivenTwoNumberAndMakeDivision_WhenDivideByZero_ThenDivisionByZeroErrorIsThrown() throws {
        // Given Two Number And Make Division
        do {
            try expression.addNumber(number: firstValue)
            try expression.addOperator(arithmeticOperator: "/")
            // When Divide By Zero
            try expression.addNumber(number: 0)
        } catch let error as ArithmeticError {
            // Then Division By Zero Error Is Thrown
            switch error {
            case .DivisionByZero:
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
        }
    }
    
    func test_GivenTwoNumberAndMakeDivisionAndDivideByZero_WhenEvaluate_ThenDivisionByZeroErrorIsThrown() throws {
        // Given TwoNumber And Make Division And Divide By Zero
        do {
            try expression.addNumber(number: firstValue)
            try expression.addOperator(arithmeticOperator: "/")
            try expression.addNumber(number: 0)
            // When Evaluate
            try expression.evaluate()
        } catch let error as ArithmeticError {
            // Then Division By Zero Error Is Thrown
            switch error {
            case .DivisionByZero:
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
        }
    }
    
    func test_GivenNoNumberAdded_WhenAddOperator_ThenExpressionIsIncorrectErrorIsThrown() throws {
        // Given TwoNumber And Make Division And Divide By Zero
        do {
            try expression.addOperator(arithmeticOperator: "/")
            try expression.addNumber(number: 0)
            // When Evaluate
            try expression.evaluate()
        } catch let error as ArithmeticError {
            // Then Expression Is Incorrect Error Is Thrown
            switch error {
            case .ExpressionIsIncorrect:
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
        }
    }
    
    func test_GivenThreeNumberAndMakeAdditionAndSubstraction_WhenEvaluate_ThenResultIsCorrect() throws {
        // Given Three Number And Make Addition And Substraction
        try expression.addNumber(number: firstValue)
        try expression.addOperator(arithmeticOperator: "+")
        try expression.addNumber(number: secondValue)
        try expression.addOperator(arithmeticOperator: "-")
        try expression.addNumber(number: thirdValue)
        
        // When Evaluate
        // Then Result Is Correct
        let actual = String(try expression.evaluate())
        let expected = String(firstValue + secondValue - thirdValue)
        XCTAssert(actual == expected)
    }
    
    func test_GivenThreeNumberAndMakeMultiplicationAndDivision_WhenEvaluate_ThenResultIsCorrect() throws {
        // Given Three Number And Make Multiplication And Division
        try expression.addNumber(number: firstValue)
        try expression.addOperator(arithmeticOperator: "*")
        try expression.addNumber(number: secondValue)
        try expression.addOperator(arithmeticOperator: "/")
        try expression.addNumber(number: thirdValue)
        
        // When Evaluate
        // Then Result Is Correct
        let actual = String(try expression.evaluate())
        let expected = String(firstValue * secondValue / thirdValue)
        XCTAssert(actual == expected)
    }
    
    func test_GivenThreeNumberAndMakeDivisionAndMultiplication_WhenEvaluate_ThenResultIsCorrect() throws {
        // Given Three Number And Make Multiplication And Division
        try expression.addNumber(number: firstValue)
        try expression.addOperator(arithmeticOperator: "/")
        try expression.addNumber(number: secondValue)
        try expression.addOperator(arithmeticOperator: "*")
        try expression.addNumber(number: thirdValue)
        
        // When Evaluate
        // Then Result Is Correct
        let actual = String(try expression.evaluate())
        let expected = String(firstValue / secondValue * thirdValue)
        XCTAssert(actual == expected)
    }
    
    func test_GivenThreeNumberAndMakeAdditionAndMultiplication_WhenEvaluate_ThenOperatorPriorityIsRespectedAndResultIsCorrect() throws {
        // Given Three Number And Make Addition And Multiplication
        try expression.addNumber(number: firstValue)
        try expression.addOperator(arithmeticOperator: "+")
        try expression.addNumber(number: secondValue)
        try expression.addOperator(arithmeticOperator: "*")
        try expression.addNumber(number: thirdValue)
        
        // When Evaluate
        // Then Operator Priority Is Respected And Result Is Correct
        let actual = String(try expression.evaluate())
        let expected = String(firstValue + secondValue * thirdValue)
        XCTAssert(actual == expected)
    }
    
    func test_GivenThreeNumberAndMakeSubstractionAndMultiplication_WhenEvaluate_ThenOperatorPriorityIsRespectedAndResultIsCorrect() throws {
        // Given Three Number And Make Addition And Multiplication
        try expression.addNumber(number: firstValue)
        try expression.addOperator(arithmeticOperator: "-")
        try expression.addNumber(number: secondValue)
        try expression.addOperator(arithmeticOperator: "*")
        try expression.addNumber(number: thirdValue)
        
        // When Evaluate
        // Then Operator Priority Is Respected And Result Is Correct
        let actual = String(try expression.evaluate())
        let expected = String(firstValue - secondValue * thirdValue)
        XCTAssert(actual == expected)
    }
    
    func test_GivenThreeNumberAndMakeSubstractionAndDivision_WhenEvaluate_ThenOperatorPriorityIsRespectedAndResultIsCorrect() throws {
        // Given Three Number And Make Substraction And Division
        try expression.addNumber(number: firstValue)
        try expression.addOperator(arithmeticOperator: "-")
        try expression.addNumber(number: secondValue)
        try expression.addOperator(arithmeticOperator: "/")
        try expression.addNumber(number: thirdValue)
        
        // When Evaluate
        let actual = String(try expression.evaluate())
        let expected = String(firstValue - secondValue / thirdValue)
        XCTAssert(actual == expected)
    }
    
    func test_GivenThreeNumberAndMakeAdditionAndDivision_WhenEvaluate_ThenOperatorPriorityIsRespectedAndResultIsCorrect() throws {
        // Given Three Number And Make Substraction And Division
        try expression.addNumber(number: firstValue)
        try expression.addOperator(arithmeticOperator: "+")
        try expression.addNumber(number: secondValue)
        try expression.addOperator(arithmeticOperator: "/")
        try expression.addNumber(number: thirdValue)
        
        // When Evaluate
        let actual = String(try expression.evaluate())
        let expected = String(firstValue + secondValue / thirdValue)
        XCTAssert(actual == expected)
    }
    
    func test_GivenArithmeticError_WhenSwitchOnAllCases_ThenRawValuesAndCasesAreCorresponding() throws {
        
        for arithmeticError in ArithmeticError.allCases {
            
            switch arithmeticError {
            case .DivisionByZero (let expression):
                XCTAssert(arithmeticError.rawValue == (Constants.titleDivisionByZero, Constants.divisionByZeroIsImpossible, expression))
                let error = ArithmeticError.init(rawValue: (Constants.titleDivisionByZero, Constants.divisionByZeroIsImpossible, expression))
                XCTAssert(arithmeticError == error)
            case .ExpressionIsIncorrect (let expression):
                XCTAssert(arithmeticError.rawValue == (Constants.titleExpressionIsIncorrect, Constants.expressionIsIncorrect, expression))
                let error = ArithmeticError.init(rawValue: (Constants.titleExpressionIsIncorrect, Constants.expressionIsIncorrect, expression))
                XCTAssert(arithmeticError == error)
            case .ExpressionHaveNotEnoughElement (let expression):
                XCTAssert(arithmeticError.rawValue == (Constants.titleExpressionHaveNotEnoughElement, Constants.expressionHaveNotEnoughElement, expression))
                let error = ArithmeticError.init(rawValue: (Constants.titleExpressionHaveNotEnoughElement, Constants.expressionHaveNotEnoughElement, expression))
                XCTAssert(arithmeticError == error)
            case .ExpressionHaveResult (let expression):
                XCTAssert(arithmeticError.rawValue == (Constants.titleExpressionHaveResult, Constants.expressionHaveResult, expression))
                let error = ArithmeticError.init(rawValue: (Constants.titleExpressionHaveResult, Constants.expressionHaveResult, expression))
                XCTAssert(arithmeticError == error)
            case .CannotAddOperator (let expression):
                XCTAssert(arithmeticError.rawValue == (Constants.titleCannotAddOperator, Constants.cannotAddOperator, expression))
                let error = ArithmeticError.init(rawValue: (Constants.titleCannotAddOperator, Constants.cannotAddOperator, expression))
                XCTAssert(arithmeticError == error)
            case .UnknownOperator (let expression):
                XCTAssert(arithmeticError.rawValue == (Constants.titleUnknownOperator, Constants.unknownOperator, expression))
                let error = ArithmeticError.init(rawValue: (Constants.titleUnknownOperator, Constants.unknownOperator, expression))
                XCTAssert(arithmeticError == error)
            case .None:
                XCTAssert(arithmeticError.rawValue == ("", "", []))
                let error = ArithmeticError.init(rawValue: ("", "", []))
                XCTAssert(arithmeticError == error)
            }
            
            switch arithmeticError.rawValue.message {
            case Constants.divisionByZeroIsImpossible:
                XCTAssert(arithmeticError == .DivisionByZero(arithmeticError.rawValue.expression))
            case Constants.expressionIsIncorrect:
                XCTAssert(arithmeticError == .ExpressionIsIncorrect(arithmeticError.rawValue.expression))
            case Constants.expressionHaveNotEnoughElement:
                XCTAssert(arithmeticError == .ExpressionHaveNotEnoughElement(arithmeticError.rawValue.expression))
            case Constants.expressionHaveResult:
                XCTAssert(arithmeticError == .ExpressionHaveResult(arithmeticError.rawValue.expression))
            case Constants.cannotAddOperator:
                XCTAssert(arithmeticError == .CannotAddOperator(arithmeticError.rawValue.expression))
            case Constants.unknownOperator:
                XCTAssert(arithmeticError == .UnknownOperator(arithmeticError.rawValue.expression))
            default:
                XCTAssert(arithmeticError == .None)
            }
        }
    }
    
    func test_GivenArithmeticElement_WhenSwitchOnAllCases_ThenRawValuesAndCasesAreCorresponding() throws {
        
        for arithmeticElement in ArithmeticElement.allCases {
            
            let element = ArithmeticElement(rawValue: (arithmeticElement.rawValue.arithmeticOperator,left: .number(firstValue),right: .number(secondValue)))
            
            switch element {
        
            case let .addition(left, right):
                XCTAssert(element.rawValue == ("+", left, right))
                XCTAssert(try element.evaluate() == left.evaluate() + right.evaluate())
            case let .substraction(left, right):
                XCTAssert(element.rawValue == ("-", left, right))
                XCTAssert(try element.evaluate() == left.evaluate() - right.evaluate())
            case let .division(left, right):
                XCTAssert(element.rawValue == ("/", left, right))
                XCTAssert(try element.evaluate() == left.evaluate() / right.evaluate())
            case let .multiplication(left, right):
                XCTAssert(element.rawValue == ("*", left, right))
                XCTAssert(try element.evaluate() == left.evaluate() * right.evaluate())
            default:
                XCTAssert(element.rawValue == ("", .none, .none))
                XCTAssert(try element.evaluate() == 0.0)
            }
        }
    }
}
