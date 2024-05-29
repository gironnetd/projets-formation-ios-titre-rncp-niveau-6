//
//  CenturyDaoSpec.swift
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

class CenturyDaoSpec: QuickSpec {
    
    override func spec() {
        var centuryDatabase : Realm!
        var centuryDao : CenturyDao!
        
        var firstCentury: CachedCentury!
        var secondCentury: CachedCentury!
        var thirdCentury: CachedCentury!
        
        beforeEach {
            DatabaseModule.realm.register {
                let configuration = Realm.Configuration(inMemoryIdentifier: "cached-century-dao-testing")
                Realm.Configuration.defaultConfiguration = configuration
                centuryDatabase = try? Realm()
                return centuryDatabase
            }
            centuryDao = DefaultCenturyDao()
            
            firstCentury = CachedCentury.testCentury()
            secondCentury = CachedCentury.testCentury()
            thirdCentury = CachedCentury.testCentury()
        }
        
        afterEach { () -> Void in
            if let realm = (centuryDao as? DefaultCenturyDao)?.realm {
                try? realm.write {
                    realm.deleteAll()
                    try? realm.commitWrite()
                }
            }
        }
        
        describe("Find century by idCentury") {
            context("Found") {
                it("Century is returned") {  () -> Void in
                    if let realm = (centuryDao as? DefaultCenturyDao)?.realm {
                        try? realm.write {
                            realm.add([firstCentury, secondCentury, thirdCentury])
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try centuryDao.findCentury(byIdCentury: firstCentury.idCentury).waitingCompletion().first }.to(equal(firstCentury))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    if let realm = (centuryDao as? DefaultCenturyDao)?.realm {
                        try? realm.write {
                            realm.add([secondCentury, thirdCentury])
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try centuryDao.findCentury(byIdCentury: firstCentury.idCentury).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find century by idAuthor") {
            context("Found") {
                it("Century is returned") {  () -> Void in
                    let author = CachedAuthor.testAuthor()
                    
                    if let realm = (centuryDao as? DefaultCenturyDao)?.realm {
                        try? realm.write {
                            realm.add(author)
                            realm.add([firstCentury, secondCentury, thirdCentury])
                            
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try centuryDao.findCentury(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(equal(author.century))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    let author = CachedAuthor.testAuthor()
                    
                    if let realm = (centuryDao as? DefaultCenturyDao)?.realm {
                        try? realm.write {
                            realm.add([firstCentury, secondCentury, thirdCentury])
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try centuryDao.findCentury(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(throwError())
                }
            }
            
        }
        
        describe("Find century by idBook") {
            context("Found") {
                it("Century is returned") {  () -> Void in
                    let book = CachedBook.testBook()
                    
                    if let realm = (centuryDao as? DefaultCenturyDao)?.realm {
                        try? realm.write {
                            realm.add(book)
                            realm.add([firstCentury, secondCentury, thirdCentury])
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try centuryDao.findCentury(byIdBook: book.idBook).waitingCompletion().first }.to(equal(book.century))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    let book = CachedBook.testBook()
                    
                    if let realm = (centuryDao as? DefaultCenturyDao)?.realm {
                        try? realm.write {
                            realm.add([firstCentury, secondCentury, thirdCentury])
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try centuryDao.findCentury(byIdBook: book.idBook).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find century by name") {
            context("Found") {
                it("Century is returned") {  () -> Void in
                    if let realm = (centuryDao as? DefaultCenturyDao)?.realm {
                        try? realm.write {
                            realm.add([firstCentury, secondCentury, thirdCentury])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try centuryDao.findCentury(byName: firstCentury.century).waitingCompletion().first }.to(equal(firstCentury))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    if let realm = (centuryDao as? DefaultCenturyDao)?.realm {
                        try? realm.write {
                            realm.add([secondCentury, thirdCentury])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try centuryDao.findCentury(byName: firstCentury.century).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all centuries") {
            context("Found") {
                it("All Centuries are returned") {  () -> Void in
                    if let realm = (centuryDao as? DefaultCenturyDao)?.realm {
                        try? realm.write {
                            realm.add([firstCentury, secondCentury, thirdCentury])
                            try? realm.commitWrite()
                        }
                    }

                    await expect { try await centuryDao.findAllCenturies().value.map { $0.thaw()} }.to(equal([firstCentury, secondCentury, thirdCentury]))
                }
            }
            
            context("Database empty") {
                it("An Error is thrown") {  () -> Void in
                    await expect { try await centuryDao.findAllCenturies().value }.to(throwError())
                }
            }
        }
    }
}

extension CachedCentury {
    internal static func testCentury() -> CachedCentury {
        CachedCentury(idCentury: DataFactory.randomString(),
                      century: DataFactory.randomString(),
                      presentations: ["String" : "String"].toMap(),
                      topics: [CachedTopic.testTopic()].toList())
    }
}
