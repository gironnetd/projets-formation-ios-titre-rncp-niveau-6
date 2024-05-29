//
//  MagicWand.swift
//  FrenchGame Factory
//
//  Created by damien on 21/05/2022.
//

import Foundation

//
// Class that represents a weapon
// and implements Healable protocol
//
class MagicWand: Weapon, Healable {
    
    // Number of points a weapon can heal a character
    var healingPoint: Int
    
    // Dictionnary representing number of times a weapon has healed a character with corresponding life points
    lazy var healingDone : [Character : [LifePoint]] = [Character : [LifePoint]]()
    
    init() {
        self.healingPoint = 20
        super.init(damagePoint: 5)
    }
    
    // Choose action to do by the character
    override func chooseAction() -> ActionType {
        print("Choose between healing your team or attack an opponent : \n")
        print("1 - Heal your team")
        print("2 - Damage an opponent")
        
        switch(Utils.readInteger(minValue: 1, maxValue: 2)) {
            case 1 :
                return .healing(heal)
            case 2 :
                return .damaging(damage)
            default :
                return .damaging(damage)
        }
    }
    
    // Apply heal on a character of his own team
    func heal(otherCharacter: Character) {
           
        if healingDone[otherCharacter] == nil {
            healingDone[otherCharacter] = []
        }
        
        var lifePoint = otherCharacter._lifePoint
        lifePoint.wrappedValue += healingPoint
        healingDone[otherCharacter]!.append(lifePoint)
        otherCharacter.lifePoint += healingPoint
    }
    
    // Describe the weapon
    public override var description: String {
        return """
            \(super.description) and \(healingPoint) points of healing
            """
    }
    
    // Display statistics of the weapon
    override func statistics() {
        super.statistics()
        for (character, lifePoints) in healingDone {
            print("""
                 - He healed '\(character.name)' The \(type(of: character)) \(lifePoints.count) times.
                """)
        }
    }
}

