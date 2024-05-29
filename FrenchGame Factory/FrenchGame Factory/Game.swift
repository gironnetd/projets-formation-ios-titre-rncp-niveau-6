//
//  Game.swift
//  FrenchGame Factory
//
//  Created by damien on 20/05/2022.
//

import Foundation

//
// Class that represents the game
//
class Game {
    
    var playerOne: Player
    var playerTwo: Player
    
    var lapCounter: Int = 0
    
    init() {
        print("################## WELCOME TO FANTASIA WAR ##################\n")
        
        print("################## CREATE PLAYER ONE ##################\n")
        playerOne = Player()
        
        print("\n################## CREATE PLAYER TWO ##################\n")
        playerTwo = Player()
        
        print("##################         SUMMARY        ##################\n")
        
        print(
            """
            PLAYER ONE TEAM IS COMPOSED BY : \n
            \(String(describing: playerOne.team.description))
            """
        )
        
        print(
            """
            PLAYER TWO TEAM IS COMPOSED BY : \n
            \(String(describing: playerTwo.team.description))
            """
        )
    }
    
    // Launch the fight
    func fight() {
        print("################# NOW, THE FIGHT CAN BEGIN ##################\n\n")
        
        while playerOne.team.teamIsAlive() && playerTwo.team.teamIsAlive() {
            lapCounter += 1
            print("################# IT'S TURN OF PLAYER ONE #################")
            playerOne.play(against: playerTwo)
            print("\n################# IT'S TURN OF PLAYER TWO #################")
            playerTwo.play(against: playerOne)
        }
    }
    
    // Close the game by displaying the statistics of the two players before exit console
    func endGame() {
        if playerTwo.team.composition.allSatisfy({ character in character.lifePoint == 0}) {
            print("\n################# PLAYER ONE WINS !!!!!!! ##################\n")
            
            print("THE PARTY TAKE \(lapCounter) LAPS.\n")
            
            print("PLAYER ONE STATISTICS : \n")
            playerOne.team.statistics()
            
            print("\nPLAYER TWO STATISTICS : \n")
            playerTwo.team.statistics()
        }
        
        if playerOne.team.composition.allSatisfy({ character in character.lifePoint == 0}) {
            print("\n################# PLAYER TWO WINS !!!!!!! ##################\n")
            
            print("PLAYER TWO STATISTICS : \n")
            playerTwo.team.statistics()
            
            print("\nPLAYER ONE STATISTICS : \n")
            playerOne.team.statistics()
        }
        print("\n################# GAME IS FINISH, MAKE ANOTHER PARTY !!!!!!! ##################\n")
        
        exit(0)
    }
}
