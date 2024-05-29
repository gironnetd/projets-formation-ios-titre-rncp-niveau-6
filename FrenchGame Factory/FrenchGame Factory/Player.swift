//
//  Player.swift
//  FrenchGame Factory
//
//  Created by damien on 20/05/2022.
//

import Foundation

//
// Class that represents a player
//
class Player {
    
    lazy var team: Team = Team()
    
    init() {
        print("Create your team of \(team.teamSize) characters :\n")
    }
    
    // Start the player's turn
    func play(against player: Player) {
        switch team.chooseCharacter().weapon.chooseAction() {
            case .healing(let heal) :
                heal(team.chooseCharacter())
            case .damaging(let damage) :
                    damage(player.team.chooseCharacter())
        }
    }
}
