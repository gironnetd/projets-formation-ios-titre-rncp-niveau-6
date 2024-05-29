//
// BooksViewModelSpec.swift
//  booksTests
//
//  Created by Damien Gironnet on 31/03/2023.
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

@testable import books

class BooksViewModelSpec: QuickSpec {
    
    override func spec() {
        var bookRepository: BookRepository!
        var movementRepository: MovementRepository!
        var booksViewModel: BooksViewModel!
        var books: [Book]!
        var movements: [Movement]!
        
        beforeEach {
            books = [
                Book(idBook: DataFactory.randomString(),
                     name: "Khuddaka Nikaya",
                     language: Locale.current.identifier,
                     quotes: []),
                Book(idBook: DataFactory.randomString(),
                     name: "Divers Sutras",
                     language: Locale.current.identifier,
                     quotes: []),
                Book(idBook: DataFactory.randomString(),
                     name: "Bible",
                     language: Locale.current.identifier,
                     quotes: []),
                Book(idBook: DataFactory.randomString(),
                     name: "Books Of Changes",
                     language: Locale.current.identifier,
                     quotes: [])
            ].sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
            
            bookRepository = TestBookRepository(books: books)
            
            DataModule.bookRepository.register { bookRepository }
            
            movements = [
                Movement(idMovement: DataFactory.randomString(),
                         name: "Mahayana",
                         language: Locale.current.identifier,
                         idRelatedMovements: nil,
                         nbTotalQuotes: 3,
                         books: [],
                         movements: []),
                Movement(idMovement: DataFactory.randomString(),
                         name: "Madhyamaka",
                         language: Locale.current.identifier,
                         idRelatedMovements: nil,
                         nbTotalQuotes: 3,
                         books: [],
                         movements: []),
                Movement(idMovement: DataFactory.randomString(),
                         name: "Tantrisme",
                         language: Locale.current.identifier,
                         idRelatedMovements: nil,
                         nbTotalQuotes: 3,
                         books: [],
                         movements: []),
                Movement(idMovement: DataFactory.randomString(),
                         name: "Zen",
                         language: Locale.current.identifier,
                         idRelatedMovements: nil,
                         nbTotalQuotes: 3,
                         books: [],
                         movements: []),
                Movement(idMovement: DataFactory.randomString(),
                         name: "Yogacara",
                         language: Locale.current.identifier,
                         idRelatedMovements: nil,
                         nbTotalQuotes: 3,
                         books: [],
                         movements: [])]
            
            movementRepository = TestMovementRepository(movements: movements)
            
            DataModule.movementRepository.register { movementRepository }

            booksViewModel = BooksViewModel()
        }
        
        describe("Get Books Feed") {
            context("Succeeded") {
                it("Books is Returned") {
                    booksViewModel.feeds {
                        if case let .Success(feed) = booksViewModel.booksFeedUiState {
                            expect(feed.books).to(equal(books.map { UserBook(book: $0) }))
                        } else {
                            fail("Expected <content> but got <\(booksViewModel.booksUiState)>")
                        }
                    }
                }
            }
        }
        
        describe("Get Faiths Feed") {
            context("Succeeded") {
                it("Faiths is Returned") {
                    booksViewModel.feeds {
                        var iterator = movements.makeIterator()
                        
                        var expected: [UserFaith] = []
                        
                        while var row = iterator.next() {
                            row.movements = nil
                            expected.append(UserFaith(faith: row))
                        }
                        
                        if case let .Success(feed) = booksViewModel.booksFeedUiState {
                            expect(feed.faiths).to(equal(expected))
                        } else {
                            fail("Expected <content> but got <\(booksViewModel.faithsUiState)>")
                        }
                    }
                }
            }
        }
    }
}
