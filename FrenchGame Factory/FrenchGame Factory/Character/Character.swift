//
//  Character.swift
//  FrenchGame Factory
//
//  Created by damien on 20/05/2022.
//

import Foundation

//
// Class that represents a character
// and implements Hashable protocol
//
class Character: Hashable, CustomStringConvertible {
    
    // Name of the character
    var name: String
    
    // Team of the character
    var team: Team
    
    // Weapon of the character
    var weapon: Weapon
    
    // LifePoint Backing property
    var _lifePoint: LifePoint {
        didSet {
            if _lifePoint.wrappedValue == 0 {
                team.teamIsAlive()
            }
        }
    }
    
    // Life point of the character
    var lifePoint: Int {
        get { return _lifePoint.wrappedValue }
        set { _lifePoint.wrappedValue = newValue }
    }
    
    init(name: String, lifePoint: LifePoint, weapon: Weapon, in team: Team) {
        self.name = name
        self._lifePoint = lifePoint
        self.weapon = weapon
        self.team = team
        print("\nYou have just created " + description)
    }
    
    static var namesCharacter: [String] = []
    
    static func createCharacter(in team: Team) {
        print("Enter the type of your character n°\(String(team.composition.count + 1)) by choosing a number : \n" )
        print("1 - Magus")
        print("2 - Warrior")
        print("3 - Dwarf")
        let type = Utils.readInteger(minValue: 1, maxValue: 3)
        
        print("\nEnter his name :")
        var name: String
        repeat {
            name = Utils.readNotEmptyLine()
            if namesCharacter.contains(name.lowercased().capitalized) {
                print("\nSorry, but the name you entered is already take.Please, Enter an other one :")
            }
        } while namesCharacter.contains(name.lowercased().capitalized)
        
        name = name.lowercased().capitalized
        namesCharacter.append(name)
        
        switch type {
        case 1:
            team.composition.insert(Magus(name: name, team: team))
        case 2:
            team.composition.insert(Warrior(name: name, team: team))
        case 3:
            team.composition.insert(Dwarf(name: name, team: team))
        default:
            break
        }
    }
    
    // Describe the character
    public var description: String {
        return """
            '\(name)', a \(type(of: self)) :\n
            He has \(lifePoint) points of life.
            His Weapon is a \(weapon.description).\n
            """
    }
    
    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
