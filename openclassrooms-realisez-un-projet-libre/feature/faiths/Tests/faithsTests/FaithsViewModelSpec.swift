//
// FaithsViewModelSpec.swift
// faithsTests
//
// Created by Damien Gironnet on 31/03/2023.
//

import Foundation
import Quick
import Nimble
import testing
import util
import data
import domain
import remote
import model
import Factory
import XCTest

@testable import faiths

class FaithsViewModelSpec: QuickSpec {
    
    override func spec() {
        var movementRepository: MovementRepository!
        var viewModel: FaithsViewModel!
        var movements: [Movement]!
        
        beforeEach {
            movements = [
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
            
            viewModel = FaithsViewModel()
        }
        
        describe("Get Faiths Feed") {
            context("Succeeded") {
                it("Faiths is Returned") {
                    viewModel.feeds()
                    
                    let exp = self.expectation(description: "Test after 5 seconds")
                    _ = await XCTWaiter.fulfillment(of: [exp], timeout: 5.0)
                
                    if case let .Success(feed) = viewModel.faithsUiState {
                        expect(feed).to(equal(movements.map { UserFaith(faith: $0) }))
                    } else {
                        fail("Expected <content> but got <\(viewModel.faithsUiState)>")
                    }
                }
            }
        }
    }
}
