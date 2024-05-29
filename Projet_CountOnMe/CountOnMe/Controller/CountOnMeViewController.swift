//
//  CountOnMeViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class CountOnMeViewController: UIViewController {
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private var numberButtons: [UIButton]!
    
    @IBOutlet private weak var allClearButton: UIButton!
    
    private lazy var expression: ArithmeticExpression = ArithmeticExpression()
    
    private lazy var formatter = NumberFormatter()
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.maximumFractionDigits =  2
        formatter.maximumIntegerDigits =  20
        // Do any additional setup after loading the view.
    }
    
    @IBAction private func tappedAllClearButton(_ sender: UIButton) {
        textView.text = ""
        allClearButton.setTitle("AC", for: .normal)
        expression.clear()
    }
    
    // View actions
    @IBAction private func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal), let number = Double(numberText) else {
            return
        }
        
        do {
            allClearButton.setTitle("CE", for: .normal)
            try expression.addNumber(number: number)
            textView.text.append(numberText)
        } catch let error as ArithmeticError {
            switch error {
            case .ExpressionHaveResult:
                textView.text = ""
                textView.text.append(numberText)
            default:
                break
            }
        } catch {}
    }
    
    @IBAction private func tappedOperatorButton(_ sender: UIButton) {
        guard let arithmeticOperator = sender.title(for: .normal) else {
            return
        }
        
        do {
            try expression.addOperator(arithmeticOperator: arithmeticOperator)
            textView.text.append(" \(arithmeticOperator) ")
        } catch let error as ArithmeticError  {
            switch error {
            case ArithmeticError.ExpressionHaveResult:
                if let firstIndex = textView.text.firstIndex(of: "=") {
                    textView.text.removeSubrange(textView.text.startIndex...firstIndex)
                }
                textView.text.append(" \(arithmeticOperator) ")
            case ArithmeticError.CannotAddOperator:
                presentUIAlertController(title: error.rawValue.title,
                                         message: String(format: error.rawValue.message, error.rawValue.expression.map { element in
                                            if let double = Double(element.rawValue.arithmeticOperator) {
                                                return formatter.string(from: double  as NSNumber) ?? String(double)
                                            }
                                            return String(element.rawValue.arithmeticOperator)
                }.joined(separator: " ") + " \(arithmeticOperator)"))
            default:
                break
            }
        } catch {}
    }
    
    @IBAction private func tappedEqualButton(_ sender: UIButton) {
        do {
            try textView.text.append(" = \(formatter.string(from: Double(expression.evaluate())! as NSNumber) ?? String(expression.evaluate())) ")
        } catch let error as ArithmeticError {
            return
             presentUIAlertController(title: error.rawValue.title, message: String(format: error.rawValue.message, error.rawValue.expression.map {
                element in element.rawValue.arithmeticOperator
            }.joined(separator: " ")))
        } catch {}
    }
    
    private func presentUIAlertController(title: String , message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil ))
        self.present(alertVC, animated: true, completion: nil)
    }
}

