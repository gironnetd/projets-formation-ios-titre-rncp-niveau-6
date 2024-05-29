//
//  Attackable.swift
//  FrenchGame Factory
//
//  Created by damien on 21/05/2022.
//

import Foundation

//
// Protocol that represents damageable action of the weapon of a character.
//
protocol Damageable : Action {
    
    // Number of points a weapon can damage a character
    var damagePoint: Int { get set }
    
    // Dictionnary representing number of times a weapon has inflicted in damage to a character with corresponding life points
    var damageDone : [Character : [LifePoint]] { get set }
    
    // Apply damage on a character of the other team
    func damage(otherCharacter: Character)
}

