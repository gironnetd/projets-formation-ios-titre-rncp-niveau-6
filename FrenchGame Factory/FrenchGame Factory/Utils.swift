//
//  Utils.swift
//  FrenchGame Factory
//
//  Created by damien on 23/05/2022.
//

import Foundation

//
// This Class is a Utilitary class composed of class method
// to read not empty lines and integer.
//
class Utils {
    
    // Read line and verify she is not empty
    static func readNotEmptyLine() -> String {
        if let line = readLine(strippingNewline: true) {
            if line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                print("You have not entered anything. Try again !")
                return readNotEmptyLine()
            } else {
                return line.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        return readNotEmptyLine()
    }
    
    // Read not empty line and verify that is an integer contained between min and max value
    static func readInteger(minValue: Int, maxValue: Int) -> Int {
        if let line = readLine(strippingNewline: true) {
            if line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                print("You have not entered anything. Try again !")
                return readInteger(minValue: minValue, maxValue: maxValue)
            } else {
                if let integer = Int(line) {
                    if integer >= minValue && integer <= maxValue {
                        return integer
                    }
                    print("\nThe number you entered must be between \(minValue) and \(maxValue).  Try again !")
                    return readInteger(minValue: minValue, maxValue: maxValue)
                } else {
                    print("\nYou must enter a number. Try again !")
                    return readInteger(minValue: minValue, maxValue: maxValue)
                }
            }
        }
        return readInteger(minValue: minValue, maxValue: maxValue)
    }
}
