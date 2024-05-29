//
//  UrlRepositorySpec.swift
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
class UrlRepositorySpec: QuickSpec {
    
    @LazyInjected(DaosModule.urlDao) private var urlDao
    
    override func spec() {
        
        var urlRepository: DefaultUrlRepository!
        
        var firstUrl: Url!
        var secondUrl: Url!
        var thirdUrl: Url!
        
        beforeSuite { @MainActor () -> Void in
            DaosModule.urlDao.register(factory: { TestUrlDao() })
        }
        
        beforeEach {
            urlRepository = DefaultUrlRepository()
            
            firstUrl = Url.testUrl()
            secondUrl = Url.testUrl()
            thirdUrl = Url.testUrl()
        }
        
        afterEach { @MainActor () -> Void in
            (self.urlDao as? TestUrlDao)?.urls = []
            (self.urlDao as? TestUrlDao)?.authors = []
            (self.urlDao as? TestUrlDao)?.books = []
            (self.urlDao as? TestUrlDao)?.movements = []
        }
        
        describe("Find url by idUrl") {
            context("Found") {
                it("Url is returned") { @MainActor () -> Void in
                    (self.urlDao as? TestUrlDao)?.urls.append(contentsOf:[firstUrl.asCached(), secondUrl.asCached(), thirdUrl.asCached()])
                    
                    expect { try urlRepository.findUrl(byIdUrl: firstUrl.idUrl).waitingCompletion().first }.to(equal(firstUrl))
                }
            }
            
            context("Not found") {
                it("An Error is thrown") { @MainActor () -> Void in
                    (self.urlDao as? TestUrlDao)?.urls.append(contentsOf:[secondUrl.asCached(), thirdUrl.asCached()])
                    
                    expect { try urlRepository.findUrl(byIdUrl: firstUrl.idUrl).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find urls by idAuthor") {
            context("Found") {
                it("Urls are returned") { @MainActor () -> Void in
                    var author = Author.testAuthor()
                    author.urls?.removeAll()
                    author.urls?.append(contentsOf: [firstUrl, secondUrl])
                    
                    (self.urlDao as? TestUrlDao)?.authors.append(author.asCached())
                    (self.urlDao as? TestUrlDao)?.urls.append(contentsOf:[firstUrl.asCached(), secondUrl.asCached(), thirdUrl.asCached()])
                    
                    expect { try urlRepository.findUrls(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(equal(author.urls))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    var author = Author.testAuthor()
                    author.urls?.removeAll()

                    (self.urlDao as? TestUrlDao)?.authors.append(author.asCached())
                    (self.urlDao as? TestUrlDao)?.urls.append(contentsOf:[firstUrl.asCached(), secondUrl.asCached(), thirdUrl.asCached()])
                    
                    expect { try urlRepository.findUrls(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find urls by idBook") {
            context("Found") {
                it("Urls are returned") { @MainActor () -> Void in
                    var book = Book.testBook()
                    book.urls?.removeAll()
                    book.urls?.append(contentsOf: [firstUrl, secondUrl])

                    (self.urlDao as? TestUrlDao)?.books.append(book.asCached())
                    (self.urlDao as? TestUrlDao)?.urls.append(contentsOf:[firstUrl.asCached(), secondUrl.asCached(), thirdUrl.asCached()])
                    
                    expect { try urlRepository.findUrls(byIdBook: book.idBook).waitingCompletion().first }.to(equal(book.urls))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    var book = Book.testBook()
                    book.urls?.removeAll()

                    (self.urlDao as? TestUrlDao)?.books.append(book.asCached())
                    (self.urlDao as? TestUrlDao)?.urls.append(contentsOf:[firstUrl.asCached(), secondUrl.asCached(), thirdUrl.asCached()])
                    
                    expect { try urlRepository.findUrls(byIdBook: book.idBook).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find urls by idMovement") {
            context("Found") {
                it("Urls are returned") { @MainActor () -> Void in
                    var movement = Movement.testMovement()
                    
                    movement.urls = [firstUrl, secondUrl]

                    (self.urlDao as? TestUrlDao)?.movements.append(movement.asCached())
                    (self.urlDao as? TestUrlDao)?.urls.append(contentsOf:[firstUrl.asCached(), secondUrl.asCached(), thirdUrl.asCached()])
                    
                    expect { try urlRepository.findUrls(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal(movement.urls))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    var movement = Movement.testMovement()
                    movement.urls?.removeAll()

                    (self.urlDao as? TestUrlDao)?.movements.append(movement.asCached())
                    (self.urlDao as? TestUrlDao)?.urls.append(contentsOf:[firstUrl.asCached(), secondUrl.asCached(), thirdUrl.asCached()])
                    
                    expect { try urlRepository.findUrls(byIdMovement: movement.idMovement).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find urls by idSource") {
            context("Found") {
                it("Urls are returned") { @MainActor () -> Void in
                    secondUrl.idSource = firstUrl.idSource
//                    secondUrl.sourceType = firstUrl.sourceType

                    (self.urlDao as? TestUrlDao)?.urls.append(contentsOf:[firstUrl.asCached(), secondUrl.asCached(), thirdUrl.asCached()])
                    
                    expect { try urlRepository.findUrls(byIdSource: firstUrl.idSource).waitingCompletion().first }.to(equal([firstUrl, secondUrl]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") { @MainActor () -> Void in
                    (self.urlDao as? TestUrlDao)?.urls.append(contentsOf:[firstUrl.asCached(), secondUrl.asCached(), thirdUrl.asCached()])
                    
                    expect { try urlRepository.findUrls(byIdSource: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all urls") {
            context("Found") {
                it("All Urls are returned") { @MainActor () -> Void in
                    (self.urlDao as? TestUrlDao)?.urls.append(contentsOf:[firstUrl.asCached(), secondUrl.asCached(), thirdUrl.asCached()])
                    
                    expect { try urlRepository.findAllUrls().waitingCompletion().first }.to(equal([firstUrl, secondUrl, thirdUrl]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") { @MainActor () -> Void in
                    expect { try urlRepository.findUrl(byIdUrl: firstUrl.idUrl).waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}
