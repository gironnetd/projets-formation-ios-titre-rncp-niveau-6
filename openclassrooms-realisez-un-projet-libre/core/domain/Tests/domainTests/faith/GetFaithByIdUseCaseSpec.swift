//
//  GetFaithByIdUseCaseSpec.swift
//  domainTests
//
//
//  Created by Damien Gironnet on 08/10/2023.
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

class GetFaithByIdUseCaseSpec: QuickSpec {
    
    override func spec() {
        var movementRepository: MovementRepository!
        var useCase: GetFaithByIdUseCase!
        
        describe("Get Faith by Id") {
            context("Succeeded") {
                it("Faith is Returned") {
                    let movements = [
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
                    movementRepository = TestMovementRepository(movements: movements)
                    
                    DataModule.movementRepository.register { movementRepository }
                    
                    useCase = GetFaithByIdUseCase()
                    
                    let faith = useCase(movements[0].idMovement)
                    
                    await expect { try faith.waitingCompletion().first }.to(equal(UserFaith(faith: movements.first(where: { $0.idMovement == movements[0].idMovement })!)))
                }
            }
            
            context("Failed") {
                it("Error is thrown") {
                    useCase = GetFaithByIdUseCase()
                    
                    await expect { try useCase().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}

