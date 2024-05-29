//
//  QuoteDaoSpec.swift
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

class QuoteDaoSpec: QuickSpec {
    
    override func spec() {
        
        var quoteDatabase : Realm!
        var quoteDao : QuoteDao!
        
        var firstQuote: CachedQuote!
        var secondQuote: CachedQuote!
        var thirdQuote: CachedQuote!
        
        beforeEach {
            DatabaseModule.realm.register {
                let configuration = Realm.Configuration(inMemoryIdentifier: "cached-quote-dao-testing")
                Realm.Configuration.defaultConfiguration = configuration
                quoteDatabase = try? Realm()
                return quoteDatabase
            }
            quoteDao = DefaultQuoteDao()
            
            firstQuote = CachedQuote.testQuote()
            secondQuote = CachedQuote.testQuote()
            thirdQuote = CachedQuote.testQuote()
        }
        
        afterEach {  () -> Void in
            if let realm = (quoteDao as? DefaultQuoteDao)?.realm {
                try? realm.write {
                    realm.deleteAll()
                    try? realm.commitWrite()
                }
            }
        }
        
        describe("Find quote by idQuote") {
            context("Found") {
                it("Quote is returned") {  () -> Void in
                    if let realm = (quoteDao as? DefaultQuoteDao)?.realm {
                        try? realm.write {
                            realm.add([firstQuote, secondQuote, thirdQuote])
                            try? realm.commitWrite()
                        }
                    }

                    await expect { try await quoteDao.findQuote(byIdQuote: firstQuote.idQuote).value.thaw() }.to(equal(firstQuote))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    if let realm = (quoteDao as? DefaultQuoteDao)?.realm {
                        try? realm.write {
                            realm.add([secondQuote, thirdQuote])
                            try? realm.commitWrite()
                        }
                    }

                    await expect { try await quoteDao.findQuote(byIdQuote: firstQuote.idQuote).value }.to(throwError())
                }
            }
        }
        
        describe("Find quotes by idAuthor") {
            context("Found") {
                it("Quotes are returned") {  () -> Void in
                    let author = CachedAuthor.testAuthor()
                    author.quotes.append(objectsIn: [firstQuote, secondQuote])
                    
                    if let realm = (quoteDao as? DefaultQuoteDao)?.realm {
                        try? realm.write {
                            realm.add(author)
                            realm.add( thirdQuote)
                            try? realm.commitWrite()
                        }
                    }

                    expect { try quoteDao.findQuotes(byIdAuthor: author.idAuthor).waitingCompletion().first.map({ $0.map({ $0.thaw() }) }) }.to(equal([firstQuote, secondQuote]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    let author = CachedAuthor.testAuthor()
                    
                    if let realm = (quoteDao as? DefaultQuoteDao)?.realm {
                        try? realm.write {
                            realm.add(author)
                            realm.add([firstQuote, secondQuote, thirdQuote])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try quoteDao.findQuotes(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find quotes by Author name") {
            context("Found") {
                it("Quotes are returned") {  () -> Void in
                    let firstAuthor = CachedAuthor.testAuthor()
                    firstAuthor.quotes.append(objectsIn: [firstQuote, secondQuote])
                    let secondAuthor = CachedAuthor.testAuthor()
                    secondAuthor.name = firstAuthor.name
                    secondAuthor.quotes.append(thirdQuote)
                    
                    if let realm = (quoteDao as? DefaultQuoteDao)?.realm {
                        try? realm.write {
                            realm.add(firstAuthor)
                            realm.add(secondAuthor)
                            try? realm.commitWrite()
                        }
                    }

                    expect { try quoteDao.findQuotes(byAuthor: firstAuthor.name).waitingCompletion().first.map({ $0.map({ $0.thaw() })}) }.to(equal([firstQuote, secondQuote, thirdQuote]))
                }
            }
            
            context("Found authors without quotes") {
                it("Error is thrown") {  () -> Void in
                    let firstAuthor = CachedAuthor.testAuthor()
                    let secondAuthor = CachedAuthor.testAuthor()
                    secondAuthor.name = firstAuthor.name
                    
                    if let realm = (quoteDao as? DefaultQuoteDao)?.realm {
                        try? realm.write {
                            realm.add(firstAuthor)
                            realm.add(secondAuthor)
                            realm.add([firstQuote, secondQuote, thirdQuote])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try quoteDao.findQuotes(byAuthor: firstAuthor.name).waitingCompletion().first.map({ $0.map({ $0.thaw() })}) }.to(throwError())
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    let firstAuthor = CachedAuthor.testAuthor()
                    firstAuthor.quotes.append(objectsIn: [firstQuote, secondQuote])
                    let secondAuthor = CachedAuthor.testAuthor()
                    secondAuthor.name = firstAuthor.name
                    secondAuthor.quotes.append(thirdQuote)
                    
                    if let realm = (quoteDao as? DefaultQuoteDao)?.realm {
                        try? realm.write {
                            realm.add(firstAuthor)
                            realm.add(secondAuthor)
                            try? realm.commitWrite()
                        }
                    }

                    expect { try quoteDao.findQuotes(byAuthor: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find quotes by idBook") {
            context("Found") {
                it("Quotes are returned") {  () -> Void in
                    let book = CachedBook.testBook()
                    book.quotes.append(objectsIn: [firstQuote, secondQuote])
                    
                    if let realm = (quoteDao as? DefaultQuoteDao)?.realm {
                        try? realm.write {
                            realm.add(book)
                            realm.add( thirdQuote)
                            try? realm.commitWrite()
                        }
                    }

                    expect { try quoteDao.findQuotes(byIdBook: book.idBook).waitingCompletion().first }.to(equal([firstQuote, secondQuote]))
                }
            }
            
            context("Not found") {
                it("An Error is thrown") {  () -> Void in
                    let book = CachedBook.testBook()
                    
                    if let realm = (quoteDao as? DefaultQuoteDao)?.realm {
                        try? realm.write {
                            realm.add(book)
                            realm.add([firstQuote, secondQuote, thirdQuote])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try quoteDao.findQuotes(byIdBook: book.idBook).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find quotes by book name") {
            context("Found") {
                it("Quotes are returned ") {  () -> Void in
                    let firstBook = CachedBook.testBook()
                    firstBook.quotes.append(objectsIn: [firstQuote, secondQuote])
                    let secondBook = CachedBook.testBook()
                    secondBook.name = firstBook.name
                    secondBook.quotes.append(thirdQuote)
                    
                    if let realm = (quoteDao as? DefaultQuoteDao)?.realm {
                        try? realm.write {
                            realm.add(firstBook)
                            realm.add(secondBook)
                            try? realm.commitWrite()
                        }
                    }

                    expect { try quoteDao.findQuotes(byBook: firstBook.name).waitingCompletion().first }.to(equal([firstQuote, secondQuote, thirdQuote]))
                }
            }
            
            context("Found books without quotes") {
                it("Error is thrown") {  () -> Void in
                    let firstBook = CachedBook.testBook()
                    let secondBook = CachedBook.testBook()
                    secondBook.name = firstBook.name
                    
                    if let realm = (quoteDao as? DefaultQuoteDao)?.realm {
                        try? realm.write {
                            realm.add(firstBook)
                            realm.add(secondBook)
                            realm.add([firstQuote, secondQuote, thirdQuote])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try quoteDao.findQuotes(byBook: firstBook.name).waitingCompletion().first }.to(throwError())
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    let firstBook = CachedBook.testBook()
                    firstBook.quotes.append(objectsIn: [firstQuote, secondQuote])
                    let secondBook = CachedBook.testBook()
                    secondBook.name = firstBook.name
                    secondBook.quotes.append(thirdQuote)
                    
                    if let realm = (quoteDao as? DefaultQuoteDao)?.realm {
                        try? realm.write {
                            realm.add(firstBook)
                            realm.add(secondBook)
                            try? realm.commitWrite()
                        }
                    }

                    expect { try quoteDao.findQuotes(byBook: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find quotes by idMovement") {
            context("Found") {
                it("Quotes are returned") {  () -> Void in
                    let movement = CachedMovement.testMovement()
                    
                    let author = CachedAuthor.testAuthor()
                    author.quotes.append(objectsIn: [firstQuote, secondQuote])
                    movement.authors.append(author)
                    
                    let book = CachedBook.testBook()
                    book.quotes.append(thirdQuote)
                    movement.books.append(book)
                    
                    if let realm = (quoteDao as? DefaultQuoteDao)?.realm {
                        try? realm.write {
                            realm.add(movement)
                            try? realm.commitWrite()
                        }
                    }

                    expect { try quoteDao.findQuotes(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal([firstQuote, secondQuote, thirdQuote]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    let movement = CachedMovement.testMovement()
                    
                    let author = CachedAuthor.testAuthor()
                    author.quotes.append(objectsIn: [firstQuote, secondQuote])
                    
                    let book = CachedBook.testBook()
                    book.quotes.append(thirdQuote)
                    
                    if let realm = (quoteDao as? DefaultQuoteDao)?.realm {
                        try? realm.write {
                            realm.add(movement)
                            realm.add(author)
                            realm.add(book)
                            realm.add([firstQuote, secondQuote, thirdQuote])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try quoteDao.findQuotes(byIdMovement: movement.idMovement).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find quotes by movement name") {
            context("Found") {
                it("Quotes are returned") {  () -> Void in
                    let firstMovement = CachedMovement.testMovement()
                    let secondMovement = CachedMovement.testMovement()
                    secondMovement.name = firstMovement.name
                    
                    let book = CachedBook.testBook()
                    book.quotes.append(objectsIn: [firstQuote, secondQuote])
                    firstMovement.books.append(book)
                    
                    let author = CachedAuthor.testAuthor()
                    author.quotes.append(thirdQuote)
                    secondMovement.authors.append(author)
                    
                    if let realm = (quoteDao as? DefaultQuoteDao)?.realm {
                        try? realm.write {
                            realm.add(firstMovement)
                            realm.add(secondMovement)
                            try? realm.commitWrite()
                        }
                    }

                    expect { try quoteDao.findQuotes(byMovement: firstMovement.name).waitingCompletion().first.map({ $0.map({ $0.thaw() })}) }.to(equal([firstQuote, secondQuote, thirdQuote]))
                }
            }
            
            context("Found movements without quotes") {
                it("Error is thrown") {  () -> Void in
                    let firstMovement = CachedMovement.testMovement()
                    let secondMovement = CachedMovement.testMovement()
                    secondMovement.name = firstMovement.name
                    
                    let book = CachedBook.testBook()
                    book.quotes.append(objectsIn: [firstQuote, secondQuote])
                    
                    let author = CachedAuthor.testAuthor()
                    author.quotes.append(thirdQuote)
                    
                    if let realm = (quoteDao as? DefaultQuoteDao)?.realm {
                        try? realm.write {
                            realm.add(firstMovement)
                            realm.add(secondMovement)
                            realm.add(book)
                            realm.add(author)
                            realm.add([firstQuote, secondQuote, thirdQuote])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try quoteDao.findQuotes(byMovement: firstMovement.name).waitingCompletion().first }.to(throwError())
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    let firstMovement = CachedMovement.testMovement()
                    let secondMovement = CachedMovement.testMovement()
                    secondMovement.name = firstMovement.name
                    
                    let book = CachedBook.testBook()
                    book.quotes.append(objectsIn: [firstQuote, secondQuote])
                    firstMovement.books.append(book)
                    
                    let author = CachedAuthor.testAuthor()
                    author.quotes.append(thirdQuote)
                    secondMovement.authors.append(author)
                    
                    if let realm = (quoteDao as? DefaultQuoteDao)?.realm {
                        try? realm.write {
                            realm.add(firstMovement)
                            realm.add(secondMovement)
                            try? realm.commitWrite()
                        }
                    }

                    expect { try quoteDao.findQuotes(byMovement: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find quotes by idTheme") {
            context("Found") {
                it("Quotes are returned") {  () -> Void in
                    let theme = CachedTheme.testTheme()
                    
                    let author = CachedAuthor.testAuthor()
                    author.quotes.append(objectsIn: [firstQuote, secondQuote])
                    theme.authors.append(author)
                    
                    let book = CachedBook.testBook()
                    book.quotes.append(thirdQuote)
                    theme.books.append(book)
                    
                    if let realm = (quoteDao as? DefaultQuoteDao)?.realm {
                        try? realm.write {
                            realm.add(theme)
                            try? realm.commitWrite()
                        }
                    }

                    expect { try quoteDao.findQuotes(byIdTheme: theme.idTheme).waitingCompletion().first.map({ $0.map({ $0.thaw() }) }) }.to(equal([firstQuote, secondQuote, thirdQuote]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    let theme = CachedTheme.testTheme()
                    
                    let author = CachedAuthor.testAuthor()
                    author.quotes.append(objectsIn: [firstQuote, secondQuote])
                    
                    let book = CachedBook.testBook()
                    book.quotes.append(thirdQuote)
                    
                    if let realm = (quoteDao as? DefaultQuoteDao)?.realm {
                        try? realm.write {
                            realm.add(theme)
                            realm.add(author)
                            realm.add(book)
                            realm.add([firstQuote, secondQuote, thirdQuote])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try quoteDao.findQuotes(byIdTheme: theme.idTheme).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find quotes by theme name") {
            context("Found") {
                it("Quotes are returned") {  () -> Void in
                    let firstTheme = CachedTheme.testTheme()
                    let secondTheme = CachedTheme.testTheme()
                    secondTheme.name = firstTheme.name
                    
                    let book = CachedBook.testBook()
                    book.quotes.append(objectsIn: [firstQuote, secondQuote])
                    firstTheme.books.append(book)
                    
                    let author = CachedAuthor.testAuthor()
                    author.quotes.append(thirdQuote)
                    secondTheme.authors.append(author)
                    
                    if let realm = (quoteDao as? DefaultQuoteDao)?.realm {
                        try? realm.write {
                            realm.add(firstTheme)
                            realm.add(secondTheme)
                            try? realm.commitWrite()
                        }
                    }

                    expect { try quoteDao.findQuotes(byTheme: firstTheme.name).waitingCompletion().first.map({ $0.map({ $0.thaw() }) }) }.to(equal([firstQuote, secondQuote, thirdQuote]))
                }
            }
            
            context("Found themes without quotes") {
                it("Error is thrown") {  () -> Void in
                    let firstTheme = CachedTheme.testTheme()
                    let secondTheme = CachedTheme.testTheme()
                    secondTheme.name = firstTheme.name
                    
                    let book = CachedBook.testBook()
                    book.quotes.append(objectsIn: [firstQuote, secondQuote])
                    
                    let author = CachedAuthor.testAuthor()
                    author.quotes.append(thirdQuote)
                    
                    if let realm = (quoteDao as? DefaultQuoteDao)?.realm {
                        try? realm.write {
                            realm.add(firstTheme)
                            realm.add(secondTheme)
                            realm.add(book)
                            realm.add(author)
                            realm.add([firstQuote, secondQuote, thirdQuote])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try quoteDao.findQuotes(byTheme: firstTheme.name).waitingCompletion().first }.to(throwError())
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    let firstTheme = CachedTheme.testTheme()
                    let secondTheme = CachedTheme.testTheme()
                    secondTheme.name = firstTheme.name
                    
                    let book = CachedBook.testBook()
                    book.quotes.append(objectsIn: [firstQuote, secondQuote])
                    firstTheme.books.append(book)
                    
                    let author = CachedAuthor.testAuthor()
                    author.quotes.append(thirdQuote)
                    secondTheme.authors.append(author)
                    
                    if let realm = (quoteDao as? DefaultQuoteDao)?.realm {
                        try? realm.write {
                            realm.add(firstTheme)
                            realm.add(secondTheme)
                            try? realm.commitWrite()
                        }
                    }

                    expect { try quoteDao.findQuotes(byTheme: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all quotes") {
            context("Found") {
                it("All Quotes are returned") {  () -> Void in
                    if let realm = (quoteDao as? DefaultQuoteDao)?.realm {
                        try? realm.write {
                            realm.add([firstQuote, secondQuote, thirdQuote])
                            try? realm.commitWrite()
                        }
                    }

                    await expect { try await quoteDao.findAllQuotes().value.map({ $0.thaw() }) }.to(equal([firstQuote, secondQuote, thirdQuote]))
                }
            }
            
            context("Database empty") {
                it("An Error is thrown") {  () -> Void in
                    await expect { try await quoteDao.findAllQuotes().value }.to(throwError())
                }
            }
        }
    }
}

extension CachedQuote {
    
    internal static func testQuote() -> CachedQuote {
        CachedQuote(idQuote: UUID().uuidString,
                    topics: [CachedTopic.testTopic()].toList(),
                    language: .none,
                    quote: DataFactory.randomString(),
                    source: DataFactory.randomString(),
                    reference: DataFactory.randomString(),
                    remarque: DataFactory.randomString(),
                    comment: DataFactory.randomString(),
                    commentName: DataFactory.randomString())
    }
}
