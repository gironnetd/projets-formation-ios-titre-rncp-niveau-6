//
//  Magus.swift
//  FrenchGame Factory
//
//  Created by damien on 20/05/2022.
//

import Foundation

//
// Class that represents a magus
//
class Magus: Character {

    init(name: String, team: Team) {
        super.init(name: name, lifePoint: LifePoint(maxValue: 150), weapon: MagicWand(), in: team)
    }
}
