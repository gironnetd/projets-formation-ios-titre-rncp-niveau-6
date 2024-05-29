//
//  MovementRepositorySpec.swift
//  dataTests
//
//  Created by damien on 11/10/2022.
//

import Foundation
import Quick
import Nimble
import util
import remote
import cache
import model
import Factory

@testable import data

@MainActor
class MovementRepositorySpec: QuickSpec {
    
    @LazyInjected(DaosModule.movementDao) private var movementDao
    
    override func spec() {
        
        var movementRepository: DefaultMovementRepository!
        
        var firstMovement: Movement!
        var secondMovement: Movement!
        var thirdMovement: Movement!
        
        beforeSuite { @MainActor () -> Void in
            DaosModule.movementDao.register(factory: { TestMovementDao() })
        }
        
        beforeEach {
            movementRepository = DefaultMovementRepository()
            
            firstMovement = Movement.testMovement()
            secondMovement = Movement.testMovement()
            thirdMovement = Movement.testMovement()
        }
        
        afterEach { @MainActor () -> Void in
            (self.movementDao as? TestMovementDao)?.movements = []
        }
        
        describe("Find movement by idMovement") {
            context("Found") {
                it("Movement is returned") { @MainActor () -> Void in
                    (self.movementDao as? TestMovementDao)?.movements.append(contentsOf: [firstMovement.asCached(), secondMovement.asCached(), thirdMovement.asCached()])
                    
                    await expect { try movementRepository.findMovement(byIdMovement: firstMovement.idMovement).waitingCompletion().first }.to(equal(firstMovement))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    (self.movementDao as? TestMovementDao)?.movements.append(contentsOf: [secondMovement.asCached(), thirdMovement.asCached()])
                    
                    await expect { try movementRepository.findMovement(byIdMovement: firstMovement.idMovement).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find movements by name") {
            context("Found") {
                it("Movements are returned") { @MainActor () -> Void in
                    secondMovement.name = firstMovement.name

                    (self.movementDao as? TestMovementDao)?.movements.append(contentsOf: [firstMovement.asCached(), secondMovement.asCached(), thirdMovement.asCached()])
                    
                    expect { try movementRepository.findMovements(byName: firstMovement.name).waitingCompletion().first }.to(equal([firstMovement, secondMovement]))
                }
            }
            
            context("Found with idRelatedMovements") {
                it("Movements are returned") { @MainActor () -> Void in
                     firstMovement.idRelatedMovements?.append(secondMovement.idMovement)

                    (self.movementDao as? TestMovementDao)?.movements.append(contentsOf: [firstMovement.asCached(), secondMovement.asCached(), thirdMovement.asCached()])
                    
                    expect { try movementRepository.findMovements(byName: firstMovement.name).waitingCompletion().first }.to(equal([firstMovement, secondMovement]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    secondMovement.name = firstMovement.name
                    
                    (self.movementDao as? TestMovementDao)?.movements.append(contentsOf: [firstMovement.asCached(), secondMovement.asCached(), thirdMovement.asCached()])
                    
                    expect { try movementRepository.findMovements(byName: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find movements by idParent") {
            context("Found") {
                it("Movements are returned") { @MainActor () -> Void in
                    firstMovement.movements = [secondMovement, thirdMovement]
                    
                    (self.movementDao as? TestMovementDao)?.movements.append(contentsOf: [firstMovement.asCached(), secondMovement.asCached(), thirdMovement.asCached()])
                    
                    expect { try movementRepository.findMovements(byIdParent: firstMovement.idMovement).waitingCompletion().first }.to(equal([secondMovement, thirdMovement]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    (self.movementDao as? TestMovementDao)?.movements.append(contentsOf: [firstMovement.asCached(), secondMovement.asCached(), thirdMovement.asCached()])
                    
                    expect { try movementRepository.findMovements(byIdParent: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find main Movements") {
            context("Found") {
                it("Main movements are returned") { @MainActor () -> Void in
                    firstMovement.idParentMovement = nil
                    secondMovement.idParentMovement = nil

                    (self.movementDao as? TestMovementDao)?.movements.append(contentsOf: [firstMovement.asCached(), secondMovement.asCached(), thirdMovement.asCached()])
                    
                    await expect { try movementRepository.findMainMovements().waitingCompletion().first }.to(equal([firstMovement, secondMovement]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    (self.movementDao as? TestMovementDao)?.movements.append(contentsOf: [firstMovement.asCached(), secondMovement.asCached(), thirdMovement.asCached()])
                    
                    await expect { try movementRepository.findMainMovements().waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all movements") {
            context("Found") {
                it("All Movements are returned") { @MainActor () -> Void in
                    (self.movementDao as? TestMovementDao)?.movements.append(contentsOf: [firstMovement.asCached(), secondMovement.asCached(), thirdMovement.asCached()])
                    
                    await expect { try movementRepository.findAllMovements().waitingCompletion().first }.to(equal([firstMovement, secondMovement, thirdMovement]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") { @MainActor () -> Void in
                    await expect { try movementRepository.findAllMovements().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}
