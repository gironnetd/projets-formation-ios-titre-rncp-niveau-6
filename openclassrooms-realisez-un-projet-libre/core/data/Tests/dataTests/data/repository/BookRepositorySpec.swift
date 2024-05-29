//
//  BookRepositorySpec.swift
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
class BookRepositorySpec: QuickSpec {
    
    @LazyInjected(DaosModule.bookDao) private var bookDao
    
    override func spec() {
        
        var bookRepository: DefaultBookRepository!
        
        var firstBook: Book!
        var secondBook: Book!
        var thirdBook: Book!
        
        beforeSuite { @MainActor () -> Void in
            DaosModule.bookDao.register(factory: { TestBookDao() })
        }
        
        beforeEach {
            bookRepository = DefaultBookRepository()
            
            firstBook = Book.testBook()
            secondBook = Book.testBook()
            thirdBook = Book.testBook()
        }
        
        afterEach { @MainActor () -> Void in
            (self.bookDao as? TestBookDao)?.books = []
            (self.bookDao as? TestBookDao)?.themes = []
        }
        
        describe("Find book by idBook") {
            context("Found") {
                it("Book is returned") { @MainActor () -> Void in
                    (self.bookDao as? TestBookDao)?.books.append(contentsOf: [firstBook.asCached(), secondBook.asCached(), thirdBook.asCached()])
                    
                    await expect { try bookRepository.findBook(byIdBook: firstBook.idBook).waitingCompletion().first }.to(equal(firstBook))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    (self.bookDao as? TestBookDao)?.books.append(contentsOf: [secondBook.asCached(), thirdBook.asCached()])
                    
                    await expect { try bookRepository.findBook(byIdBook: firstBook.idBook).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find books by name") {
            context("Found") {
                it("Books are returned") { @MainActor () -> Void in
                    secondBook.name = firstBook.name
                    
                    (self.bookDao as? TestBookDao)?.books.append(contentsOf: [firstBook.asCached(), secondBook.asCached(), thirdBook.asCached()])
                    
                    expect { try bookRepository.findBooks(byName: firstBook.name).waitingCompletion().first }.to(equal([firstBook, secondBook]))
                }
            }
            
            context("Found with idRelatedBooks") {
                it("Books are returned") { @MainActor () -> Void in
                    firstBook.idRelatedBooks?.append(secondBook.idBook)
                    
                    (self.bookDao as? TestBookDao)?.books.append(contentsOf: [firstBook.asCached(), secondBook.asCached(), thirdBook.asCached()])
                    
                    expect { try bookRepository.findBooks(byName: firstBook.name).waitingCompletion().first }.to(equal([firstBook, secondBook]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    (self.bookDao as? TestBookDao)?.books.append(contentsOf: [secondBook.asCached(), thirdBook.asCached()])
                    
                    expect { try bookRepository.findBooks(byName: firstBook.name).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find books by idMovement") {
            context("Found") {
                it("Books are returned") { @MainActor () -> Void in
                    let movement = Movement.testMovement()
                    firstBook.idMovement = movement.idMovement
                    secondBook.idMovement = movement.idMovement
                    
                    (self.bookDao as? TestBookDao)?.books.append(contentsOf: [firstBook.asCached(), secondBook.asCached(), thirdBook.asCached()])
                    
                    expect { try bookRepository.findBooks(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal([firstBook, secondBook]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    let movement = Movement.testMovement()
                    firstBook.idMovement = movement.idMovement
                    secondBook.idMovement = movement.idMovement
                    
                    (self.bookDao as? TestBookDao)?.books.append(contentsOf: [firstBook.asCached(), secondBook.asCached()])
                    
                    expect { try bookRepository.findBooks(byIdMovement: thirdBook.idMovement!).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find books by idTheme") {
            context("Found") {
                it("Books are returned") { @MainActor () -> Void in
                    let theme = CachedTheme.testTheme()
                    theme.books.removeAll()
                    
                    theme.books.append(objectsIn: [firstBook.asCached(), secondBook.asCached()])
                    
                    (self.bookDao as? TestBookDao)?.themes.append(theme)
                    
                    expect { try bookRepository.findBooks(byIdTheme: theme.idTheme).waitingCompletion().first }.to(equal([firstBook, secondBook]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    let firstTheme = CachedTheme.testTheme()
                    let secondTheme = CachedTheme.testTheme()
                    
                    firstTheme.books.removeAll()
                    secondTheme.books.removeAll()
                    
                    firstTheme.books.append(objectsIn: [firstBook.asCached(), secondBook.asCached()])
                    
                    (self.bookDao as? TestBookDao)?.themes.append(contentsOf: [firstTheme, secondTheme])
                    (self.bookDao as? TestBookDao)?.books.append(thirdBook.asCached())
                    
                    expect { try bookRepository.findBooks(byIdTheme: secondTheme.idTheme).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find book by idPresentation") {
            context("Found") {
                it("Book is returned") { @MainActor () -> Void in
                    let presentation = Presentation.testPresentation()
                    
                    firstBook.presentation = presentation
                    
                    (self.bookDao as? TestBookDao)?.books.append(contentsOf: [firstBook.asCached(), secondBook.asCached(), thirdBook.asCached()])
                    
                    expect { try bookRepository.findBook(byIdPresentation: presentation.idPresentation).waitingCompletion().first }.to(equal(firstBook))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    let presentation = Presentation.testPresentation()
                    
                    (self.bookDao as? TestBookDao)?.books.append(contentsOf: [firstBook.asCached(), secondBook.asCached(), thirdBook.asCached()])
                    
                    expect { try bookRepository.findBook(byIdPresentation: presentation.idPresentation).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find book by idPicture") {
            context("Found") {
                it("Book is returned") { @MainActor () -> Void in
                    let picture = Picture.testPicture()
                    firstBook.pictures?.append(picture)
                    
                    (self.bookDao as? TestBookDao)?.books.append(contentsOf: [firstBook.asCached(), secondBook.asCached(), thirdBook.asCached()])
                    
                    expect { try bookRepository.findBook(byIdPicture: picture.idPicture).waitingCompletion().first }.to(equal(firstBook))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    let picture = CachedPicture.testPicture()
                    
                    (self.bookDao as? TestBookDao)?.books.append(contentsOf: [firstBook.asCached(), secondBook.asCached(), thirdBook.asCached()])
                    
                    expect { try bookRepository.findBook(byIdPicture: picture.idPicture).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all books") {
            context("Found") {
                it("All Books are returned") { @MainActor () -> Void in
                    (self.bookDao as? TestBookDao)?.books.append(contentsOf: [firstBook.asCached(), secondBook.asCached(), thirdBook.asCached()])
                    await expect { try bookRepository.findAllBooks().waitingCompletion().first }.to(equal([firstBook, secondBook, thirdBook]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") { @MainActor () -> Void in
                    await expect { try bookRepository.findAllBooks().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}
