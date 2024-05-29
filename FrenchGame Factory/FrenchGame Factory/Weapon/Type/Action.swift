//
//  Action.swift
//  FrenchGame Factory
//
//  Created by damien on 25/05/2022.
//

import Foundation

//
// Protocol that represents basic methods of an action made by the weapon of a character.
//
protocol Action {
    // Choose action to do by the character
    func chooseAction() -> ActionType
    
    // Display statistics of the weapon
    func statistics() 
}
