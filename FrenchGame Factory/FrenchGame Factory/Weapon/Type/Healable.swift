//
//  Healable.swift
//  FrenchGame Factory
//
//  Created by damien on 21/05/2022.
//

import Foundation

//
// Protocol that represents healable action of the weapon of a character.
//
protocol Healable : Action {

    // Number of points a weapon can heal a character
    var healingPoint: Int { get set }
    
    // Dictionnary representing number of times a weapon has healed a character with corresponding life points
    var healingDone : [Character : [LifePoint]] { get set }
    
    // Apply heal on a character of his own team
    func heal(otherCharacter: Character)
}

