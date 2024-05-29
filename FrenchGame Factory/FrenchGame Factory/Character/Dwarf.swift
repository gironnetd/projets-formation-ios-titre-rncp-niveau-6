//
//  Dwarf.swift
//  FrenchGame Factory
//
//  Created by damien on 20/05/2022.
//

import Foundation

//
// Class that represents a dwarf
//
class Dwarf: Character {
    
    init(name: String, team: Team) {
        super.init(name: name, lifePoint: LifePoint(maxValue: 50), weapon: Axe(), in: team)
    }
}
