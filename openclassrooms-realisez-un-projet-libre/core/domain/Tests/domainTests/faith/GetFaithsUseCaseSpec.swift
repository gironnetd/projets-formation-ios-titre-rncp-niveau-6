//
//  GetFaithsUseCaseSpec.swift
//  domainTests
//
//  Created by Damien Gironnet on 26/07/2023.
//

import Foundation
import Quick
import Nimble
import testing
import util
import data
import remote
import Factory
import model

@testable import domain

class GetFaithsUseCaseSpec: QuickSpec {
    
    override func spec() {
        var movementRepository: MovementRepository!
        var useCase: GetFaithsUseCase!
        
        describe("Get Faiths") {
            context("Succeeded") {
                it("Faiths is Returned") {
                    movementRepository = TestMovementRepository(movements: [
                        Movement(idMovement: DataFactory.randomString(),
                                 name: "Mahayana",
                                 language: Locale.current.identifier,
                                 idRelatedMovements: nil,
                                 nbTotalQuotes: 3),
                        Movement(idMovement: DataFactory.randomString(),
                                 name: "Madhyamaka",
                                 language: Locale.current.identifier,
                                 idRelatedMovements: nil,
                                 nbTotalQuotes: 3),
                        Movement(idMovement: DataFactory.randomString(),
                                 name: "Tantrisme",
                                 language: Locale.current.identifier,
                                 idRelatedMovements: nil,
                                 nbTotalQuotes: 3),
                        Movement(idMovement: DataFactory.randomString(),
                                 name: "Zen",
                                 language: Locale.current.identifier,
                                 idRelatedMovements: nil,
                                 nbTotalQuotes: 3),
                        Movement(idMovement: DataFactory.randomString(),
                                 name: "Yogacara",
                                 language: Locale.current.identifier,
                                 idRelatedMovements: nil,
                                 nbTotalQuotes: 3)]
                    )
                    
                    DataModule.movementRepository.register { movementRepository }
                    
                    useCase = GetFaithsUseCase()
                    
                    let faiths = useCase()
                    
                    await expect { try faiths.waitingCompletion().first }.to( equal((movementRepository as? TestMovementRepository)?.movements.map { UserFaith(faith: $0) }))
                }
            }
            
            context("Failed") {
                it("Error is thrown") {
                    movementRepository = TestMovementRepository()
                    
                    DataModule.movementRepository.register { movementRepository }
                    
                    useCase = GetFaithsUseCase()
                    
                    await expect { try useCase().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}

