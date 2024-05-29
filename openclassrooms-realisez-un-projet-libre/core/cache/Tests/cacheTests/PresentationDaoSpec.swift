//
//  PresentationDaoSpec.swift
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

class PresentationDaoSpec: QuickSpec {
    
    override func spec() {
        
        var presentationDatabase : Realm!
        var presentationDao : PresentationDao!
        
        var firstPresentation: CachedPresentation!
        var secondPresentation: CachedPresentation!
        var thirdPresentation: CachedPresentation!
        
        beforeEach {
            DatabaseModule.realm.register {
                let configuration = Realm.Configuration(inMemoryIdentifier: "cached-presentation-dao-testing")
                Realm.Configuration.defaultConfiguration = configuration
                presentationDatabase = try? Realm()
                return presentationDatabase
            }
            presentationDao = DefaultPresentationDao()
            
            firstPresentation = CachedPresentation.testPresentation()
            secondPresentation = CachedPresentation.testPresentation()
            thirdPresentation = CachedPresentation.testPresentation()
        }
        
        afterEach {  () -> Void in
            if let realm = (presentationDao as? DefaultPresentationDao)?.realm {
                try? realm.write {
                    realm.deleteAll()
                    try? realm.commitWrite()
                }
            }
        }
        
        describe("Find presentation by idPresentation") {
            context("Found") {
                it("Presentation is returned") {  () -> Void in
                    if let realm = (presentationDao as? DefaultPresentationDao)?.realm {
                        try? realm.write {
                            realm.add([firstPresentation, secondPresentation, thirdPresentation])
                            try? realm.commitWrite()
                        }
                    }

                    await expect { try await presentationDao.findPresentation(byIdPresentation: firstPresentation.idPresentation).value.thaw() }.to(equal(firstPresentation))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    if let realm = (presentationDao as? DefaultPresentationDao)?.realm {
                        try? realm.write {
                            realm.add([secondPresentation, thirdPresentation])
                            try? realm.commitWrite()
                        }
                    }

                    await expect { try await presentationDao.findPresentation(byIdPresentation: firstPresentation.idPresentation).value }.to(throwError())
                }
            }
        }
        
        describe("Find presentation by idAuthor") {
            context("Found") {
                it("Presentation is returned") {  () -> Void in
                    let author = CachedAuthor.testAuthor()
                    
                    if let realm = (presentationDao as? DefaultPresentationDao)?.realm {
                        try? realm.write {
                            realm.add(author)
                            realm.add([firstPresentation, secondPresentation, thirdPresentation])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try presentationDao.findPresentation(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(equal(author.presentation))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    let author = CachedAuthor.testAuthor()
                    
                    if let realm = (presentationDao as? DefaultPresentationDao)?.realm {
                        try? realm.write {
                            realm.add([firstPresentation, secondPresentation, thirdPresentation])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try presentationDao.findPresentation(byIdAuthor: author.idAuthor).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        
        
        describe("Find presentation by idBook") {
            context("Found") {
                it("Presentation is returned") {  () -> Void in
                    let book = CachedBook.testBook()
                    
                    if let realm = (presentationDao as? DefaultPresentationDao)?.realm {
                        try? realm.write {
                            realm.add(book)
                            realm.add([firstPresentation, secondPresentation, thirdPresentation])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try presentationDao.findPresentation(byIdBook: book.idBook).waitingCompletion().first }.to(equal(book.presentation))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    let book = CachedBook.testBook()
                    
                    if let realm = (presentationDao as? DefaultPresentationDao)?.realm {
                        try? realm.write {
                            realm.add([firstPresentation, secondPresentation, thirdPresentation])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try presentationDao.findPresentation(byIdBook: book.idBook).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find presentation by idMovement") {
            context("Found") {
                it("Presentation is returned") {  () -> Void in
                    let movement = CachedMovement.testMovement()
                    
                    if let realm = (presentationDao as? DefaultPresentationDao)?.realm {
                        try? realm.write {
                            realm.add(movement)
                            realm.add([firstPresentation, secondPresentation, thirdPresentation])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try presentationDao.findPresentation(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal(movement.presentation))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    let movement = CachedMovement.testMovement()
                    
                    if let realm = (presentationDao as? DefaultPresentationDao)?.realm {
                        try? realm.write {
                            realm.add([firstPresentation, secondPresentation, thirdPresentation])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try presentationDao.findPresentation(byIdMovement: movement.idMovement).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all presentations") {
            context("Found") {
                it("All presentations are returned") {  () -> Void in
                    if let realm = (presentationDao as? DefaultPresentationDao)?.realm {
                        try? realm.write {
                            realm.add([firstPresentation, secondPresentation, thirdPresentation])
                            try? realm.commitWrite()
                        }
                    }

                    await expect { try await presentationDao.findAllPresentations().value.map({ $0.thaw() }) }.to(equal([firstPresentation, secondPresentation, thirdPresentation]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") {  () -> Void in
                    await expect { try await presentationDao.findAllPresentations().value }.to(throwError())
                }
            }
        }
    }
}

extension CachedPresentation {
    
    internal static func testPresentation() -> CachedPresentation {
        CachedPresentation(idPresentation: UUID().uuidString,
                           language: .none,
                           presentation: DataFactory.randomString(),
                           presentationTitle1: DataFactory.randomString(),
                           presentation1: DataFactory.randomString(),
                           presentationTitle2: DataFactory.randomString(),
                           presentation2: DataFactory.randomString(),
                           presentationTitle3: DataFactory.randomString(),
                           presentation3: DataFactory.randomString(),
                           presentationTitle4: DataFactory.randomString(),
                           presentation4: DataFactory.randomString(),
                           sourcePresentation: DataFactory.randomString(),
                           topics: List<CachedTopic>()
        )
    }
}
