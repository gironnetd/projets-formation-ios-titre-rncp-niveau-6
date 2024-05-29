//
//  LifePoint.swift
//  FrenchGame Factory
//
//  Created by damien on 24/05/2022.
//

import Foundation

//
// Struct that represents the life points of a character
// with a maximum value and a minimum value of 0.
// This Struct can be used as a property wrapper.
//
@propertyWrapper
struct LifePoint {
    var maxValue: Int
    var value: Int
    var wrappedValue: Int {
            get { return value }
            set {
                if newValue < 0 {
                    value = 0
                } else {
                    value = min(newValue, maxValue)
                }
            }
    }
    
    init(maxValue: Int) {
        self.maxValue = maxValue
        self.value = maxValue
    }
}
