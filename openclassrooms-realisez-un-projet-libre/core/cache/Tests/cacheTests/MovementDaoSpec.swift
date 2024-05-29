//
//  MovementDaoSpec.swift
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

class MovementDaoSpec: QuickSpec {
    
    override func spec() {
        
        var movementDatabase : Realm!
        var movementDao : MovementDao!
        
        var firstMovement: CachedMovement!
        var secondMovement: CachedMovement!
        var thirdMovement: CachedMovement!
        
        beforeEach {
            DatabaseModule.realm.register {
                let configuration = Realm.Configuration(inMemoryIdentifier: "cached-movement-dao-testing")
                Realm.Configuration.defaultConfiguration = configuration
                movementDatabase = try? Realm()
                return movementDatabase
            }
            movementDao = DefaultMovementDao()
            
            firstMovement = CachedMovement.testMovement()
            secondMovement = CachedMovement.testMovement()
            thirdMovement = CachedMovement.testMovement()
        }
        
        afterEach {  () -> Void in
            if let realm = (movementDao as? DefaultMovementDao)?.realm {
                try? realm.write {
                    realm.deleteAll()
                    try? realm.commitWrite()
                }
            }
        }
        
        describe("Find movement by idMovement") {
            context("Found") {
                it("Movement is returned") {  () -> Void in
                    if let realm = (movementDao as? DefaultMovementDao)?.realm {
                        try? realm.write {
                            realm.add([firstMovement, secondMovement, thirdMovement])
                            try? realm.commitWrite()
                        }
                    }

                    await expect { try await movementDao.findMovement(byIdMovement: firstMovement.idMovement).value.thaw() }.to(equal(firstMovement))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    if let realm = (movementDao as? DefaultMovementDao)?.realm {
                        try? realm.write {
                            realm.add([secondMovement, thirdMovement])
                            try? realm.commitWrite()
                        }
                    }
                    
                    await expect { try await movementDao.findMovement(byIdMovement: firstMovement.idMovement).value }.to(throwError())
                }
            }
        }
        
        describe("Find movements by name") {
            context("Found") {
                it("Movements are returned") {  () -> Void in
                    secondMovement.name = firstMovement.name
                    
                    if let realm = (movementDao as? DefaultMovementDao)?.realm {
                        try? realm.write {
                            realm.add([firstMovement, secondMovement, thirdMovement])
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try movementDao.findMovements(byName: firstMovement.name).waitingCompletion().first }.to(equal([firstMovement, secondMovement]))
                }
            }
            
            context("Found with idRelatedMovements") {
                it("Movements are returned") {  () -> Void in
                    firstMovement.idRelatedMovements.append(secondMovement.idMovement)
                    
                    if let realm = (movementDao as? DefaultMovementDao)?.realm {
                        try? realm.write {
                            realm.add([firstMovement, secondMovement, thirdMovement])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try movementDao.findMovements(byName: firstMovement.name).waitingCompletion().first }.to(equal([firstMovement, secondMovement]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    secondMovement.name = firstMovement.name
                    
                    if let realm = (movementDao as? DefaultMovementDao)?.realm {
                        try? realm.write {
                            realm.add([firstMovement, secondMovement, thirdMovement])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try movementDao.findMovements(byName: DataFactory.randomString()).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        
        
        describe("Find movements by idParent") {
            context("Found") {
                it("Movements are returned") {  () -> Void in
                    firstMovement.movements.append(objectsIn: [secondMovement, thirdMovement])
                    
                    if let realm = (movementDao as? DefaultMovementDao)?.realm {
                        try? realm.write {
                            realm.add([firstMovement, secondMovement, thirdMovement])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try movementDao.findMovements(byIdParent: firstMovement.idMovement).waitingCompletion().first }.to(equal([secondMovement, thirdMovement]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    if let realm = (movementDao as? DefaultMovementDao)?.realm {
                        try? realm.write {
                            realm.add([firstMovement, secondMovement, thirdMovement])
                            try? realm.commitWrite()
                        }
                    }

                    expect { try movementDao.findMovements(byIdParent: UUID().uuidString).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find main Movements") {
            context("Found") {
                it("Main movements are returned") {  () -> Void in
                    firstMovement.idParentMovement = nil
                    secondMovement.idParentMovement = nil
                    
                    if let realm = (movementDao as? DefaultMovementDao)?.realm {
                        try? realm.write {
                            realm.add([firstMovement, secondMovement, thirdMovement])
                            try? realm.commitWrite()
                        }
                    }

                    await expect { try await movementDao.findMainMovements().value.map({ $0.thaw() }) }.to(equal([firstMovement, secondMovement]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {  () -> Void in
                    if let realm = (movementDao as? DefaultMovementDao)?.realm {
                        try? realm.write {
                            realm.add([firstMovement, secondMovement, thirdMovement])
                            try? realm.commitWrite()
                        }
                    }

                    await expect { try await movementDao.findMainMovements().value }.to(throwError())
                }
            }
        }
        
        describe("Find all movements") {
            context("Found") {
                it("All Movements are returned") {  () -> Void in
                    if let realm = (movementDao as? DefaultMovementDao)?.realm {
                        try? realm.write {
                            realm.add([firstMovement, secondMovement, thirdMovement])
                            try? realm.commitWrite()
                        }
                    }

                    await expect { try await movementDao.findAllMovements().value.map({ $0.thaw() }) }.to(equal([firstMovement, secondMovement, thirdMovement]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") {  () -> Void in
                    await expect { try await movementDao.findAllMovements().value }.to(throwError())
                }
            }
        }
    }
}

extension CachedMovement {
    
    internal static func testMovement() -> CachedMovement {
        CachedMovement(idMovement: UUID().uuidString,
                       idParentMovement: UUID().uuidString,
                       name: DataFactory.randomString(),
                       language: .none,
                       idRelatedMovements: List<String>(),
                       mcc1: DataFactory.randomString(),
                       mcc2: DataFactory.randomString(),
                       presentation: CachedPresentation.testPresentation(),
                       mcc3: DataFactory.randomString(),
                       nbQuotes: DataFactory.randomInt(),
                       nbAuthors: DataFactory.randomInt(),
                       nbAuthorsQuotes: DataFactory.randomInt(),
                       nbBooks: DataFactory.randomInt(),
                       nbBooksQuotes: DataFactory.randomInt(),
                       selected: DataFactory.randomBoolean(),
                       nbTotalQuotes: DataFactory.randomInt(),
                       nbTotalAuthors: DataFactory.randomInt(),
                       nbTotalBooks: DataFactory.randomInt(),
                       nbSubcourants: DataFactory.randomInt(),
                       nbAuthorsSubcourants: DataFactory.randomInt(),
                       nbBooksSubcourants: DataFactory.randomInt(),
                       authors: List<CachedAuthor>(),
                       books: List<CachedBook>(),
                       movements: List<CachedMovement>(),
                       pictures: List<CachedPicture>(),
                       urls: List<CachedUrl>(),
                       topics: List<CachedTopic>())
    }
}
