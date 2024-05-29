//
//  BookDaoSpec.swift
//  cacheTests
//
//  Created by damien on 14/09/2022.
//

import Foundation
import Quick
import Nimble
import RealmSwift
import util

@testable import cache

class BookDaoSpec: QuickSpec {
    
    override func spec() {
        
        var bookDatabase : Realm!
        var bookDao : BookDao!
        
        var firstBook: CachedBook!
        var secondBook: CachedBook!
        var thirdBook: CachedBook!
        
        beforeEach {
            DatabaseModule.realm.register {
                let configuration = Realm.Configuration(inMemoryIdentifier: "cached-book-dao-testing")
                Realm.Configuration.defaultConfiguration = configuration
                bookDatabase = try? Realm()
                return bookDatabase
            }
            bookDao = DefaultBookDao()
            
            firstBook = CachedBook.testBook()
            secondBook = CachedBook.testBook()
            thirdBook = CachedBook.testBook()
        }
        
        afterEach {  () -> Void in
            if let realm = (bookDao as? DefaultBookDao)?.realm {
                try? realm.write {
                    realm.deleteAll()
                    try? realm.commitWrite()
                }
            }
        }
        
        describe("Find book by idBook") {
            context("Found") {
                it("Book is returned") {  () -> Void in
                    if let realm = (bookDao as? DefaultBookDao)?.realm {
                        try? realm.write {
                            realm.add([firstBook, secondBook, thirdBook])
                            try? realm.commitWrite()
                        }
                    }
                    
                    await expect { try await bookDao.findBook(byIdBook: firstBook.idBook).value.thaw() }.to(equal(firstBook))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    if let realm = (bookDao as? DefaultBookDao)?.realm {
                        try? realm.write {
                            realm.add([secondBook, thirdBook])
                            try? realm.commitWrite()
                        }
                    }
                    
                    await expect { try await bookDao.findBook(byIdBook: firstBook.idBook).value }.to(throwError())
                }
            }
        }
        
        describe("Find books by name") {
            context("Found") {
                it("Books are returned") {  () -> Void in
                    if let realm = (bookDao as? DefaultBookDao)?.realm {
                        try? realm.write {
                            secondBook.name = firstBook.name
                            realm.add([firstBook, secondBook, thirdBook])
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try bookDao.findBooks(byName: firstBook.name).waitingCompletion().first }.to(equal([firstBook, secondBook]))
                }
            }
            
            context("Found with idRelatedBooks") {
                it("Books are returned") {  () -> Void in
                    if let realm = (bookDao as? DefaultBookDao)?.realm {
                        try? realm.write {
                            firstBook.idRelatedBooks.append(secondBook.idBook)
                            realm.add([firstBook, secondBook, thirdBook])
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try bookDao.findBooks(byName: firstBook.name).waitingCompletion().first }.to(equal([firstBook, secondBook]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    if let realm = (bookDao as? DefaultBookDao)?.realm {
                        try? realm.write {
                            realm.add([secondBook, thirdBook])
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try bookDao.findBooks(byName: firstBook.name).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find books by idMovement") {
            context("Found") {
                it("Books are returned") {  () -> Void in
                    let movement = CachedMovement.testMovement()
                    
                    if let realm = (bookDao as? DefaultBookDao)?.realm {
                        try? realm.write {
                            firstBook.idMovement = movement.idMovement
                            secondBook.idMovement = movement.idMovement
                            
                            movement.books.append(objectsIn: [firstBook, secondBook])
                            
                            realm.add(movement)
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try bookDao.findBooks(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal([firstBook, secondBook]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    if let realm = (bookDao as? DefaultBookDao)?.realm {
                        try? realm.write {
                            let movement = CachedMovement.testMovement()
                            firstBook.idMovement = movement.idMovement
                            secondBook.idMovement = movement.idMovement
                            
                            movement.books.append(objectsIn: [firstBook, secondBook])
                            
                            realm.add(movement)
                            realm.add(thirdBook)
                            
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try bookDao.findBooks(byIdMovement: thirdBook.idMovement!).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find books by idTheme") {
            context("Found") {
                it("Books are returned") {  () -> Void in
                    let theme = CachedTheme.testTheme()
                    if let realm = (bookDao as? DefaultBookDao)?.realm {
                        try? realm.write {
                            theme.books.append(objectsIn: [firstBook, secondBook])
                            realm.add(theme)
                            
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try bookDao.findBooks(byIdTheme: theme.idTheme).waitingCompletion().first }.to(equal([firstBook, secondBook]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    let firstTheme = CachedTheme.testTheme()
                    let secondTheme = CachedTheme.testTheme()
                    
                    if let realm = (bookDao as? DefaultBookDao)?.realm {
                        try? realm.write {
                            
                            firstTheme.books.append(objectsIn: [firstBook, secondBook])
                            
                            realm.add([firstTheme, secondTheme])
                            realm.add(thirdBook)
                            
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try bookDao.findBooks(byIdTheme: secondTheme.idTheme).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find book by idPresentation") {
            context("Found") {
                it("Book is returned") {  () -> Void in
                    let presentation = CachedPresentation.testPresentation()
                    
                    if let realm = (bookDao as? DefaultBookDao)?.realm {
                        try? realm.write {
                            firstBook.presentation = presentation
                            realm.add([firstBook, secondBook, thirdBook])
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try bookDao.findBook(byIdPresentation: presentation.idPresentation).waitingCompletion().first }.to(equal(firstBook))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    let presentation = CachedPresentation.testPresentation()
                    
                    if let realm = (bookDao as? DefaultBookDao)?.realm {
                        try? realm.write {
                            realm.add(presentation)
                            realm.add([firstBook, secondBook, thirdBook])
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try bookDao.findBook(byIdPresentation: presentation.idPresentation).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find book by idPicture") {
            context("Found") {
                it("Book is returned") {  () -> Void in
                    let picture = CachedPicture.testPicture()
                    
                    if let realm = (bookDao as? DefaultBookDao)?.realm {
                        try? realm.write {
                            firstBook.pictures.append(picture)
                            realm.add([firstBook, secondBook, thirdBook])
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try bookDao.findBook(byIdPicture: picture.idPicture).waitingCompletion().first }.to(equal(firstBook))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    let picture = CachedPicture.testPicture()
                    
                    if let realm = (bookDao as? DefaultBookDao)?.realm {
                        try? realm.write {
                            realm.add(picture)
                            realm.add([firstBook, secondBook, thirdBook])
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try bookDao.findBook(byIdPicture: picture.idPicture).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all books") {
            context("Found") {
                it("All books are returned") {  () -> Void in
                    if let realm = (bookDao as? DefaultBookDao)?.realm {
                        try? realm.write {
                            realm.add([firstBook, secondBook, thirdBook])
                            try? realm.commitWrite()
                        }
                    }
                    
                    await expect { try await bookDao.findAllBooks().value.map({ $0.thaw() }) }.to(equal([firstBook, secondBook, thirdBook]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") {  () -> Void in
                    await expect { try await bookDao.findAllBooks().value }.to(throwError())
                }
            }
        }
    }
}

extension CachedBook {
    
    internal static func testBook() -> CachedBook {
        CachedBook(idBook: UUID().uuidString,
                   name: DataFactory.randomString(),
                   language: .none,
                   idRelatedBooks: List<String>(),
                   century: CachedCentury.testCentury(),
                   details: DataFactory.randomString(),
                   period: DataFactory.randomString(),
                   idMovement: UUID().uuidString,
                   presentation: CachedPresentation.testPresentation(),
                   mcc1: DataFactory.randomString(),
                   quotes: List<CachedQuote>(),
                   pictures: List<CachedPicture>(),
                   urls: List<CachedUrl>(),
                   topics: List<CachedTopic>()
        )
    }
}
