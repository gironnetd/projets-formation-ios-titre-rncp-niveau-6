//
// AuthorsViewModelSpec.swift
// authorsTests
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

@testable import authors

class AuthorsViewModelSpec: QuickSpec {
    
    override func spec() {
        var authorRepository: AuthorRepository!
        var movementRepository: MovementRepository!
        var centuryRepository: CenturyRepository!
        var viewModel: AuthorsViewModel!
        var authors: [Author]!
        var movements: [Movement]!
        var centuries: [Century]!
        
        beforeEach {
            authors = [
                Author(idAuthor: DataFactory.randomString(),
                       language: Locale.current.identifier,
                       name: "Nicolas Berdiaev",
                       quotes: []),
                Author(idAuthor: DataFactory.randomString(),
                       language: Locale.current.identifier,
                       name: "Aurobindo Ghose",
                       quotes: []),
                Author(idAuthor: DataFactory.randomString(),
                       language: Locale.current.identifier,
                       name: "Paramhansa Yogananda",
                       quotes: []),
                Author(idAuthor: DataFactory.randomString(),
                       language: Locale.current.identifier,
                       name: "Karlfried Graf Durckheim",
                       quotes: [])
            ].sorted(by: { $0.name.lowercased() < $1.name.lowercased() })

            authorRepository = TestAuthorRepository(authors: authors)
            
            DataModule.authorRepository.register { authorRepository }
            
            movements = [
                Movement(idMovement: DataFactory.randomString(),
                         name: "Mahayana",
                         language: Locale.current.identifier,
                         idRelatedMovements: nil,
                         nbTotalQuotes: 3,
                         authors: [],
                         movements: []),
                Movement(idMovement: DataFactory.randomString(),
                         name: "Madhyamaka",
                         language: Locale.current.identifier,
                         idRelatedMovements: nil,
                         nbTotalQuotes: 3,
                         authors: [],
                         movements: []),
                Movement(idMovement: DataFactory.randomString(),
                         name: "Tantrisme",
                         language: Locale.current.identifier,
                         idRelatedMovements: nil,
                         nbTotalQuotes: 3,
                         authors: [],
                         movements: []),
                Movement(idMovement: DataFactory.randomString(),
                         name: "Zen",
                         language: Locale.current.identifier,
                         idRelatedMovements: nil,
                         nbTotalQuotes: 3,
                         authors: [],
                         movements: []),
                Movement(idMovement: DataFactory.randomString(),
                         name: "Yogacara",
                         language: Locale.current.identifier,
                         idRelatedMovements: nil,
                         nbTotalQuotes: 3,
                         authors: [],
                         movements: [])]
            
            movementRepository = TestMovementRepository(movements: movements)
            
            DataModule.movementRepository.register { movementRepository }
            
            centuries = [
                Century(idCentury: DataFactory.randomString(),
                        century: "XX",
                        topics: []),
                Century(idCentury: DataFactory.randomString(),
                        century: "XVI",
                        topics: [])
            ]
            
            centuryRepository = TestCenturyRepository(centuries: centuries)
            
            DataModule.centuryRepository.register { centuryRepository }

            viewModel = AuthorsViewModel()
        }
        
        describe("Get Authors Feed") {
            context("Succeeded") {
                it("Authors are Returned") {
                    viewModel.feeds {
                        var iterator = authors.makeIterator()

                        var expected: [UserAuthor] = []
                        
                        while var row = iterator.next() {
                            row.quotes = []
                            expected.append(UserAuthor(author: row))
                        }
                        
                        if case let .Success(feed) = viewModel.authorsFeedUiState {
                            DispatchQueue.main.async {
                                expect(feed.authors).to(equal(expected))
                            }
                        }
                    }
                }
            }
        }
        
        describe("Get Faiths Feed") {
            context("Succeeded") {
                it("Faiths are Returned") {
                    viewModel.feeds {
                        var iterator = movements.makeIterator()

                        var expected: [UserFaith] = []
                        
                        while var row = iterator.next() {
                            row.movements = nil
                            expected.append(UserFaith(faith: row))
                        }
                        
                        if case let .Success(feed) = viewModel.authorsFeedUiState {
                            expect(feed.faiths.map({ $0.id })).to(equal(expected.map({ $0.id })))
                        }
                    }
                }
            }
        }
        
        describe("Get Centuries Feed") {
            context("Succeeded") {
                it("Centuries are Returned") {
                    viewModel.feeds {
                        if case let .Success(feed) = viewModel.authorsFeedUiState {
                            expect(feed.centuries).to(equal(centuries))
                        }
                    }
                }
            }
        }
    }
}
