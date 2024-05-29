//
//  Team.swift
//  FrenchGame Factory
//
//  Created by damien on 22/05/2022.
//

import Foundation

//
// Class that represents a team
// composed by a collection of characters
//
class Team : CustomStringConvertible {
    
    let teamSize = 3
    
    var composition: Set<Character> = []
    
    init() {
        for _ in 0..<teamSize {
            Character.createCharacter(in: self)
        }
    }
    
    // Verify if all character of team are alive or not.
    @discardableResult
    func teamIsAlive() -> Bool {
        if composition.allSatisfy({ character in character.lifePoint == 0}) {
            game.endGame()
            return false
        }
        return true
    }
    
    // Choose a character inside the team
    func chooseCharacter() -> Character {
        print("\nChoose a character in the team by selecting a number :\n")
        
        let teamAsArray = Array(composition)
        for index in teamAsArray.indices {
            print("\(index + 1) - '\(teamAsArray[index].name)' the \(type(of: teamAsArray[index])) : \(teamAsArray[index].lifePoint)/\(teamAsArray[index]._lifePoint.maxValue) life points")
        }
        let index = Utils.readInteger(minValue: 1, maxValue: teamAsArray.count)
        
        return teamAsArray[index - 1]
    }
    
    // Describe the team
    var description: String {
        var desc: String = String()
        composition.forEach { character in desc.append(character.description + "\n") }
        return desc
    }
    
    // Display statistics of the team
    func statistics() {
        for character in composition {
            print("""
                * '\(character.name)' The \(type(of: character)) Statistics : \n
                """)
            character.weapon.statistics()
        }
    }
}
