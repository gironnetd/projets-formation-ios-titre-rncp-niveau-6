//
//  AuthorDaoSpec.swift
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

class AuthorDaoSpec: QuickSpec {
    
    override func spec() {
        var authorDatabase: Realm!
        var authorDao: AuthorDao!
        
        var firstAuthor: CachedAuthor!
        var secondAuthor: CachedAuthor!
        var thirdAuthor: CachedAuthor!
        
        beforeEach {
            DatabaseModule.realm.register {
                let configuration = Realm.Configuration(inMemoryIdentifier: "cached-author-dao-testing")
                Realm.Configuration.defaultConfiguration = configuration
                authorDatabase = try? Realm()
                return authorDatabase
            }
            
            authorDao = DefaultAuthorDao()
            firstAuthor = CachedAuthor.testAuthor()
            secondAuthor = CachedAuthor.testAuthor()
            thirdAuthor = CachedAuthor.testAuthor()
        }
        
        afterEach {
            if let realm = (authorDao as? DefaultAuthorDao)?.realm {
                try? realm.write {
                    realm.deleteAll()
                    try? realm.commitWrite()
                }
            }
        }
        
        describe("Find author by idAuthor") {
            context("Found") {
                it("Author is returned") {
                    if let realm = (authorDao as? DefaultAuthorDao)?.realm {
                        try? realm.write {
                            realm.add(
                                [firstAuthor, secondAuthor, thirdAuthor],
                                update: .all
                            )
                            try? realm.commitWrite()
                        }
                    }
                    
                    await expect { try authorDao.findAuthor(byIdAuthor: firstAuthor.idAuthor).waitingCompletion().first?.thaw() }.to(equal(firstAuthor))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    if let realm = (authorDao as? DefaultAuthorDao)?.realm {
                        try? realm.write {
                            realm.add([secondAuthor, thirdAuthor])
                            try? realm.commitWrite()
                        }
                    }
                    
                    await expect { try authorDao.findAuthor(byIdAuthor: firstAuthor.idAuthor).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find authors by name") {
            context("Found") {
                it("Authors are returned") {
                    if let realm = (authorDao as? DefaultAuthorDao)?.realm {
                        try? realm.write {
                            secondAuthor.name = firstAuthor.name
                            realm.add([firstAuthor, secondAuthor, thirdAuthor])
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try authorDao.findAuthors(byName: firstAuthor.name).waitingCompletion().first }.to(equal([firstAuthor, secondAuthor]))
                }
            }
            
            context("Found with idRelatedAuthors") {
                it("Authors are returned") {
                    if let realm = (authorDao as? DefaultAuthorDao)?.realm {
                        try? realm.write {
                            firstAuthor.idRelatedAuthors.append(secondAuthor.idAuthor)
                            realm.add([firstAuthor, secondAuthor, thirdAuthor])
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try authorDao.findAuthors(byName: firstAuthor.name).waitingCompletion().first }.to(equal([firstAuthor, secondAuthor]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    if let realm = (authorDao as? DefaultAuthorDao)?.realm {
                        try? realm.write {
                            realm.add([secondAuthor, thirdAuthor])
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try authorDao.findAuthors(byName: firstAuthor.name).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find authors by idMovement") {
            context("Found") {
                it("Authors are returned") {
                    let movement = CachedMovement.testMovement()
                    
                    if let realm = (authorDao as? DefaultAuthorDao)?.realm {
                        try? realm.write {
                            
                            firstAuthor.idMovement = movement.idMovement
                            secondAuthor.idMovement = movement.idMovement
                            
                            movement.authors.append(objectsIn: [firstAuthor, secondAuthor])
                            
                            realm.add(movement)
                            
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try authorDao.findAuthors(byIdMovement: movement.idMovement).waitingCompletion().first }.to(equal([firstAuthor, secondAuthor]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    if let realm = (authorDao as? DefaultAuthorDao)?.realm {
                        try? realm.write {
                            let movement = CachedMovement.testMovement()
                            firstAuthor.idMovement = movement.idMovement
                            secondAuthor.idMovement = movement.idMovement
                            
                            movement.authors.append(objectsIn: [firstAuthor, secondAuthor])
                            
                            realm.add(movement)
                            realm.add(thirdAuthor)
                            
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try authorDao.findAuthors(byIdMovement: thirdAuthor.idMovement!).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find authors by idTheme") {
            context("Found") {
                it("Authors are returned") {
                    let theme = CachedTheme.testTheme()
                    
                    if let realm = (authorDao as? DefaultAuthorDao)?.realm {
                        try? realm.write {
                            
                            theme.authors.append(objectsIn: [firstAuthor, secondAuthor])
                            realm.add(theme, update: .all)
                            
                            try? realm.commitWrite()
                        }
                    }
                
                    expect { try authorDao.findAuthors(byIdTheme: theme.idTheme).waitingCompletion().first }.to(equal([firstAuthor, secondAuthor]))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let firstTheme = CachedTheme.testTheme()
                    let secondTheme = CachedTheme.testTheme()
                    
                    if let realm = (authorDao as? DefaultAuthorDao)?.realm {
                        try? realm.write {
                            
                            firstTheme.authors.append(objectsIn: [firstAuthor, secondAuthor])
                            
                            realm.add([firstTheme, secondTheme], update: .all)
                            realm.add(thirdAuthor)
                            
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try authorDao.findAuthors(byIdTheme: secondTheme.idTheme).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find author by idPresentation") {
            context("Found") {
                it("Author is returned") {
                    let presentation = CachedPresentation.testPresentation()
                    
                    if let realm = (authorDao as? DefaultAuthorDao)?.realm {
                        try? realm.write {
                            firstAuthor.presentation = presentation
                            realm.add([firstAuthor, secondAuthor, thirdAuthor], update: .all)
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try authorDao.findAuthor(byIdPresentation: presentation.idPresentation).waitingCompletion().first }.to(equal(firstAuthor))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let presentation = CachedPresentation.testPresentation()
                    
                    if let realm = (authorDao as? DefaultAuthorDao)?.realm {
                        try? realm.write {
                            realm.add(presentation)
                            realm.add([firstAuthor, secondAuthor, thirdAuthor], update: .all)
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try authorDao.findAuthor(byIdPresentation: presentation.idPresentation).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find author by idPicture") {
            context("Found") {
                it("Author is returned") {
                    let picture = CachedPicture.testPicture()
                    
                    if let realm = (authorDao as? DefaultAuthorDao)?.realm {
                        try? realm.write {
                            firstAuthor.pictures.append(picture)
                            realm.add([firstAuthor, secondAuthor, thirdAuthor], update: .all)
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try authorDao.findAuthor(byIdPicture: picture.idPicture).waitingCompletion().first }.to(equal(firstAuthor))
                }
            }
            
            context("Not found") {
                it("Error is thrown") {
                    let picture = CachedPicture.testPicture()
                    
                    if let realm = (authorDao as? DefaultAuthorDao)?.realm {
                        try? realm.write {
                            realm.add(picture)
                            realm.add([firstAuthor, secondAuthor, thirdAuthor], update: .all)
                            try? realm.commitWrite()
                        }
                    }
                    
                    expect { try authorDao.findAuthor(byIdPicture: picture.idPicture).waitingCompletion().first }.to(throwError())
                }
            }
        }
        
        describe("Find all authors") {
            context("Found") {
                it("All Authors are returned") {
                    if let realm = (authorDao as? DefaultAuthorDao)?.realm {
                        try? realm.write {
                            realm.add([firstAuthor, secondAuthor, thirdAuthor], update: .all)
                            try? realm.commitWrite()
                        }
                    }
                    
                    await expect { try await authorDao.findAllAuthors().value.map({ $0.thaw() }) }.to(equal([firstAuthor, secondAuthor, thirdAuthor]))
                }
            }
            
            context("Database empty") {
                it("Error is thrown") {
                    await expect { try await authorDao.findAllAuthors().value }.to(throwError())
                }
            }
        }
    }
}

extension CachedAuthor {
    
    internal static func testAuthor() -> CachedAuthor {
        CachedAuthor(idAuthor: DataFactory.randomString(),
                     language: .none,
                     name: DataFactory.randomString(),
                     idRelatedAuthors: [DataFactory.randomString()].toList(),
                     century: CachedCentury.testCentury(),
                     surname: DataFactory.randomString(),
                     details: DataFactory.randomString(),
                     period: DataFactory.randomString(),
                     idMovement: DataFactory.randomString(),
                     bibliography: DataFactory.randomString(),
                     presentation: CachedPresentation.testPresentation(),
                     mainPicture: DataFactory.randomInt(),
                     mcc1: DataFactory.randomString(),
                     quotes: [CachedQuote]().toList(),
                     pictures: [CachedPicture]().toList(),
                     urls: [CachedUrl]().toList(),
                     topics: [CachedTopic]().toList()
        )
    }
}

extension CachedTopic {
    internal static func testTopic() -> CachedTopic {
        CachedTopic(id: DataFactory.randomString(),
                    language: .none,
                    name: DataFactory.randomString(),
                    idResource: DataFactory.randomString(),
                    kind: .unknown)
    }
}
