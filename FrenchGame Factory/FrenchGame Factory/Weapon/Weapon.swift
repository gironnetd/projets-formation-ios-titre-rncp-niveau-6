//
//  Weapon.swift
//  FrenchGame Factory
//
//  Created by damien on 20/05/2022.
//

import Foundation

//
// Class that represents a weapon
// and implements Damageable protocol
//
class Weapon: Damageable, CustomStringConvertible {
    
    // Number of points a weapon can damage a character
    var damagePoint: Int
    
    // Dictionnary representing number of times a weapon has inflicted in damage to a character with corresponding life points
    var damageDone : [Character : [LifePoint]] = [Character : [LifePoint]]()
    
    init(damagePoint: Int) {
        self.damagePoint = damagePoint
    }
    
    // Choose action to do by the character
    func chooseAction() -> ActionType {
        .damaging(damage)
    }
    
    // Apply damage on a character of the other team
    func damage(otherCharacter: Character) {
        
        if damageDone[otherCharacter] == nil {
            damageDone[otherCharacter] = []
        }
        
        var lifePoint = otherCharacter._lifePoint
        lifePoint.wrappedValue -= damagePoint
        damageDone[otherCharacter]!.append(lifePoint)
        otherCharacter.lifePoint -= damagePoint
    }
    
    // Describe the weapon
    public var description: String {
        return """
            \(type(of: self)) with \(damagePoint) points of damage
            """
    }
    
    // Display statistics of the weapon
    func statistics() {
        for (character, lifePoints) in damageDone {
            print("""
                 - He damaged '\(character.name)' The \(type(of: character)) \(lifePoints.count) times.
                """)
        }
    }
}


