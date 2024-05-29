//
//  UrlDaoSpec.swift
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

class UrlDaoSpec: QuickSpec {
    
    override func spec() {
        
        var urlDatabase : Realm!
        var urlDao : UrlDao!
        
        var firstUrl: CachedUrl!
        var secondUrl: CachedUrl!
        var thirdUrl: CachedUrl!
        
        beforeEach {
            DatabaseModule.realm.register {
                let configuration = Realm.Configuration(inMemoryIdentifier: "cached-url-dao-testing")
                Realm.Configuration.defaultConfiguration = configuration
                urlDatabase = try? Realm()
                return urlDatabase
            }
            urlDao = DefaultUrlDao()
            
            firstUrl = CachedUrl.testUrl()
            secondUrl = CachedUrl.testUrl()
            thirdUrl = CachedUrl.testUrl()
        }
        
        afterEach {  () -> Void in
            if let realm = (urlDao as? DefaultUrlDao)?.realm {
                try? realm.write {
                    realm.deleteAll()
                    try? realm.commitWrite()
                }
            }
        }
        
        describe("Find url by idUrl") {
            context("Found") {
                it("Url is returned") {  () -> Void in
                    if let realm = (urlDao as? DefaultUrlDao)?.realm {
                        try? realm.write {
                            realm.add([firstUrl, secondUrl, thirdUrl])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try urlDao.findUrl(byIdUrl: firstUrl.idUrl).waitingCompletion().first }.to(equal(firstUrl))
                }
            }
            
            context("Not found") {
                it("An Error is thrown") {  () -> Void in
                    if let realm = (urlDao as? DefaultUrlDao)?.realm {
                        try? realm.write {
                            realm.add([secondUrl, thirdUrl])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try urlDao.findUrl(byIdUrl: firstUrl.idUrl).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find urls by idAuthor") {
            context("Found") {
                it("Urls are returned") {  () -> Void in
                    let author = CachedAuthor.testAuthor()
                    author.urls.append(objectsIn: [firstUrl, secondUrl])
                    
                    if let realm = (urlDao as? DefaultUrlDao)?.realm {
                        try? realm.write {
                            realm.add(author)
                            try? realm.commitWrite()
                        }
                    }

                    expect { try urlDao.findUrls(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(equal(author.urls.toArray()))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    let author = CachedAuthor.testAuthor()
                    
                    if let realm = (urlDao as? DefaultUrlDao)?.realm {
                        try? realm.write {
                            realm.add(author)
                            realm.add([firstUrl, secondUrl, thirdUrl])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try urlDao.findUrls(byIdAuthor: author.idAuthor).waitingCompletion().first.map({ $0.map({ $0.thaw() }) }) }.to(throwError())
                }
            }
        }
        
        describe("Find urls by idBook") {
            context("Found") {
                it("Urls are returned") {  () -> Void in
                    let book = CachedBook.testBook()
                    book.urls.append(objectsIn: [firstUrl, secondUrl])
                    
                    if let realm = (urlDao as? DefaultUrlDao)?.realm {
                        try? realm.write {
                            realm.add(book)
                            try? realm.commitWrite()
                        }
                    }

                    expect { try urlDao.findUrls(byIdBook: book.idBook).waitingCompletion().first }.to(equal(book.urls.toArray()))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    let book = CachedBook.testBook()
                    
                    if let realm = (urlDao as? DefaultUrlDao)?.realm {
                        try? realm.write {
                            realm.add(book)
                            realm.add([firstUrl, secondUrl, thirdUrl])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try urlDao.findUrls(byIdBook: book.idBook).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find urls by idMovement") {
            context("Found") {
                it("Urls are returned") {  () -> Void in
                    let movement = CachedMovement.testMovement()
                    movement.urls.append(objectsIn: [firstUrl, secondUrl])
                    
                    if let realm = (urlDao as? DefaultUrlDao)?.realm {
                        try? realm.write {
                            realm.add(movement)
                            try? realm.commitWrite()
                        }
                    }

                    expect { try urlDao.findUrls(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal(movement.urls.toArray()))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    let movement = CachedMovement.testMovement()
                    
                    if let realm = (urlDao as? DefaultUrlDao)?.realm {
                        try? realm.write {
                            realm.add(movement)
                            realm.add([firstUrl, secondUrl, thirdUrl])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try urlDao.findUrls(byIdMovement: movement.idMovement).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find urls by idSource") {
            context("Found") {
                it("Urls are returned") {  () -> Void in
                    secondUrl.idSource = firstUrl.idSource
                    
                    if let realm = (urlDao as? DefaultUrlDao)?.realm {
                        try? realm.write {
                            realm.add([firstUrl, secondUrl, thirdUrl])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try urlDao.findUrls(byIdSource: firstUrl.idSource).waitingCompletion().first }.to(equal([firstUrl, secondUrl]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    if let realm = (urlDao as? DefaultUrlDao)?.realm {
                        try? realm.write {
                            realm.add([firstUrl, secondUrl, thirdUrl])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try urlDao.findUrls(byIdSource: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find urls by sourceType") {
            context("Found") {
                it("Urls are returned") {  () -> Void in
//                    secondUrl.sourceType = firstUrl.sourceType
                    
                    if let realm = (urlDao as? DefaultUrlDao)?.realm {
                        try? realm.write {
                            realm.add([firstUrl, secondUrl, thirdUrl])
                            try? realm.commitWrite()
                        }
                    }

//                    expect { try urlDao.findUrls(bySourceType: firstUrl.sourceType).waitingCompletion().first }.to(equal([firstUrl, secondUrl]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    if let realm = (urlDao as? DefaultUrlDao)?.realm {
                        try? realm.write {
                            realm.add([firstUrl, secondUrl, thirdUrl])
                            try? realm.commitWrite()
                        }
                    }

//                    expect { try urlDao.findUrls(bySourceType: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all urls") {
            context("Found") {
                it("All Urls are returned") {  () -> Void in
                    if let realm = (urlDao as? DefaultUrlDao)?.realm {
                        try? realm.write {
                            realm.add([firstUrl, secondUrl, thirdUrl])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try urlDao.findAllUrls().waitingCompletion().first }.to(equal([firstUrl, secondUrl, thirdUrl]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") {  () -> Void in
                    expect { try urlDao.findAllUrls().waitingCompletion().first }.to(throwError())
                }
            }
        }
    }
}

extension CachedUrl {
    
    internal static func testUrl() -> CachedUrl {
        CachedUrl(idUrl: UUID().uuidString,
                  idSource: UUID().uuidString,
                  title: DataFactory.randomString(),
                  url: DataFactory.randomString(),
                  presentation: DataFactory.randomString())
    }
}
