//
//  CenturyRepositorySpec.swift
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
class CenturyRepositorySpec: QuickSpec {
    
    @LazyInjected(DaosModule.centuryDao) private var centuryDao
    
    override func spec() {
        
        var centuryRepository: DefaultCenturyRepository!
        
        var firstCentury: Century!
        var secondCentury: Century!
        var thirdCentury: Century!
        
        beforeSuite { @MainActor () -> Void in
            DaosModule.centuryDao.register(factory: { TestCenturyDao() })
        }
        
        beforeEach {
            centuryRepository = DefaultCenturyRepository()
            
            firstCentury = Century.testCentury()
            secondCentury = Century.testCentury()
            thirdCentury = Century.testCentury()
        }
        
        afterEach { @MainActor () -> Void in
            (self.centuryDao as? TestCenturyDao)?.centuries = []
            (self.centuryDao as? TestCenturyDao)?.authors = []
            (self.centuryDao as? TestCenturyDao)?.books = []
            (self.centuryDao as? TestCenturyDao)?.movements = []
        }
        
        describe("Find century by idCentury") {
            context("Found") {
                it("Century is returned") { @MainActor () -> Void in

                    (self.centuryDao as? TestCenturyDao)?.centuries.append(contentsOf: [firstCentury.asCached(), secondCentury.asCached(), thirdCentury.asCached()])
                    
                    expect { try centuryRepository.findCentury(byIdCentury: firstCentury.idCentury).waitingCompletion().first }.to(equal(firstCentury))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    (self.centuryDao as? TestCenturyDao)?.centuries.append(contentsOf: [secondCentury.asCached(), thirdCentury.asCached()])
                    
                    expect { try centuryRepository.findCentury(byIdCentury: firstCentury.idCentury).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find century by idAuthor") {
            context("Found") {
                it("Century is returned") { @MainActor () -> Void in
                    let author = Author.testAuthor()

                    (self.centuryDao as? TestCenturyDao)?.authors.append(author.asCached())
                    
                    (self.centuryDao as? TestCenturyDao)?.centuries.append(contentsOf: [firstCentury.asCached(), secondCentury.asCached(), thirdCentury.asCached()])
                    
                    expect { try centuryRepository.findCentury(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(equal(author.century))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    let author = CachedAuthor.testAuthor()

                    (self.centuryDao as? TestCenturyDao)?.centuries.append(contentsOf: [firstCentury.asCached(), secondCentury.asCached(), thirdCentury.asCached()])
                    expect { try centuryRepository.findCentury(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(throwError())
                }
            }
            
        }
        
        describe("Find century by idBook") {
            context("Found") {
                it("Century is returned") { @MainActor () -> Void in
                    let book = Book.testBook()

                    (self.centuryDao as? TestCenturyDao)?.books.append(book.asCached())
                    (self.centuryDao as? TestCenturyDao)?.centuries.append(contentsOf: [firstCentury.asCached(), secondCentury.asCached(), thirdCentury.asCached()])
                    
                    expect { try centuryRepository.findCentury(byIdBook: book.idBook).waitingCompletion().first }.to(equal(book.century))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    let book = CachedBook.testBook()

                    (self.centuryDao as? TestCenturyDao)?.centuries.append(contentsOf: [firstCentury.asCached(), secondCentury.asCached(), thirdCentury.asCached()])
                    expect { try centuryRepository.findCentury(byIdBook: book.idBook).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find century by name") {
            context("Found") {
                it("Century is returned") { @MainActor () -> Void in
                    (self.centuryDao as? TestCenturyDao)?.centuries.append(contentsOf: [firstCentury.asCached(), secondCentury.asCached(), thirdCentury.asCached()])
                    
                    expect { try centuryRepository.findCentury(byName: firstCentury.century).waitingCompletion().first }.to(equal(firstCentury))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    (self.centuryDao as? TestCenturyDao)?.centuries.append(contentsOf: [secondCentury.asCached(), thirdCentury.asCached()])
                    
                    expect { try centuryRepository.findCentury(byName: firstCentury.century).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all centuries") {
            context("Found") {
                it("All centuries are returned") { @MainActor () -> Void in
                    (self.centuryDao as? TestCenturyDao)?.centuries.append(contentsOf: [firstCentury.asCached(), secondCentury.asCached(), thirdCentury.asCached()])
                    
                    await expect { try centuryRepository.findAllCenturies().waitingCompletion().first }.to(equal([firstCentury, secondCentury, thirdCentury]))
                }
            }
            
            context("Database empty") {
                it("An Error is thrown") { @MainActor () -> Void in
                    await expect { try centuryRepository.findAllCenturies().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}
