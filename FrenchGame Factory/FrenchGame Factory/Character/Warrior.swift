//
//  Warrior.swift
//  FrenchGame Factory
//
//  Created by damien on 20/05/2022.
//

import Foundation

//
// Class that represents a warrior
//
class Warrior: Character {
    
    init(name: String, team: Team) {
        super.init(name: name, lifePoint: LifePoint(maxValue: 100), weapon: Sword(), in: team)
    }
}
